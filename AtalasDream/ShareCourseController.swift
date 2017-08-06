//
//  CourseShareController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 5/18/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
// websites for testing
// https://www.dropbox.com/sh/oyixnv5fxks2ps8/AADPFifYzKDySJs_vhJmAIWza?dl=0
//
import UIKit

class ShareCourseController: UIViewController {
    
    var shareCourseView: ShareCourseView?
    var scrollView: UIScrollView?
    var studyType: String?
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.setTitle("分享", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConstants.ButtonFontSize)
        button.addTarget(self, action: #selector(shareCourse), for: .touchUpInside)
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
        
        setupKeyboardNotifications()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUniInfo()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupViews() {
        scrollView = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scrollView!)
        scrollView!.contentSize = self.view.frame.size
        
        shareCourseView = ShareCourseView(frame: self.view.frame)
        shareCourseView?.delegate = self
        scrollView!.addSubview(shareCourseView!)
 
        navigationItem.title = "分享课程"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    func updateUniInfo() {
        if let universityName = UserDefaults.standard.object(forKey: UserDefaultsKey.UniversityName) as? String {
            shareCourseView?.universityLabel.text = universityName
        }
        if let departmentName = UserDefaults.standard.object(forKey: UserDefaultsKey.MyDepartment) as? String {
            shareCourseView?.departmentLabel.text = departmentName
        }
    }
    
    // MARK: share course
    func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func shareCourse() {
        self.view.endEditing(true)
        guard let courseShareView = shareCourseView else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            self.showAlertPrompt(message: "请先登录以体验更多功能")
            return
        }
        guard let studyType = studyType else { return }
        
        let universityName = UserDefaults.standard.object(forKey: UserDefaultsKey.UniversityName) as? String
        if universityName == nil || universityName == "" {
            self.showAlertPrompt(message: "请先选择学校")
            return
        }
        
        let departmentName = UserDefaults.standard.object(forKey: UserDefaultsKey.MyDepartment) as? String
        if departmentName == nil || departmentName == "" {
            self.showAlertPrompt(message: "请填写学院名称")
            return
        }
        
        let courseName = courseShareView.courseTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if courseName == nil || courseName == "" {
            self.showAlertPrompt(message: "请填写课程名称")
            return
        }
        
        let courseLink = courseShareView.linkTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if courseLink == "" {
            self.showAlertPrompt(message: "请把拷贝的Dropbox链接粘贴进去")
            return
        }
        
        let courseDescription = courseShareView.descriptionTextView.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        let ref = FIRDatabase.database().reference(withPath: universityName!).child(departmentName!).child(studyType).childByAutoId()
        let course = Course(university: universityName, department: departmentName, name: courseName, link: courseLink, courseDescription: courseDescription, uid: uid, date: date)
        
        shareButton.isEnabled = false
        ref.setValue(course.toAny()) { (error, reference) in
            if let error = error {
                self.showAlertPrompt(message: "分享失败:\(error.localizedDescription)")
                return
            }
            let values = [reference.key: [universityName, departmentName, studyType]]
            FirDatabasePath.UserReference.child(uid).child(studyType).updateChildValues(values, withCompletionBlock: { (err, courseRef) in
                if let err = err {
                    self.showAlertPrompt(message: "分享失败:\(err.localizedDescription)")
                    return
                }
                OperationQueue.main.addOperation {
                    self.view.prompt(message: "分享成功！非常感谢您的分享！", completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    func resetCourseShareView() {
        self.shareCourseView?.linkTextView.text = nil
        self.shareCourseView?.courseTextField.text = nil
    }
    
    // MARK: handle keyboard Notifications
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    func handleKeyboardWillShow(notification: Notification) {
        if shareCourseView!.descriptionTextView.isFirstResponder {
            if let userInfo = notification.userInfo, let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                scrollView?.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + frame.height)
                let rect = CGRect(x: 0, y: frame.height, width: self.view.frame.width, height: self.view.frame.height)
                scrollView?.scrollRectToVisible(rect, animated: true)
            }
        }
    }
    func handleKeyboardWillHide(notification: Notification) {
        if scrollView!.contentSize.height > self.view.frame.height {
            scrollView?.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        }
    }
}

extension ShareCourseController: ShareCourseViewProtocol {
    func showHelp() {
//        let options = NSNumber(value: 20)
        let courseHelpController = CourseHelpController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: NSNumber(value: 20)])
        let naviController = UINavigationController(rootViewController: courseHelpController)
        self.present(naviController, animated: true, completion: nil)
    }
    func selectUniversity() {
        let vc = UINavigationController(rootViewController: SelectTownController())
        self.present(vc, animated: true, completion: nil)
    }
    func selectDepartment() {
        if let universityData = UserDefaults.standard.object(forKey: UserDefaultsKey.MyUniversity) as? Data,
            let university = NSKeyedUnarchiver.unarchiveObject(with: universityData) as? University {
            
            let vc = ChangeDepartmentController()
            vc.university = university
            let navi = UINavigationController(rootViewController: vc)
            
            self.present(navi, animated: true, completion: nil)
        }else{
            self.showAlertPrompt(message: "请先选择学校")
            return
        }
    }
}

