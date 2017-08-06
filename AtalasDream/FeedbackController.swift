//
//  FeedbackController.swift
//  SanRenXing
//
//  Created by Gongbin Guo on 7/24/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

private let placeholder = "请在这里写下留言"
class FeedbackController: UIViewController {
    
    var type: String?
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handlSend), for: .touchUpInside)
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.text = placeholder
        tv.font = UIFont.systemFont(ofSize: 16)
//        tv.textColor = UIColor.lightGray
//        tv.backgroundColor = .red
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    func setupViews() {
        self.view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
//        textView.delegate = self
        textView.becomeFirstResponder()
        
        if type == SettingsConstants.FeedbackIdentifier {
            navigationItem.title = "反馈意见"
        }else{
            navigationItem.title = "举报内容"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
    }
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    func handlSend() {
        self.view.endEditing(true)
        self.sendButton.isEnabled = false
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            self.showAlertPrompt(message: "清先登录，登陆后才可以发送")
            return
        }
        let text = textView.text
        if text == "" {
            self.showAlertPrompt(message: "请写下留言内容！")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        let ref = FirDatabasePath.FeedbackReference.childByAutoId()
        let values = ["uid": uid, "date": date, "text": text, "type": type]
        ref.setValue(values) { (error, reference) in
            if let error = error {
                self.view.prompt(message: "反馈错误信息失败: \(error.localizedDescription)")
                return
            }
            self.view.prompt(message: "非常感谢您的反馈意见", completion: { 
                self.dismiss(animated: true, completion: nil)
            })
        }
        
    }
  
}
