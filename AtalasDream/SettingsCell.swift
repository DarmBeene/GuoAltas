//
//  SettingsCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/12/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {

    let contentImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override func setupViews() {
        addSubview(contentImageView)
        contentImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        contentImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 8).isActive = true
        contentImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -8).isActive = true
        contentImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        addSubview(contentLabel)
        contentLabel.leftAnchor.constraint(equalTo: self.contentImageView.rightAnchor, constant: 8).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        contentLabel.topAnchor.constraint(equalTo: self.contentImageView.topAnchor, constant: 0).isActive = true
        contentLabel.heightAnchor.constraint(equalTo: self.contentImageView.heightAnchor, constant: 0).isActive = true
    }
    
}
