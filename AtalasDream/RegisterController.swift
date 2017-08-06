//
//  RegisterController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/16/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
//   saveUserToDatabase() method is the same with the one in MainLoginController

import UIKit

class RegisterController: BaseLoginRegister {
    let displayNameTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "名称"
        tf.clearButtonMode = .always
        tf.tag = 1
        return tf
    }()
    
    override func setupOthers() {
        button.setTitle("注册", for: .normal)
        
        self.view.addSubview(displayNameTextField)
        displayNameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        displayNameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        displayNameTextField.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -10).isActive = true
        displayNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        displayNameTextField.delegate = self
    }

    
    override func handleButtonTapped() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            passwordTextField.resignFirstResponder()
            self.view.addSubview(loadingView)
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firUser, error) in
                if let error = error {
                    self.loadingView.removeFromSuperview()
                    self.showAlertPrompt(message: error.localizedDescription)
                    return
                }
                
                //update the displayName of the newly created user
                let changeRequest = firUser?.profileChangeRequest()
                var displayName = self.displayNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if self.displayNameTextField.text == nil || self.displayNameTextField.text == "" {
                    displayName = "匿名用户"
                }
                changeRequest?.displayName = displayName
                changeRequest?.commitChanges(completion: { (err) in
                    if let err = err {
                        self.loadingView.removeFromSuperview()
                        self.showAlertPrompt(message: err.localizedDescription)
                        return
                    }
                    self.saveUserToDatabase()
                    
                    OperationQueue.main.addOperation {
                        let notification = Notification(name: Notification.Name(NotificationNameConstants.RegisterSuccessNotification))
                        NotificationCenter.default.post(notification)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    func saveUserToDatabase() {
        //check if this user has been stored on FIRDatabase, if not, store this user
        if let firUser = FIRAuth.auth()?.currentUser {
            let ref = FIRDatabase.database().reference(withPath: "Users").child(firUser.uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.exists() {
                    let user = User(displayName: firUser.displayName, email: firUser.email, photoURL: firUser.photoURL?.absoluteString)
                    ref.setValue(user.toAny(), withCompletionBlock: { (saveError, reference) in
                        if let saveError = saveError {
                            self.loadingView.removeFromSuperview()
                            self.showAlertPrompt(message: saveError.localizedDescription)
                            return
                        }
                    })
                }
            }, withCancel: nil)
        }
    }
    
    
    
}
