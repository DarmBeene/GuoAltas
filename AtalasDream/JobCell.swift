//
//  JobCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/23/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
//title, 公司名称， 发布时间，职位信息， 任职要求，联系方式，公司信息
import UIKit

class JobCell: BaseCollectionViewCell {
    
    let labelHeight: CGFloat = 20
    
    var job: Job? {
        didSet{
            if let title = job?.title {
                titleLabel.text = title
            }
            if let company = job?.company {
                companyLabel.text = company
            }
            if let location = job?.location {
                locationLabel.text = location
            }
            if let date = job?.date {
                timeLabel.text = date
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "position title"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.text = "company name"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "location"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "time"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func setupViews() {
        backgroundColor = .white
        
        self.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        self.addSubview(companyLabel)
        companyLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        companyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        companyLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        companyLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        self.addSubview(locationLabel)
        locationLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 5).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        timeLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: locationLabel.rightAnchor, constant: 10).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        
    }
    
    
}

