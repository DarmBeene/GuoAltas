//
//  PublishJobView.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/24/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
//title, 发布时间, 职位信息， 任职要求，公司名称，联系方式，公司信息
//10 + (40+5) + (40+5) +(40+5) +(40+5) +(40) +15 + (20+5+200+5) + (20+5+200+5) + (20+5+200) = 930
import UIKit

class PublishJobView: UIView {
    let textFieldHeight: CGFloat = 40
    let labelHeight: CGFloat = 20
    
    let titleTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "职位名称"
        return tf
    }()
    let locationTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "地点"
        return tf
    }()
    
    let companyTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "公司名称"
        return tf
    }()
    let emailTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "email 地址"
        return tf
    }()
    let phoneNumberTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "电话"
        return tf
    }()
    
    let companyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "公司描述:"
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let companyTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = GlobalConstants.TextFieldBGC
        tv.font = UIFont.systemFont(ofSize: JobConstant.TextViewFontSize + 1)
        return tv
    }()
    
    let positionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "职位描述:"
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let positionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = GlobalConstants.TextFieldBGC
        tv.font = UIFont.systemFont(ofSize: JobConstant.TextViewFontSize + 1)
        return tv
    }()
    
    let requirementLabel: UILabel = {
        let label = UILabel()
        label.text = "任职要求:"
        label.font = UIFont.systemFont(ofSize: JobConstant.LabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var requirementTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = GlobalConstants.TextFieldBGC
        tv.font = UIFont.systemFont(ofSize: JobConstant.TextViewFontSize + 1)
        return tv
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupViews() {
        
        addSubview(titleTextField)
        titleTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        titleTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        addSubview(companyTextField)
        companyTextField.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        companyTextField.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        companyTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5).isActive = true
        companyTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: companyTextField.bottomAnchor, constant: 5).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        addSubview(phoneNumberTextField)
        phoneNumberTextField.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        phoneNumberTextField.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        phoneNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        addSubview(locationTextField)
        locationTextField.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        locationTextField.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        locationTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 5).isActive = true
        locationTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true

        addSubview(companyDescriptionLabel)
        companyDescriptionLabel.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        companyDescriptionLabel.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 15).isActive = true
        companyDescriptionLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(companyTextView)
        companyTextView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        companyTextView.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        companyTextView.topAnchor.constraint(equalTo: companyDescriptionLabel.bottomAnchor, constant: 5).isActive = true
        companyTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        addSubview(positionDescriptionLabel)
        positionDescriptionLabel.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        positionDescriptionLabel.topAnchor.constraint(equalTo: companyTextView.bottomAnchor, constant: 5).isActive = true
        positionDescriptionLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(positionTextView)
        positionTextView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        positionTextView.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        positionTextView.topAnchor.constraint(equalTo: positionDescriptionLabel.bottomAnchor, constant: 5).isActive = true
        positionTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        addSubview(requirementLabel)
        requirementLabel.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        requirementLabel.topAnchor.constraint(equalTo: positionTextView.bottomAnchor, constant: 5).isActive = true
        requirementLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(requirementTextView)
        requirementTextView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        requirementTextView.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        requirementTextView.topAnchor.constraint(equalTo: requirementLabel.bottomAnchor, constant: 5).isActive = true
        requirementTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
    }
    
    
    
}







