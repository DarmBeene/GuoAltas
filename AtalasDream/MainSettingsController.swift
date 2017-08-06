//
//  Settings.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/9/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
//for the main user interface of settings of this App.

import UIKit

private let userBasicInfoCellID = "userBasicInfoCellID"
private let settingsCellID = "settingsCellID"
private let LoginCellID = "LoginCellID"

class MainSettingsController: BaseTableController, UIGestureRecognizerDelegate {
    
    var cellNames = [["User"], ["我的发布", "我的收藏"], ["设置"]]
    var cellImageNames = [[""], ["myPublish", "favorite"], ["settings"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserBasicInfoCell.self, forCellReuseIdentifier: userBasicInfoCellID)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: settingsCellID)
        tableView.register(LoginCell.self, forCellReuseIdentifier: LoginCellID)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        title = "我"
//        hidesBottomBarWhenPushed = true
    }
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = FIRAuth.auth()?.addStateDidChangeListener({ (firAuth, firUser) in
            self.tableView.reloadData()
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellNames.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNames[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let user = FIRAuth.auth()?.currentUser {
                let cell = UserBasicInfoCell(style: .subtitle, reuseIdentifier: userBasicInfoCellID)
                if let urlString = user.photoURL?.absoluteString {
                    cell.profileImageView.loadImageFrom(urlString: urlString)
                    ADUser.shared.photoUrl = user.photoURL
                }else{
                    cell.profileImageView.image = UIImage(named: "anonymous")
                }
                
                cell.userNameLabel.text = user.displayName
                cell.userDetailLabel.text = user.email
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: LoginCellID, for: indexPath) as! LoginCell
                cell.delegate = self
                cell.selectionStyle = .none
                
                return cell
            }
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellID, for: indexPath) as! SettingsCell
//            cell.contentImageView.image = UIImage(named: "favorite")
            cell.contentImageView.image = UIImage(named: cellImageNames[indexPath.section][indexPath.row])
            cell.contentLabel.text = cellNames[indexPath.section][indexPath.row]
            
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if FIRAuth.auth()?.currentUser != nil {
                let userDetailController = UserDetailController(style: .grouped)
                navigationController?.pushViewController(userDetailController, animated: true)
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = MyPublishedController(style: .grouped)
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
            if indexPath.row == 1 { //我的收藏
                guard (FIRAuth.auth()?.currentUser?.uid) != nil else {
                    self.showAlertPrompt(message: "请先登录")
                    return
                }
                let vc = MyFavoritesController(collectionViewLayout: UICollectionViewFlowLayout())
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 2 {
            let settingDetailController = SettingDetailController(style: .grouped)
            settingDetailController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(settingDetailController, animated: true)
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat!
        if indexPath.section == 0 {
            rowHeight = 76
        }else{
            rowHeight = 46
        }
        return rowHeight
    }
}

extension MainSettingsController: LoginCellDelegate {
    func handleLoginButtonTapped() {
        let loginController = MainLoginController()
        self.present(loginController, animated: true, completion: nil)
    }
}





