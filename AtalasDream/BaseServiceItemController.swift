//
//  ShowItemController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/29/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class BaseServiceItemController: UIViewController {
    
    var service: Service?
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        
        return sv
    }()
    let showServiceView: ShowServiceView = {
        let ssv = ShowServiceView()
        return ssv
    }()
    
    let backButton: CustomBackButton = {
        let button = CustomBackButton(type: .system)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupRightBarButton()
        setupViews()
    }
    
    func setupNaviBar() {
//        navigationItem.title = "二手信息"
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    func setupRightBarButton() {
        
    }
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        
        scrollView.frame = self.view.frame
        scrollView.contentSize = self.view.frame.size
        self.view.addSubview(scrollView)
        
        showServiceView.frame = self.view.frame
        scrollView.addSubview(showServiceView)
        
        setupServiceContent()
    }
    
    func setupServiceContent() {
        showServiceView.titleLabel.text = service?.title
        if let date = service?.date {
            showServiceView.dateLabel.text = "发布于 \(date)"
        }
        showServiceView.textView.text = service?.content
        
        if let content = service?.content {
            showServiceView.textViewHeightConstraint?.isActive = true
            showServiceView.textViewHeightConstraint?.constant = estimatedHeight(text: content)
            showServiceView.textViewHeightConstraint?.isActive = true
        }
        loadUserData()
    }
    
    func estimatedHeight(text: String) -> CGFloat {
        let width = self.view.frame.width - 40
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        return text.height(withWidth: width, attributes: attributes) + 20
    }
    
    func loadUserData() {
        if let userId = service?.uid {
            FirDatabasePath.UserReference.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                if let photoURL = user.photoURL {
                    self.showServiceView.imageView.loadImageFrom(urlString: photoURL)
                }
                if let displayName = user.displayName {
                    self.showServiceView.nameLabel.text = displayName
                }
            }, withCancel: nil)
        }
    }
    
}
