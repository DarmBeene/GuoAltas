//
//  CommentToolView.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 8/1/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class CommentToolView: BasicCommentToolView {
    
    let messagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "comments_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let margin: CGFloat = 8
    override func setupViews() {
        self.backgroundColor = CommentBGC
        
        self.addSubview(messagesButton)
        messagesButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        messagesButton.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        messagesButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
        messagesButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        messagesButton.addTarget(self, action: #selector(viewMessages), for: .touchUpInside)
        
        self.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        containerView.rightAnchor.constraint(equalTo: messagesButton.leftAnchor, constant: -10).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
        
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
    
    func viewMessages() {
        delegate?.showMessages()
    }
    
}
