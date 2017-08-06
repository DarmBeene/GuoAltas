//
//  DepartmentController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/4/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellId = "cellId"
class DepartmentController: UITableViewController {

    var university: University?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "选择学院"
        setupNaviBarButtons()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    func setupNaviBarButtons() {
        
    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return university?.departments?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = university?.departments?[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let department = university?.departments?[indexPath.row]
        UserDefaults.standard.setValue(department, forKey: UserDefaultsKey.MyDepartment)
        UserDefaults.standard.synchronize()
        
        let values = ["University": university?.name as Any, "Department": department as Any]
        updateUserInfo(with: values)
        
        if let vc = navigationController?.viewControllers[1] as? UserDetailController {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    func updateUserInfo(with values: [AnyHashable: Any]) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FirDatabasePath.UserReference.child(uid).updateChildValues(values) { (error, ref) in
            if let error = error {
                self.showAlertPrompt(message: error.localizedDescription)
                return
            }
        }
        
    }
    
    
}
