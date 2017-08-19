//
//  ShowMyItemController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/11/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class ShowMyItemController: BaseServiceItemController {
    
    var serviceName: String?
    var indexPath: IndexPath?
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("删除", for: .normal)
        button.setImage(UIImage(named: "delete_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 25)
        return button
    }()
    
    override func setupRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
        deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
    }
    
    func handleDelete() {
        
        guard let service = service,
            let uid = FIRAuth.auth()?.currentUser?.uid,
            let serviceName = serviceName,
            let serviceKey = service.serviceKey else {
                self.showAlertPrompt(message: "数据出现异常，请稍后再试")
                return
        }
        
        let alert = UIAlertController(title: nil, message: "确定要删除吗？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
            FirDatabasePath.UserReference.child(uid).child(serviceName).child(serviceKey).removeValue()
            if serviceName == ServiceName.HoldActivity {
                FIRDatabase.database().reference(withPath: serviceName).child(serviceKey).removeValue()
            }else{
                if let location = service.location {
                    FIRDatabase.database().reference(withPath: serviceName).child(location).child(serviceKey).removeValue()
                }
            }
            DispatchQueue.main.async {
                let userInfo = [SettingsConstants.IndexPathIdentifier: self.indexPath!]
                NotificationCenter.default.post(name: Notification.Name(NotificationNameConstants.ReloadMyPublishedService), object: self, userInfo: userInfo)
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
