//
//  NotificationController.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 8/19/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class NotificationController: BaseTableController {
    
    var isSwitchEnabled: Bool = false
    
    let switchView: UISwitch = {
        let sv = UISwitch(frame: .zero)
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "推送消息设置"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwitchEnabled = UIApplication.shared.isRegisteredForRemoteNotifications
        switchView.setOn(isSwitchEnabled, animated: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "系统通知"
        
        switchView.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    func handleValueChanged() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
        let view = UIView(frame: rect)
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: self.view.frame.width, height: 20))
        label.text = "打开系统通知接收活动、兼职等消息"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        
        view.addSubview(label)
        return view
    }
    
    
}
