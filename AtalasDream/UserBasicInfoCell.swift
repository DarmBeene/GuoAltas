//
//  UserBasicInfoCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/12/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class UserBasicInfoCell: BaseCell {

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let userDetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 15).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.masksToBounds = true
        
        addSubview(userNameLabel)
        userNameLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 8).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: self.profileImageView.topAnchor, constant: 0).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(userDetailLabel)
        userDetailLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 8).isActive = true
        userDetailLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        userDetailLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        userDetailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
