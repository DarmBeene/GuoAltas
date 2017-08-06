//
//  LoginController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/12/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

private let googleRed = UIColor(r: 221, g: 74, b: 55)
private let facebookBlue = UIColor(r: 82, g: 125, b: 190)

class MainLoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    let buttonHeight: CGFloat = 45
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = GlobalConstants.AppName
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("用Google账户登录  ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = googleRed
        button.tintColor = .white
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -13)
        return button
    }()
    lazy var facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("用Facebook账户登录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = facebookBlue
        button.tintColor = .white
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        return button
    }()
    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "或者"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("注册", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.borderColor = SettingsConstants.buttonBorderColor.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("登录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.borderColor = SettingsConstants.buttonBorderColor.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        setupLoadingView()
        
        setupViews()
//        setupDismissButton()
        setupGoogleSignInButton()
        setupFacebookSigninButton()
        setupLoginRegisterButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSuccess(notification:)), name: Notification.Name(NotificationNameConstants.RegisterSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSuccess(notification:)), name: Notification.Name(NotificationNameConstants.LoginSuccessNotification), object: nil)
    }
    func handleLoginSuccess(notification: Notification) {
        OperationQueue.main.addOperation {
            self.dismiss(animated: true, completion: nil)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: setup dismissButton and nameLabel
    func setupViews() {
        self.view.addSubview(dismissButton)
        dismissButton.frame = CGRect(x: 20, y: 30, width: 20, height: 20)
        dismissButton.tintColor = UIColor(r: 197, g: 197, b: 217)
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        self.view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 30).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: GoogleSignInButton
    func setupGoogleSignInButton() {
        self.view.addSubview(googleButton)
        googleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 40).isActive = true
        googleButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        googleButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        googleButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        
        addSubImageView(imageName: "google", button: googleButton, contentMode: .center)
    }
    func handleGoogleSignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //  GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.showAlertPrompt(message: error.localizedDescription)
            return
        }
        self.view.addSubview(loadingView)
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: { (firUser, err) in
            if let err = err {
                self.loadingView.removeFromSuperview()
                self.showAlertPrompt(message: err.localizedDescription)
                return
            }
            self.saveUserToDatabase()
            OperationQueue.main.addOperation {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
//    saveUserToDatabase() method is the same with the one in RegisterController
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
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }

    func setupFacebookSigninButton() {
        self.view.addSubview(facebookButton)
        facebookButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        facebookButton.topAnchor.constraint(equalTo: self.googleButton.bottomAnchor, constant: 10).isActive = true
        facebookButton.leftAnchor.constraint(equalTo: self.googleButton.leftAnchor, constant: 0).isActive = true
        facebookButton.rightAnchor.constraint(equalTo: self.googleButton.rightAnchor, constant: 0).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        facebookButton.addTarget(self, action: #selector(handleFacebookSignIn), for: .touchUpInside)
        
        addSubImageView(imageName: "facebook2", button: facebookButton, contentMode: .scaleAspectFill)
    }
    
    func addSubImageView(imageName: String, button: UIButton, contentMode: UIViewContentMode = .scaleToFill) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.contentMode = contentMode
        
        button.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 25).isActive = true
        imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func handleFacebookSignIn() {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                self.showAlertPrompt(message: error.localizedDescription)
            case .cancelled:
                break
            case .success( _, _, let accessToken):
                self.view.addSubview(self.loadingView)
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                FIRAuth.auth()?.signIn(with: credential, completion: { (firUser, err) in
                    
                    if let err = err {
                        self.loadingView.removeFromSuperview()
                        self.showAlertPrompt(message: "firAuth error: \(err.localizedDescription)")
                        return
                    }
                    self.saveUserToDatabase()
                    OperationQueue.main.addOperation {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    func setupLoginRegisterButton() {
        let buttonWidth = self.view.frame.width / 2 - 35
        
        self.view.addSubview(orLabel)
        orLabel.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 20).isActive = true
        orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
//        registerButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
//        egisterButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        
        
        self.view.addSubview(registerButton)
        registerButton.leftAnchor.constraint(equalTo: googleButton.leftAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        self.view.addSubview(loginButton)
        loginButton.rightAnchor.constraint(equalTo: googleButton.rightAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: registerButton.topAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    func handleRegister() {

        let registerController = RegisterController()
        self.present(registerController, animated: true, completion: nil)
        
    }
    func handleLogin() {
        let loginController = LoginController()
        self.present(loginController, animated: true, completion: nil)
    }
}
