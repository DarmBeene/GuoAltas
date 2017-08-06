//
//  StudyTypeCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/10/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class StudyTypeCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override func setupViews() {
        backgroundColor = .white
        
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
