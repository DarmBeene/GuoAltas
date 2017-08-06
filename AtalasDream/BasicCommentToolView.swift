//
//  BasicCommentToolView.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 8/1/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

protocol CommentToolViewDelegate {
    func showCommentView()
    func showMessages()
}

let CommentBGC = UIColor(r: 245, g: 245, b: 245)
class BasicCommentToolView: UIView {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(r: 228, g: 228, b: 228).cgColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = CommentBGC
        return view
    }()
    let imageWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let commentImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "edit_icon")
        return iv
    }()
    let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = EntertainConstants.LeaveMessageIdentifier
        label.textColor = UIColor.lightGray
        label.backgroundColor = CommentBGC
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        self.backgroundColor = CommentBGC
        
        self.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        
        self.addSubview(imageWrapper)
        imageWrapper.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        imageWrapper.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageWrapper.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        imageWrapper.widthAnchor.constraint(equalToConstant: 33).isActive = true
        imageWrapper.addSubview(commentImageView)
        commentImageView.centerXAnchor.constraint(equalTo: imageWrapper.centerXAnchor).isActive = true
        commentImageView.centerYAnchor.constraint(equalTo: imageWrapper.centerYAnchor).isActive = true
        commentImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        commentImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(commentLabel)
        commentLabel.leftAnchor.constraint(equalTo: imageWrapper.rightAnchor).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        commentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2).isActive = true
        
        commentLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    var delegate: CommentToolViewDelegate?
    func handleTap() {
        delegate?.showCommentView()
    }
    
}





