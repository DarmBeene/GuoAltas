//
//  ShowEntertainController.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 7/31/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//


import Foundation

class ShowEntertainController: UIViewController {
    
    var entertainment: Entertainment?
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        
        return sv
    }()
    let showServiceView: ShowServiceView = {
        let ssv = ShowServiceView()
        return ssv
    }()
    let backButton: CustomBackButton = {
        let button = CustomBackButton(type: .system)
        return button
    }()
    
    let toolBarHeight: CGFloat = 49
    let commentToolBarView: CommentToolView = {
        let view = CommentToolView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let commentView: CommentView = {
        let view = CommentView()
        return view
    }()
    lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViews)))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupRightBarButton()
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNaviBar() {
        //        navigationItem.title = "二手信息"
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    func setupRightBarButton() {
        
    }
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        
        scrollView.frame = self.view.frame
        scrollView.contentSize = self.view.frame.size
        self.view.addSubview(scrollView)
        
        showServiceView.frame = self.view.frame
        scrollView.addSubview(showServiceView)
        setupServiceContent()
        
        setupCommentView()
        setupToolBarView()
    }
    func setupCommentView() {
        self.view.addSubview(blackView)
        blackView.frame = self.view.frame
        
        self.view.addSubview(commentView)
        commentView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        commentView.delegate = self
        commentView.textView.delegate = self
    }
    func setupToolBarView() {
        self.view.insertSubview(commentToolBarView, aboveSubview: self.scrollView)
        commentToolBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        commentToolBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        commentToolBarView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        commentToolBarView.heightAnchor.constraint(equalToConstant: toolBarHeight).isActive = true
        commentToolBarView.delegate = self
    }
    
    func setupServiceContent() {
        showServiceView.titleLabel.text = entertainment?.title
        if let date = entertainment?.date {
            showServiceView.dateLabel.text = "发布于 \(date)"
        }
        showServiceView.textView.text = entertainment?.content
        
        if let content = entertainment?.content {
            showServiceView.textViewHeightConstraint?.isActive = true
            showServiceView.textViewHeightConstraint?.constant = estimatedHeight(text: content)
            showServiceView.textViewHeightConstraint?.isActive = true
        }
        loadUserData()
    }
    func estimatedHeight(text: String) -> CGFloat {
        let width = self.view.frame.width - 40
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        return text.height(withWidth: width, attributes: attributes) + 20
    }
    func loadUserData() {
        if let user = entertainment?.user {
            if let photoURL = user.photoURL {
                self.showServiceView.imageView.loadImageFrom(urlString: photoURL)
            }
            if let displayName = user.displayName {
                self.showServiceView.nameLabel.text = displayName
            }
            
        }else{
            showServiceView.imageView.image = UIImage(named: "anonymous")
            showServiceView.nameLabel.text = "匿名用户"
        }
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    func handleKeyboardWillShow(notification: Notification) {
        if let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            let y = self.view.frame.height - (rect.height + 150)
            UIView.animate(withDuration: duration, animations: {
                self.blackView.alpha = 1
                self.commentView.frame = CGRect(x: 0, y: y, width: self.commentView.frame.width, height: self.commentView.frame.height)
            })
        }
    }
    func handleKeyboardWillHide(notification: Notification) {
        if let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            UIView.animate(withDuration: duration, animations: {
                self.blackView.alpha = 0
                self.commentView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.commentView.frame.width, height: self.commentView.frame.height)
            })
        }
    }  
}
extension ShowEntertainController: CommentToolViewDelegate, CommentViewDelegate, UITextViewDelegate {
    
    func showCommentView() {
        commentView.textView.becomeFirstResponder()
    }
    func showMessages() {
//        print(111)
        let entertainComments = EntertainCommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        entertainComments.entertainmentKey = entertainment?.entertainmentKey
        navigationController?.pushViewController(entertainComments, animated: true)
    }
    func dismissViews() {
        commentView.textView.resignFirstResponder()
        
        let text = commentView.textView.text
        if  text != nil && text != "" {
            let draft = "[草稿] "
            let mainString = draft + text!
            let attributedString = NSMutableAttributedString(string: mainString)
            let range = (mainString as NSString).range(of: draft)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
            commentToolBarView.commentLabel.attributedText = attributedString
        }else{
            commentToolBarView.commentLabel.text = EntertainConstants.LeaveMessageIdentifier
        }
    }
    func sendComment() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid,
            let entertainmentKey = entertainment?.entertainmentKey else {
            self.showAlertPrompt(message: "请先登录，登陆后方可评论")
            return
        }
        
        let content = commentView.textView.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())

        let comment = Comment(content: content, date: date, uid: uid)
        
        let ref = FirDatabasePath.CommentReference.child(entertainmentKey).childByAutoId()
        ref.setValue(comment.toAny()) { (error, reference) in
            if let error = error {
                self.showAlertPrompt(message: "分享失败:\(error.localizedDescription)")
                return
            }
            self.commentView.textView.text = nil
            self.commentView.textView.resignFirstResponder()
            self.view.prompt(message: "评论发布成功")
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        if text != nil && text != "" {
            commentView.sendButton.isEnabled = true
        }else{
            commentView.sendButton.isEnabled = false
        }
    }
    
}















