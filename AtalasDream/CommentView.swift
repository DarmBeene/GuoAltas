//
//  CommentView.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 8/1/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

protocol CommentViewDelegate {
    func sendComment()
    func dismissViews()
}

class CommentView: UIView {
    var delegate: CommentViewDelegate?
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: GlobalConstants.ButtonFontSize)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: GlobalConstants.ButtonFontSize)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.white
        tv.font = UIFont.systemFont(ofSize: GlobalConstants.TextViewFontSize)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func handleSend() {
        delegate?.sendComment()
    }
    func handleDismiss() {
        delegate?.dismissViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //5 + 30 + 5 + 100 = 140
    func setupViews() {
        self.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        self.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        sendButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(textView)
        textView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 5).isActive = true
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
}
