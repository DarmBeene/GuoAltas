//
//  ChooseShareTypeController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/12/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellId = "cellId"
class ChooseShareTypeController: UITableViewController {
    
    var types = ["课件", "Lab/Project", "学习心得"]
    
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
        
        setupViews()
    }
    
    func setupViews() {
        navigationItem.title = "选择分享类别"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        cell.textLabel?.text = types[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = ShareCourseController()
            vc.studyType = StudyTypeIdentifier.Course
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
            let vc = ShareCourseController()
            vc.studyType = StudyTypeIdentifier.LabProject
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let vc = ShareTipController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
