//
//  ShowTipController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/8/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let cellId = "cellId"
class ShowTipController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarDelegate {
    var course: Course?
    let toolBarHeight: CGFloat = 49
    lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("收藏", for: .normal)
        button.setImage(UIImage(named: "favorite")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return button
    }()
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("评论", for: .normal)
        button.setImage(UIImage(named: "comments_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupRightBarButton()
    }
    func setupViews() {
        navigationItem.title = course?.name
        
        self.collectionView?.register(TipCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        
        setupToolBar()
    }
    func setupRightBarButton() {
        
    }
    
    func setupToolBar() {
        self.view.insertSubview(toolBar, aboveSubview: self.collectionView!)
        toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: toolBarHeight).isActive = true
        
        let width = self.view.frame.width / 2 - 20
        
        let favoriteView = UIView()
        favoriteView.frame = CGRect(x: 0, y: 0, width: width, height: toolBarHeight)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 120, height: 35)
        favoriteView.addSubview(favoriteButton)
        favoriteButton.center = favoriteView.center

        let commentView = UIView()
        commentView.frame = CGRect(x: 0, y: 0, width: width, height: toolBarHeight)
        commentButton.frame = CGRect(x: 0, y: 0, width: 120, height: 35)
        commentView.addSubview(commentButton)
        commentButton.center = commentView.center
        
        favoriteButton.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        
        let item1 = UIBarButtonItem(customView: favoriteView)
        let item2 = UIBarButtonItem(customView: commentView)
        
        toolBar.items = [item1, item2]
    }
    func handleFavorite() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid,
            let coursekey = course?.courseKey,
            let university = course?.university,
            let department = course?.department else {
                self.showAlertPrompt(message: "请先登录，登陆后方可收藏")
                return
        }
        let ref = FirDatabasePath.UserReference.child(uid).child(SettingsConstants.favoriteCourseTip)
        
        let values = [coursekey: [university, department]]
        ref.updateChildValues(values) { (error, reference) in
            if let error = error {
                self.showAlertPrompt(message: error.localizedDescription)
                return
            }
            self.view.prompt(message: "收藏成功")
        }
    }
    func handleComment() {
        let vc = TipCommentController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.courseKey = course?.courseKey
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TipCell
        cell.course = course
        if let content = course?.courseDescription {
            let height = estimatedHeight(text: content)
            cell.contentHeightAnchor?.isActive = false
            cell.contentHeightAnchor?.constant = height
            cell.contentHeightAnchor?.isActive = true
        }
        
        return cell
    }
    // helper method
    func estimatedHeight(text: String) -> CGFloat {
        let width = self.view.frame.width - 40
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        let height = text.height(withWidth: width, attributes: attributes)
        return height + 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let content = course?.courseDescription {
            let height = estimatedHeight(text: content)
            return CGSize(width: self.view.frame.width, height: 95 + height + toolBarHeight + 5)
        }
        return CGSize(width: self.view.frame.width, height: 95 + 10)
    }
    
}






