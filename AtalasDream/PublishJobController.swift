//
//  PublishJobController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/23/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class PublishJobController: UIViewController {
    
    var scrollView: UIScrollView?
    var publishJobView: PublishJobView?
    let scrollViewHeight: CGFloat = 1250
    let publishJobViewHeight: CGFloat = 1230
    
    lazy var publishButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("发布", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConstants.ButtonFontSize)
        button.addTarget(self, action: #selector(publishJob), for: .touchUpInside)
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
        self.view.backgroundColor = .white
        
        setupViews()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyobard)))
        
        setupKeyboardNotifications()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func dismissKeyobard() {
        self.view.endEditing(true)
    }
    func setupViews() {
        navigationItem.title = "发布工作职位"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
        
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView?.contentSize = CGSize(width: self.view.frame.width, height: scrollViewHeight)
        self.view.addSubview(scrollView!)
        
        publishJobView = PublishJobView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: publishJobViewHeight))
        scrollView?.addSubview(publishJobView!)
    }

    func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    func publishJob() {
        self.view.endEditing(true)
        guard let publishJobView = publishJobView else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            self.showAlertPrompt(message: "请先登录以体验更多功能")
            return
        }
        
        let title = publishJobView.titleTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if title == nil || title == "" {
            self.showAlertPrompt(message: "请填写职位名称")
            return
        }
        let company = publishJobView.companyTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if company == nil || company == "" {
            self.showAlertPrompt(message: "请填写公司名称")
            return
        }
        let location = publishJobView.locationTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if location == nil || location == "" {
            self.showAlertPrompt(message: "请填写地址")
            return
        }
        
        let email = publishJobView.emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let phoneNumber = publishJobView.phoneNumberTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let companyDescription = publishJobView.companyTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let positionDescription = publishJobView.positionTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let requirement = publishJobView.requirementTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        let job = Job(title: title, company: company, email: email, phoneNumber: phoneNumber, location: location, companyDescription: companyDescription, positionDescription: positionDescription, requirement: requirement, uid: uid, date: date)
        
        publishButton.isEnabled = false
        FirDatabasePath.JobReference.childByAutoId().setValue(job.toAny()) { (error, reference) in
            if let error = error {
                self.showAlertPrompt(message: error.localizedDescription)
                return
            }
            
            let values = [reference.key: date]
            FirDatabasePath.UserReference.child(uid).child(JobConstant.JobIdentifier).updateChildValues(values, withCompletionBlock: { (err, ref) in
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
    // MARK: handle keyboard Notifications
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    func handleKeyboardWillShow(notification: Notification) {
        if publishJobView!.requirementTextView.isFirstResponder {
            if let userInfo = notification.userInfo, let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                scrollView?.contentSize = CGSize(width: self.view.frame.width, height: scrollViewHeight + frame.height)
                let rect = CGRect(x: 0, y: frame.height, width: self.view.frame.width, height: scrollViewHeight)
                scrollView?.scrollRectToVisible(rect, animated: true)
            }
        }
    }
    func handleKeyboardWillHide(notification: Notification) {
        if scrollView!.contentSize.height > scrollViewHeight {
            scrollView?.contentSize = CGSize(width: self.view.frame.width, height: scrollViewHeight)
        }
    }

}



