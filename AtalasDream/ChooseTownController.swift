//
//  ChooseCityController.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 7/31/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class ChooseTownController: TownsController {
    
    override func setupNaviBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleDismiss))
    }
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let town = towns[indexPath.row]
        DeviceLocation.shared.town = town
        
        UserDefaults.standard.setValue(town, forKey: UserDefaultsKey.Town)
        UserDefaults.standard.synchronize()
        
        let notification = Notification.init(name: Notification.Name(NotificationNameConstants.ChangeTownNotification))
        NotificationCenter.default.post(notification)
        
        OperationQueue.main.addOperation {
            self.searchController.isActive = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
