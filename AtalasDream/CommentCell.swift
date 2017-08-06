//
//  CommentCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/11/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class CommentCell: BaseCollectionViewCell {
    let labelHeight: CGFloat = 20
    
    var comment: Comment? {
        didSet{
            if let content = comment?.content {
                contentLabel.text = content
            }
            if let date = comment?.date {
                dateLabel.text = date
            }
        }
    }
    var uid: String? {
        didSet{
            if let uid = uid {
                FirDatabasePath.UserReference.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    if let photoURL = user.photoURL {
                        self.imageView.loadImageFrom(urlString: photoURL)
                    }else{
                        self.imageView.image = UIImage(named: "anonymous")
                    }
                    if let displayName = user.displayName {
                        self.nameLabel.text = displayName
                    }
                })
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
//        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var contentHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        
        let sbv = UIView()
        sbv.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.selectedBackgroundView = sbv
        
        
        self.backgroundColor = UIColor.white
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(contentLabel)
        contentLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        contentHeightConstraint = contentLabel.heightAnchor.constraint(equalToConstant: 20)
        contentHeightConstraint?.isActive = true
        
        addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
    }
    
}
