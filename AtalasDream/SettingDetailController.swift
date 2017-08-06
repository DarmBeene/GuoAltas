//
//  SettingDetailController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/13/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let SettingDetailCellID = "SettingDetailCellID"

class SettingDetailController: BaseTableController {

    var cellNames = [["退出我的账号", "反馈意见", "举报内容", "关于"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SettingDetailCell.self, forCellReuseIdentifier: SettingDetailCellID)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cellNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellNames[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailCellID, for: indexPath) as! SettingDetailCell
        cell.contentLabel.text = cellNames[indexPath.section][indexPath.row]
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            GIDSignIn.sharedInstance().signOut()
            do {
                try FIRAuth.auth()?.signOut()
                navigationController?.popViewController(animated: true)
                
            } catch let signOutError {
                print("signOutError", signOutError.localizedDescription)
            }
        }
        if indexPath.row == 1 {
            let feedback = FeedbackController()
            feedback.type = SettingsConstants.FeedbackIdentifier
            let vc = UINavigationController(rootViewController: feedback)
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 2 {
            let reportContent = FeedbackController()
            reportContent.type = SettingsConstants.ReportContentIdentifier
            let vc = UINavigationController(rootViewController: reportContent)
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 3 {
            let vc = GeneralController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    

}
