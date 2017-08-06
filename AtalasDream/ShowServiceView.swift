//
//  ShowServiceView.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/29/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let labelHeight: CGFloat = 30
private let imageWidth: CGFloat = 40

class ShowServiceView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .red
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "anonymous")
        iv.layer.cornerRadius = imageWidth / 2
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
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = GlobalConstants.TextFieldBGC
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var textViewHeightConstraint: NSLayoutConstraint?
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(textView)
        textView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 300)
        textViewHeightConstraint?.isActive = true
        
        
        
    }
    
    
}


















