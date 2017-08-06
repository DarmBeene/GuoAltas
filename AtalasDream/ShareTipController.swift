//
//  ShareStudyTipController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/7/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class ShareTipController: UIViewController {
    let placeholder = "请在这里写下分享内容"
    
    let courseTextField: UITextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "请填写课程名称"
        return tf
    }()
    let contentTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = GlobalConstants.TextFieldBGC
        tv.font = UIFont.systemFont(ofSize: GlobalConstants.TextViewFontSize)
        return tv
    }()
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("分享", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConstants.ButtonFontSize)
        button.addTarget(self, action: #selector(shareTip), for: .touchUpInside)
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
        navigationItem.title = "分享课程心得"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        
        self.view.addSubview(courseTextField)
        courseTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        courseTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        courseTextField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        courseTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(contentTextView)
        contentTextView.delegate = self
        contentTextView.text = placeholder
        contentTextView.textColor = UIColor.lightGray
        contentTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        contentTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        contentTextView.topAnchor.constraint(equalTo: courseTextField.bottomAnchor, constant: 10).isActive = true
        contentTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    func shareTip() {
        self.view.endEditing(true)
        guard let uid = FIRAuth.auth()?.currentUser?.uid,
            let universityName = UserDefaults.standard.object(forKey: UserDefaultsKey.UniversityName) as? String,
            let departmentName = UserDefaults.standard.object(forKey: UserDefaultsKey.MyDepartment) as? String else { return }

        let courseName = courseTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if courseName == nil || courseName == "" {
            self.showAlertPrompt(message: "请填写课程名称")
            return
        }
        
        let content = contentTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if content == "" {
            self.showAlertPrompt(message: "请填写内容")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        let course = Course(university: universityName, department: departmentName, name: courseName, link: nil, courseDescription: content, uid: uid, date: date)
        
        shareButton.isEnabled = false
        let ref = FIRDatabase.database().reference(withPath: universityName).child(departmentName).child(StudyTypeIdentifier.CourseTip).childByAutoId()
        
        ref.setValue(course.toAny()) { (error, reference) in
            if let error = error {
                self.showAlertPrompt(message: "分享失败:\(error.localizedDescription)")
                return
            }
            
            let values = [reference.key: [universityName, departmentName, StudyTypeIdentifier.CourseTip]]
            FirDatabasePath.UserReference.child(uid).child(StudyTypeIdentifier.CourseTip).updateChildValues(values, withCompletionBlock: { (err, courseTipRef) in
                if let err = err {
                    self.showAlertPrompt(message: "分享失败:\(err.localizedDescription)")
                    return
                }
                self.view.prompt(message: "分享成功！非常感谢您的分享！", completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ShareTipController: UITextViewDelegate {
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



