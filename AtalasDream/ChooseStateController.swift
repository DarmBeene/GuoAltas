//
//  ChooseStateController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/28/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellIdentifier = "cellIdentifier"
class ChooseStateController: UITableViewController {
    
    var states = [String]()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConstants.ButtonFontSize)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        states = ServiceConstants.states.map { $0.key }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = ServiceConstants.states[states[indexPath.row]]//
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let state = states[indexPath.row]
        DeviceLocation.shared.state = state
        
        UserDefaults.standard.set(state, forKey: UserDefaultsKey.State)
        UserDefaults.standard.synchronize()
        
        let notification = Notification(name: Notification.Name(NotificationNameConstants.ChangeStateNotification))
        NotificationCenter.default.post(notification)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}
