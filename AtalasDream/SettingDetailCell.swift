//
//  SettingDetailCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/13/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class SettingDetailCell: BaseCell {

    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        self.addSubview(contentLabel)
        contentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -100).isActive = true
        contentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}
