//
//  ActionView.swift
//  test
//
//  Created by Gongbin Guo on 8/1/17.
//  Copyright © 2017 Gongbin Guo. All rights reserved.
//

import UIKit

protocol ActionViewDelegate {
    func handleCancel()
    func handleCopy()
    func handleReport()
}

class ActionView: UIView {
    
    let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("复制", for: .normal)
        button.setImage(UIImage(named: "copy_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return button
    }()
    let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("举报", for: .normal)
        button.setImage(UIImage(named: "report_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("取消", for: .normal)
        button.setImage(UIImage(named: "cancel_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return button
    }()
    
    var delegate: ActionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupViews() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(copyButton)
        copyButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        copyButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        copyButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2, constant: 10).isActive = true
        copyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        copyButton.addTarget(self, action: #selector(handleCopy), for: .touchUpInside)
        
        self.addSubview(reportButton)
        reportButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        reportButton.topAnchor.constraint(equalTo: copyButton.topAnchor).isActive = true
        reportButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2, constant: 10).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reportButton.addTarget(self, action: #selector(handleReport), for: .touchUpInside)
        
        self.addSubview(cancelButton)
        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    func handleCopy() {
        delegate?.handleCopy()
    }
    func handleReport() {
        delegate?.handleReport()
    }
    func handleCancel() {
        delegate?.handleCancel()
    }
    
    
}
