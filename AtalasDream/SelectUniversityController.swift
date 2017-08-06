//
//  SelectUniversityController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/6/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class SelectUniversityController: UniversityController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let university = universities[indexPath.row]
        UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: university), forKey: UserDefaultsKey.MyUniversity)
        UserDefaults.standard.setValue(university.name, forKey: UserDefaultsKey.UniversityName)
        UserDefaults.standard.synchronize()
        
        let vc = SelectDepartmentController()
        vc.university = university
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
