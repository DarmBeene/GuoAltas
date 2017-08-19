//
//  JobCompanyCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/27/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

fileprivate let LabelFontSize: CGFloat = 16
class JobCompanyCell: BaseCollectionViewCell {
    
    let labelHeight: CGFloat = 20
    let nameLabelWidth: CGFloat = 50
    var job: Job? {
        didSet{
            if let companyName = job?.company {
                companyNameLabel.text = companyName
            }
            if let email = job?.email {
                emailLabel.text = email
            }
            if let phone = job?.phoneNumber {
                phoneLabel.text = phone
            }
            if let location = job?.location {
                locationLabel.text = location
            }
        }
    }
    let company: UILabel = {
        let label = UILabel()
        label.text = "公司："
        label.font = UIFont.boldSystemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let email: UILabel = {
        let label = UILabel()
        label.text = "邮箱："
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let phone: UILabel = {
        let label = UILabel()
        label.text = "电话："
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let location: UILabel = {
        let label = UILabel()
        label.text = "地址："
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .white
        
        addSubview(company)
        company.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        company.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        company.widthAnchor.constraint(equalToConstant: nameLabelWidth).isActive = true
        company.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(companyNameLabel)
        companyNameLabel.leftAnchor.constraint(equalTo: company.rightAnchor, constant: 5).isActive = true
        companyNameLabel.topAnchor.constraint(equalTo: company.topAnchor).isActive = true
        companyNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        companyNameLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(email)
        email.leftAnchor.constraint(equalTo: company.leftAnchor).isActive = true
        email.topAnchor.constraint(equalTo: company.bottomAnchor, constant: 5).isActive = true
        email.widthAnchor.constraint(equalToConstant: nameLabelWidth).isActive = true
        email.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(emailLabel)
        emailLabel.leftAnchor.constraint(equalTo: companyNameLabel.leftAnchor).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: companyNameLabel.rightAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 5).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(phone)
        phone.leftAnchor.constraint(equalTo: company.leftAnchor).isActive = true
        phone.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 5).isActive = true
        phone.widthAnchor.constraint(equalToConstant: nameLabelWidth).isActive = true
        phone.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(phoneLabel)
        phoneLabel.leftAnchor.constraint(equalTo: companyNameLabel.leftAnchor).isActive = true
        phoneLabel.rightAnchor.constraint(equalTo: companyNameLabel.rightAnchor).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(location)
        location.leftAnchor.constraint(equalTo: company.leftAnchor).isActive = true
        location.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 5).isActive = true
        location.widthAnchor.constraint(equalToConstant: nameLabelWidth).isActive = true
        location.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(locationLabel)
        locationLabel.leftAnchor.constraint(equalTo: companyNameLabel.leftAnchor).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: companyNameLabel.rightAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
    }
    
}

