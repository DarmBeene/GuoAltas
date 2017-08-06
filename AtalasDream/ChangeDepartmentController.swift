//
//  ChangeDepartmentController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/6/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class ChangeDepartmentController: DepartmentController {
    
    override func setupNaviBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleDismiss))
    }
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let department = university?.departments?[indexPath.row]
        UserDefaults.standard.setValue(department, forKey: UserDefaultsKey.MyDepartment)
        UserDefaults.standard.synchronize()
        
        self.dismiss(animated: true, completion: nil)
    }
}
