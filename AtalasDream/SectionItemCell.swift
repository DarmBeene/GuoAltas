//
//  SecondHandCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/29/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class SectionItemCell: BaseCollectionViewCell {
    let labelHeight: CGFloat = 20
    
    var service: Service? {
        didSet{
            if let title = service?.title {
                titleLabel.text = title
            }
            if let date = service?.date {
                dateLabel.text = date
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .white
        
        self.addSubview(dateLabel)
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        self.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: dateLabel.leftAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        
    }
    
}
