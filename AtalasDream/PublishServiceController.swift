//
//  BasePublishController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/28/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class PublishServiceController: UIViewController {
    
    var serviceName: String?
    let placeholder = "请在这里填写内容..."
    
    let publishView: PublishView = {
        let pv = PublishView()
        return pv
    }()
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    lazy var publishButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("发布", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConstants.ButtonFontSize)
        button.addTarget(self, action: #selector(handlePublish), for: .touchUpInside)
        return button
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
        
        setupNaviBarAndViews()
    }
    
    func setupNaviBarAndViews() {
        self.view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
        
        if let serviceName = serviceName {
            if serviceName == ServiceName.SecondHand {
                navigationItem.title = "发布二手信息"
            }
            if serviceName == ServiceName.RentHouse {
                navigationItem.title = "发布房屋信息"
            }
            if serviceName == ServiceName.HoldActivity {
                navigationItem.title = "发布活动信息"
            }
            if serviceName == ServiceName.PartTimeJob {
                navigationItem.title = "发布兼职信息"
            }
        }
        
        scrollView.frame = self.view.frame
        scrollView.contentSize = self.view.frame.size
        self.view.addSubview(scrollView)
        
        publishView.frame = self.view.frame
        publishView.textView.text = placeholder
        publishView.textView.textColor = .lightGray
        publishView.textView.delegate = self
        scrollView.addSubview(publishView)
    }
    
    var serviceTitle: String?
    var serviceContent: String?
    var uid: String?
    var location: String?
    var date: String?
    
    func initData() {
        serviceTitle = publishView.titleTextField.text
        serviceContent = publishView.textView.text
        uid = FIRAuth.auth()?.currentUser?.uid
        location = DeviceLocation.shared.state
        
        if uid == nil || uid == "" {
            self.showAlertPrompt(message: "请先登录以体验更多功能")
            return
        }
        if location == nil {
            self.showAlertPrompt(message: "请先选择所在州")
            return
        }
        if serviceTitle == nil || serviceTitle == "" {
            self.showAlertPrompt(message: "请填写标题")
            return
        }
        if serviceContent == nil || serviceContent == "" {
            self.showAlertPrompt(message: "请填写内容")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.string(from: Date())
    }
    
    func handlePublish() {
        self.view.endEditing(true)
        initData()
        
        let service = Service(title: serviceTitle, content: serviceContent, date: date, uid: uid, location: location)
        if let serviceName = serviceName {
            publishButton.isEnabled = false
            FIRDatabase.database().reference(withPath: serviceName).child(location!).childByAutoId().setValue(service.toAny(), withCompletionBlock: { (error, reference) in
                if let error = error {
                    self.showAlertPrompt(message: error.localizedDescription)
                    return
                }
                let values = [reference.key: self.location!]
                FirDatabasePath.UserReference.child(self.uid!).child(serviceName).updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        self.showAlertPrompt(message: err.localizedDescription)
                        return
                    }
                    self.view.prompt(message: "发布成功!", completion: { () in
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    func handleDismiss() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PublishServiceController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}


