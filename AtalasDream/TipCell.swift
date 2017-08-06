//
//  TipCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/9/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class TipCell: BaseCollectionViewCell {
    let emptyTextViewHeight: CGFloat = 10
    var course: Course? {
        didSet{
            if let uid = course?.uid {
                FirDatabasePath.UserReference.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    if let photoURL = user.photoURL {
                        self.imageView.loadImageFrom(urlString: photoURL)
                    }
                    if let displayName = user.displayName {
                        self.nameLabel.text = displayName
                    }
                })
            }
            if let content = course?.courseDescription {
                contentTextView.text = content
            }
            if let date = course?.date {
                dateLabel.text = "分享于 \(date)"
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "anonymous")
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = GlobalConstants.TextFieldBGC
        tv.isScrollEnabled = false
        return tv
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var contentHeightAnchor: NSLayoutConstraint?
    
    override func setupViews() {
        self.backgroundColor = .white
        
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        addSubview(contentTextView)
        contentTextView.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        contentTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        contentTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        contentHeightAnchor = contentTextView.heightAnchor.constraint(equalToConstant: emptyTextViewHeight)
        contentHeightAnchor?.isActive = true
        
        addSubview(dateLabel)
        dateLabel.rightAnchor.constraint(equalTo: contentTextView.rightAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    
}
