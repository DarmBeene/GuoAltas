//
//  EntertainCommentsController.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 8/1/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import CoreData

private let cellId = "cellId"
private let footerCellId = "footerCellId"
class EntertainCommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var comments = [Comment]()
    var blockedMessageKeys = [String]()
    var entertainmentKey: String?
    var currentPage = 0
    let NumberOfEachPage = 15
    var isEnd = false
    var refreshControll: UIRefreshControl?
    var commentReference: FIRDatabaseReference?
    
    lazy var infoView: InfoView = {
        let view = InfoView(frame: .zero)
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        return view
    }()
    // comment related code
    let toolBarHeight: CGFloat = 49
    let commentToolBarView: BasicCommentToolView = {
        let view = BasicCommentToolView()
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
    
    // report related code
    let actionView: ActionView = {
        let view = ActionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
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
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolBarHeight + 10, right: 0)
        
        refreshControll = UIRefreshControl()
        collectionView?.addSubview(refreshControll!)
        refreshControll?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        setupCommentView()
        setupToolBarView()
        setupKeyboardNotifications()
        setupActionView()
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
        self.view.insertSubview(commentToolBarView, aboveSubview: self.collectionView!)
        commentToolBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        commentToolBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        commentToolBarView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        commentToolBarView.heightAnchor.constraint(equalToConstant: toolBarHeight).isActive = true
        commentToolBarView.delegate = self
    }
    
    let transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
    func setupActionView() {
        self.view.addSubview(actionView)
        actionView.alpha = 0
        actionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        actionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        actionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -100).isActive = true
        actionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        actionView.transform = transform
        actionView.delegate = self
    }
    
    func handleRefresh() {
        loadData()
        refreshControll?.endRefreshing()
    }

    func loadData() {
        loadBlockedMessageKeys()
        comments.removeAll(keepingCapacity: false)
        guard let entertainmentKey = entertainmentKey else{
            self.showAlertPrompt(message: "系统正忙，请稍后再试")
            return
        }
        commentReference = FirDatabasePath.CommentReference.child(entertainmentKey)
        let commentQuery = commentReference?.queryOrderedByKey().queryLimited(toLast: UInt(NumberOfEachPage))
        commentQuery?.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                let loadedComments = snapshot.children.map { Comment(snapshot: $0 as! FIRDataSnapshot)}
                self.comments = Array(loadedComments.reversed())
                if self.comments.count < self.NumberOfEachPage {
                    self.isEnd = true
                }
                let newComments = self.comments.filter { !self.blockedMessageKeys.contains($0.commentKey!) }
                self.comments = newComments
                DispatchQueue.main.async {
                    self.infoView.alpha = 0
                    self.collectionView?.reloadData()
                    self.currentPage = 1
                }
            }else{
                self.infoView.alpha = 1
                self.collectionView?.reloadData()
                self.isEnd = true
                let indexPath = IndexPath(item: 0, section: 0)
                if let footer = self.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: indexPath) as? FooterCell {
                    footer.indicator.stopAnimating()
                }
            }
        })
    }
    func loadBlockedMessageKeys() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, let entertainmentKey = entertainmentKey {
            let context = delegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<LocalEntertainBlackListMessage>(entityName: BlackListType.LocalEntertainBlackListMessage)
            fetchRequest.predicate = NSPredicate(format: "entertainmentKey = %@", entertainmentKey)
            
            do{
                let fetchedMessages = try context.fetch(fetchRequest)
                if fetchedMessages.count > 0  {
                    blockedMessageKeys = fetchedMessages.map( { $0.messageKey! })
                }
                
            }catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
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

    var selectedIndexPath: IndexPath?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        animateActionView()
    }
    func animateActionView() {
        UIView.animate(withDuration: 0.4) {
            self.blackView.alpha = 1
            self.actionView.alpha = 1
            self.actionView.transform = .identity
        }
    }
    //MARK: keyboard notifications
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
                        let newComments = loadedComments.filter { !self.blockedMessageKeys.contains($0.commentKey!) }
                        loadedComments = newComments
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



