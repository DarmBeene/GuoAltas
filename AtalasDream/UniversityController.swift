//
//  UniversityController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/4/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellId = "cellId"
class UniversityController: UITableViewController {
    
    var town: String?
    var universities = [University]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "选择学校"
        setupNaviBarButtons()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        loadData()
    }
    
    func setupNaviBarButtons() {
        
    }
    
    func loadData() {
        guard let town = town else { return }
        FirDatabasePath.TownsReference.child(town).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                self.universities = snapshot.children.map { University(snapshot: $0 as! FIRDataSnapshot) }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = universities[indexPath.row].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let university = universities[indexPath.row]
        
        UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: university), forKey: UserDefaultsKey.MyUniversity)
        UserDefaults.standard.setValue(university.name, forKey: UserDefaultsKey.UniversityName)
        UserDefaults.standard.synchronize()
                
        let vc = DepartmentController()
        vc.university = university
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
