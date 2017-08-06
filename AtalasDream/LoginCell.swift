//
//  LoginCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/12/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

protocol LoginCellDelegate {
    func handleLoginButtonTapped()
}

class LoginCell: BaseCell {

    var delegate: LoginCellDelegate?
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = SettingsConstants.buttonBorderColor.cgColor
        button.layer.borderWidth = 1
        button.setTitle("注册 / 登录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    func handleLogin() {
        delegate?.handleLoginButtonTapped()
    }
    
    override func setupViews() {
        let loginLabel = UILabel()
        addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        loginLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        loginLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loginLabel.textAlignment = .center
        loginLabel.text = "登录\(GlobalConstants.AppName)，体验更多功能"
        loginLabel.font = UIFont.systemFont(ofSize: 17)
        
        addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 5).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
    }
}
