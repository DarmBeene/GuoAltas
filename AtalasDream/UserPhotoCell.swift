//
//  UserPhotoCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/17/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class UserPhotoCell: BaseCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "头像"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func setupViews() {
        self.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, constant: 0).isActive = true
        
        self.accessoryType = .disclosureIndicator
    }
}
