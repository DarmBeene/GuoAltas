//
//  JobTitleCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/27/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class JobTitleCell: BaseCollectionViewCell {
    
    let labelHeight: CGFloat = 20
    var job: Job? {
        didSet{
            if let title = job?.title {
                titleLabel.text = title
            }
            if let date = job?.date {
                dateLabel.text = "发布时间: \(date)"
            }
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func setupViews() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
    }
    
}
