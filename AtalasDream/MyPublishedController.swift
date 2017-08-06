//
//  MyPublishedController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/3/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

private let cellIdentifier = "cellIdentifier"
class MyPublishedController: BaseTableController, UIGestureRecognizerDelegate {
    
    var cellNames = [["二手信息", "租房信息", "活动", "兼职"], ["当地活动"], ["工作信息"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SettingDetailCell.self, forCellReuseIdentifier: cellIdentifier)
        
        navigationItem.title = "我的发布"
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellNames.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNames[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SettingDetailCell
        cell.contentLabel.text = cellNames[indexPath.section][indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            self.showAlertPrompt(message: "请先登录")
            return
        }
        
        if indexPath.section == 0 {
            var serviceName = ""
            if indexPath.row == 0 {
                serviceName = ServiceName.SecondHand
            }
            if indexPath.row == 1 {
                serviceName = ServiceName.RentHouse
            }
            if indexPath.row == 2 {
                serviceName = ServiceName.HoldActivity
            }
            if indexPath.row == 3 {
                serviceName = ServiceName.PartTimeJob
            }
            
            let vc = MyServiceSectionController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.serviceName = serviceName
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 1 {
            let vc = MyPublishedEntertainController(collectionViewLayout: UICollectionViewFlowLayout())
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 2 {
            let vc = MyPublishedJobController(collectionViewLayout: UICollectionViewFlowLayout())
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}














