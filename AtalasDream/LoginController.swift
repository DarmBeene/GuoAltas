//
//  LoginController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/16/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
import UIKit

class LoginController: BaseLoginRegister {
    override func setupOthers() {
        button.setTitle("登录", for: .normal)
    }
    
    override func handleButtonTapped() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            passwordTextField.resignFirstResponder()
            self.view.addSubview(loadingView)
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
                if let error = error {
                    self.loadingView.removeFromSuperview()
                    self.showAlertPrompt(message: error.localizedDescription)
                    return
                }
                OperationQueue.main.addOperation {
                    let notification = Notification(name: Notification.Name(NotificationNameConstants.LoginSuccessNotification))
                    NotificationCenter.default.post(notification)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}

