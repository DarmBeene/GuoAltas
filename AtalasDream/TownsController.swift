//
//  TownsController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/4/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellId = "cellId"
class TownsController: UITableViewController {
    
    var towns = [String]()
    var townsConstant = [String]()
    
//    var alphabeticTowns = [[String]]()
//    var sectionTitles = [String]()
    
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "选择城市"
        setupNaviBarButtons()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        loadData()
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    func setupNaviBarButtons() {
        
    }
    
    func loadData() {
        if let filepath = Bundle.main.path(forResource: "towns", ofType: "plist") {
            towns = NSArray(contentsOfFile: filepath) as! [String]
            townsConstant = towns
//            var preInitial: Character? = nil
//            for town in towns {
//                let initial = town.characters.first
//                if initial != preInitial {
//                    alphabeticTowns.append([])
//                    preInitial = initial
//                    sectionTitles.append(String(initial!))
//                }
//                alphabeticTowns[alphabeticTowns.count - 1].append(town)
//            }
//            townsConstant = alphabeticTowns
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return towns.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = towns[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        pushToUniversityController(indexPath: indexPath)
    }
    
    func pushToUniversityController(indexPath: IndexPath) {
        let vc = UniversityController()
        vc.town = towns[indexPath.row]
//        vc.town = alphabeticTowns[indexPath.section][indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TownsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text?.lowercased()
        if  text != nil && text != "" {
            self.towns = townsConstant.filter { $0.lowercased().contains(text!) }
            self.tableView.reloadData()
        }
        if text == "" {
            self.towns = townsConstant
            self.tableView.reloadData()
        }
    }
}





