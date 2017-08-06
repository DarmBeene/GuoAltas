//
//  TipCommentController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/10/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

private let cellId = "cellId"
private let footerCellId = "footerCellId"
fileprivate let disabledButtonColor = UIColor(r: 130, g: 194, b: 252)
fileprivate let enabledButonColor = UIColor(r: 23, g: 135, b: 251)

class TipCommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var comments = [Comment]()
    var courseKey: String?
    var currentPage = 0
    let NumberOfEachPage = 15
    var isEnd = false
    var refreshControll: UIRefreshControl?
    var commentReference: FIRDatabaseReference?
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("评论", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        button.backgroundColor = disabledButtonColor
        button.isEnabled = false
        return button
    }()
    let commentTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()
    lazy var infoView: InfoView = {
        let view = InfoView(frame: .zero)
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupKeyboardObservers()
        loadData()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    var containerHeightConstraint: NSLayoutConstraint?
    var containerBottomConstraint: NSLayoutConstraint?
    let textViewHeight: CGFloat = 34
    
    func setupViews() {
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.alpha = 0
        
        navigationItem.title = "评论"
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerCellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = GlobalConstants.CollectionViewBGC
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: textViewHeight + 10, right: 0)
        
        refreshControll = UIRefreshControl()
        collectionView?.addSubview(refreshControll!)
        refreshControll?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        let containerView = UIView()
        self.view.insertSubview(containerView, aboveSubview: infoView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        containerBottomConstraint?.isActive = true
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: textViewHeight + 10)
        containerHeightConstraint?.isActive = true
        
        containerView.addSubview(commentButton)
        commentButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        commentButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: textViewHeight).isActive = true
        
        containerView.addSubview(commentTextView)
        commentTextView.delegate = self
        commentTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        commentTextView.rightAnchor.constraint(equalTo: commentButton.leftAnchor, constant: -5).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
        commentTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
    }
    
    func handleRefresh() {
        loadData()
        refreshControll?.endRefreshing()
    }
    func handleComment() {
        self.view.endEditing(true)
        guard let uid = FIRAuth.auth()?.currentUser?.uid,
            let courseKey = courseKey else {
                self.showAlertPrompt(message: "请先登录，登陆后方可评论")
                return
        }
        
        let content = commentTextView.text
        if content == "" {
            self.showAlertPrompt(message: "请写下评论内容")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        let comment = Comment(content: content, date: date, uid: uid)
        let ref = FirDatabasePath.CommentReference.child(courseKey).childByAutoId()
        ref.setValue(comment.toAny()) { (error, reference) in
            if error != nil {
                self.showAlertPrompt(message: "分享失败:\(error!.localizedDescription)")
                return
            }else{
                self.resetCommentTextView()
                self.disableCommentButton()
                self.view.prompt(message: "评论发布成功", completion: {
                    DispatchQueue.main.async {
                        self.loadData()
                    }
                })
            }
        }
    }
    func resetCommentTextView() {
        commentTextView.text = ""
        containerHeightConstraint?.isActive = false
        containerHeightConstraint?.constant = textViewHeight + 10
        containerHeightConstraint?.isActive = true
    }
    
    func loadData() {
        commentReference = FirDatabasePath.CommentReference.child(courseKey!)
        let commentQuery = commentReference?.queryOrderedByKey().queryLimited(toLast: UInt(NumberOfEachPage))
        commentQuery?.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                let loadedComments = snapshot.children.map { Comment(snapshot: $0 as! FIRDataSnapshot)}
                self.comments = Array(loadedComments.reversed())
                if self.comments.count < self.NumberOfEachPage {
                    self.isEnd = true
                }
                DispatchQueue.main.async {
                    self.infoView.alpha = 0
                    self.collectionView?.reloadData()
                    self.currentPage = 1
                }
            }else{
                self.infoView.alpha = 1
                self.isEnd = true
                let indexPath = IndexPath(item: 0, section: 0)
                if let footer = self.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: indexPath) as? FooterCell {
                    footer.indicator.stopAnimating()
                }
            }
        })
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    func handleKeyboardWillShow(notification: Notification) {
        if let frame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue{
            
            containerBottomConstraint?.constant = -frame.height
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    func handleKeyboardWillHide(notification: Notification) {
        containerBottomConstraint?.constant = 0
        if let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.item]
        cell.comment = comment
        cell.uid = comment.uid
        if let content = comment.content {
            cell.contentHeightConstraint?.isActive = false
            cell.contentHeightConstraint?.constant = estimatedHeight(text: content)
            cell.contentHeightConstraint?.isActive = true
        }
        return cell
    }
    
    func estimatedHeight(text: String) -> CGFloat {
        let width = self.view.frame.width - 80
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        return text.height(withWidth: width, attributes: attributes)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0
        if let content = comments[indexPath.item].content {
            height = estimatedHeight(text: content)
        }
        return CGSize(width: self.view.frame.width, height: height + 55)
    }
    
    //MARK: supplementary view , footer related methods
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isEnd && scrollView.frame.size.height <= scrollView.contentSize.height{ // check isEnd first
            if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
                let indexPath = IndexPath(item: 0, section: 0)
                if let footer = collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: indexPath) as? FooterCell {
                    footer.indicator.startAnimating()
                    footer.alpha = 0
                    UIView.animate(withDuration: 2, animations: {
                        footer.alpha = 1
                    }, completion: { (completed) in
                        footer.alpha = 0
                    })
                }
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if !isEnd {
            if currentPage > 0 {
                let keyValue = self.comments.last?.commentKey
                let commentQuery = commentReference?.queryOrderedByKey().queryEnding(atValue: keyValue).queryLimited(toLast: UInt(NumberOfEachPage + 1))
                
                commentQuery?.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChildren() {
                        var loadedComments = snapshot.children.map { Comment(snapshot: $0 as! FIRDataSnapshot) }
                        loadedComments = Array(loadedComments.reversed())
                        if loadedComments.count == 1 {
                            self.isEnd = true
                            view.alpha = 0
                            return
                        }
                        loadedComments.removeFirst()
                        self.comments.append(contentsOf: loadedComments)
                        let indexPaths = (0...loadedComments.count - 1).map { IndexPath(item: $0 + self.currentPage * self.NumberOfEachPage, section: 0) }
                        DispatchQueue.main.async {
                            self.collectionView?.insertItems(at: indexPaths)
                            self.currentPage += 1
                        }
                    }
                }, withCancel: nil)
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellId, for: indexPath) as! FooterCell
        
        if isEnd {
            footer.indicator.stopAnimating()
        }else{
            footer.indicator.startAnimating()
        }
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
extension TipCommentController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            disableCommentButton()
        }else{
            enableCommentButton()
        }
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        let maxHeight: CGFloat = 88
        let height: CGFloat = newSize.height > maxHeight ? 88 : newSize.height
        let isScrollEnabled = newSize.height > maxHeight ? true : false
        containerHeightConstraint?.isActive = false
        containerHeightConstraint?.constant = height + 10
        containerHeightConstraint?.isActive = true
        textView.isScrollEnabled = isScrollEnabled
    }
    func enableCommentButton() {
        commentButton.isEnabled = true
        commentButton.backgroundColor = enabledButonColor
    }
    func disableCommentButton() {
        commentButton.isEnabled = false
        commentButton.backgroundColor = disabledButtonColor
    }
}



