//
//  ChooserServiceStateController.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 8/16/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

private let cellIdentifier = "cellIdentifier"
class ChooseServiceStateController: UITableViewController {
    
    var states = [String]()
    var serviceName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        states = ServiceConstants.states.map { $0.key }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.title = "选择州"
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
        let state = states[indexPath.row]
        
        let publishServiceController = PublishServiceController()
        publishServiceController.location = state
        publishServiceController.serviceName = serviceName
        navigationController?.pushViewController(publishServiceController, animated: true)
    }
    
    
}
