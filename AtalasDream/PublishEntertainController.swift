//
//  PublishEntertainController.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 7/31/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class PublishEntertainController: UIViewController {
    
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
        navigationItem.title = "发布娱乐活动"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
        
        scrollView.frame = self.view.frame
        scrollView.contentSize = self.view.frame.size
        self.view.addSubview(scrollView)
        
        publishView.frame = self.view.frame
        publishView.textView.text = placeholder
        publishView.textView.textColor = .lightGray
        publishView.textView.delegate = self
        scrollView.addSubview(publishView)
    }
    
    func handlePublish() {
        self.view.endEditing(true)
        guard let uid = FIRAuth.auth()?.currentUser?.uid,
            let town = UserDefaults.standard.object(forKey: UserDefaultsKey.Town) as? String else {
                self.showAlertPrompt(message: "请先登录以体验更多功能")
                return
        }
        
        let serviceTitle = publishView.titleTextField.text
        if serviceTitle == nil || serviceTitle == "" {
            self.showAlertPrompt(message: "请填写标题")
            return
        }
        
        let serviceContent = publishView.textView.text
        if serviceContent == nil || serviceContent == "" {
            self.showAlertPrompt(message: "请填写内容")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        let entertainment = Entertainment(title: serviceTitle, content: serviceContent, date: date, uid: uid, location: town)
        
        publishButton.isEnabled = false
        let ref = FIRDatabase.database().reference(withPath: town).childByAutoId()
        ref.setValue(entertainment.toAny()) { (error, reference) in
            if let error = error {
                self.showAlertPrompt(message: error.localizedDescription)
                return
            }
            let values = [reference.key: town]
            FirDatabasePath.UserReference.child(uid).child(EntertainConstants.EntertainIdentifier).updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    self.showAlertPrompt(message: err.localizedDescription)
                    return
                }
                self.view.prompt(message: "发布成功!", completion: { () in
                    self.dismiss(animated: true, completion: nil)
                })
            })   
        }
    }
    
    func handleDismiss() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PublishEntertainController: UITextViewDelegate {
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


