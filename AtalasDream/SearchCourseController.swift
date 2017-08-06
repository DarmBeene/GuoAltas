//
//  SearchCourseController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 5/29/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
/*
SearchCourseController is almost the same with SearchHistoryController, 
 but these two files are not refined. Because first one might be changed in the near future. It shows top hits or something like that.
 Just like 天猫 App. These two Controllers should have different features
 
 */

import UIKit
import CoreData

private let SearchHistoryIdentifier = "SearchHistory"

class SearchCourseController: UITableViewController {
    
    var searches = [SearchHistory]()
    let identifier = "cell"
    var databaseHistory = [SearchHistory]()
    var courseReference: FIRDatabaseReference?
    var studyType: String?
    
    lazy var textField: UITextField = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 30)
        let tf = UITextField(frame: rect)
        tf.backgroundColor = CourseConstants.textFieldBackgroundColor
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.clearButtonMode = .always
        tf.addTarget(self, action: #selector(handleTextFieldEditingChange(textField:)), for: .editingChanged)
        tf.returnKeyType = .search
        
        let imageRect = CGRect(x: 0, y: 0, width: 15, height: 15)
        let imageView = UIImageView(frame: imageRect)
        imageView.image = UIImage(named: "search_icon")
        let imageWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageWrapper.addSubview(imageView)
        imageView.center = imageWrapper.center
        tf.leftView = imageWrapper
        tf.placeholder = "搜索"
        tf.delegate = self
        return tf
    }()
    
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
        
        view.backgroundColor = .white
        tableView.register(SearchCell.self, forCellReuseIdentifier: identifier)
        
        setupNaviBar()
        
        loadSearchHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func setupNaviBar() {
        navigationItem.titleView = textField
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    //MARK: button methods
    func handleTextFieldEditingChange(textField: UITextField) {
        if let searchText = textField.text?.lowercased() {
            let results = databaseHistory.filter { ($0.text!.contains(searchText)) }
            searches = results.sorted(by: { (search1, search2) -> Bool in
                search1.text!.caseInsensitiveCompare(search2.text!) == .orderedAscending
            })
        }
        if textField.text == nil || textField.text == "" {
            searches = databaseHistory
        }
        self.tableView.reloadData()
    }
    
    func handleDismiss() {
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: table view controller methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let search = searches[indexPath.row]
        cell.textLabel?.text = search.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let s = dateFormatter.string(from: search.date! as Date)
        cell.detailTextLabel?.text = s
        
        return cell
    }
    
    //MARK: database methods
    func loadSearchHistory() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<SearchHistory>(entityName: CourseConstants.SearchHistoryEntityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 50
        
        do{
            let searches = try context.fetch(fetchRequest)
            self.databaseHistory = searches
            self.searches = searches
            self.tableView.reloadData()
        }catch let error {
            print("fetch error", error)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let searchObject = searches[indexPath.row]
        update(searchObject: searchObject)
        
        searchFor(text: searchObject.text!)
    }
    func searchFor(text: String) {
        let flowLayout = UICollectionViewFlowLayout()
        let searchResultController = SearchResultController(collectionViewLayout: flowLayout)
        searchResultController.searchString = text
        searchResultController.courseReference = courseReference
        searchResultController.studyType = studyType
        navigationController?.pushViewController(searchResultController, animated: false)
    }
    func insertNewSearchObject(text: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            if let newSearch = NSEntityDescription.insertNewObject(forEntityName: SearchHistoryIdentifier, into: context) as? SearchHistory {
                newSearch.text = text.lowercased()
                newSearch.date = NSDate()
            }
            
            do{
                try context.save()
            }catch let error {
                print("insert new search error", error)
            }
            loadSearchHistory()
        }
    }
    func update(searchObject: SearchHistory) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            searchObject.setValue(NSDate(), forKey: "date")
            do{
                try context.save()
            }catch let error {
                print("insert new search error", error)
            }
        }
        loadSearchHistory()
    }
}

extension SearchCourseController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField.text != nil {
            let searchText = textField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased()
            if searchText != "" {
                if searches.first?.text == searchText {
                    update(searchObject: searches.first!)
                }else{
                    insertNewSearchObject(text: searchText)
                }
                searchFor(text: searchText)
            }
        }
        
        return true
    }
}


class SearchCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}




