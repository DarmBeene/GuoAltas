//
//  BaseLoginRegister.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/17/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

fileprivate let disabledButtonColor = UIColor(r: 130, g: 194, b: 252)
fileprivate let enabledButonColor = UIColor(r: 23, g: 135, b: 251)

class BaseLoginRegister: UIViewController {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = GlobalConstants.AppName
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    let emailTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "email地址"
        tf.clearButtonMode = .always
        tf.keyboardType = .emailAddress
        
        tf.tag = 2
        return tf
    }()
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "密码"
        tf.isSecureTextEntry = true
        tf.clearButtonMode = .always
        tf.tag = 3
        return tf
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        //        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("登录", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.backgroundColor = disabledButtonColor
        return button
    }()
    let loadingView: UIView = {
        let loadingView = UIView()
        loadingView.layer.cornerRadius = 5
        loadingView.layer.masksToBounds = true
        
        return loadingView
    }()
    func setupLoadingView() {
        let sideLength: CGFloat = 60
        let x = self.view.frame.width / 2 - sideLength / 2
        let y = self.view.frame.height / 2 - sideLength / 2
        loadingView.frame = CGRect(x: x, y: y, width: sideLength, height: sideLength)
        loadingView.backgroundColor = .black
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loadingView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupDismissButton()
        setupViews()
        setupLoadingView()
        setupOthers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDismissButton() {
        self.view.addSubview(dismissButton)
        dismissButton.frame = CGRect(x: 20, y: 30, width: 20, height: 20)
        dismissButton.tintColor = UIColor(r: 197, g: 197, b: 217)
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        self.view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 30).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        self.view.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 60).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        emailTextField.addTarget(self, action: #selector(checkTextField(textfield:)), for: .editingChanged)
        
        
        self.view.addSubview(passwordTextField)
        passwordTextField.delegate = self
        passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        passwordTextField.addTarget(self, action: #selector(checkTextField(textfield:)), for: .editingChanged)
        
        self.view.addSubview(button)
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        button.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
    }
    func handleButtonTapped() {
        
    }
    func setupOthers() {
        
    }
    func checkTextField(textfield: UITextField) {
        if (emailTextField.text != nil && emailTextField.text != "") && ((passwordTextField.text != nil && passwordTextField.text != "")) {
            button.isEnabled = true
            button.backgroundColor = enabledButonColor
        }else{
            button.isEnabled = false
            button.backgroundColor = disabledButtonColor
        }
    }
}

extension BaseLoginRegister: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        }
        if textField.tag == 2 {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        if textField.tag == 3 {
            passwordTextField.resignFirstResponder()
            self.handleButtonTapped()
        }
        return true
    }
}
