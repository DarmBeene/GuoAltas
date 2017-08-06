//
//  UserDetailCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/17/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class UserDetailCell: BaseCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setupViews() {
        self.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addSubview(detailLabel)
        detailLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        detailLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 5).isActive = true
        
        self.accessoryType = .disclosureIndicator
    }
    
    
}
