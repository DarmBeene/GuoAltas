//
//  CourseShareView.swift
//  AtalasDream
//
//  Created by GuoGongbin on 5/18/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

private let borderColor = UIColor(r: 205, g: 205, b: 205, alpha: 1).cgColor

protocol ShareCourseViewProtocol {
    func showHelp()
    func selectUniversity()
    func selectDepartment()
}

class ShareCourseView: UIView {
    let textFieldHeight: CGFloat = 40
    let labelHeight: CGFloat = 40
    var delegate: ShareCourseViewProtocol?
    
    lazy var universityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectUniversity)))
        return label
    }()

    lazy var departmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectDepartment)))
        return label
    }()
    let courseTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "请填写课程名称...(必填项)"
        return tf
    }()
    let linkExplanationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "请把Dropbox或者Github链接粘贴进去(必填项)"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    let linkTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = GlobalConstants.TextFieldBGC
        textView.font = UIFont.systemFont(ofSize: GlobalConstants.TextViewFontSize)
        return textView
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "请在下方添加一些描述，比如：年份，学期..."
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = GlobalConstants.TextFieldBGC
        textView.font = UIFont.systemFont(ofSize: GlobalConstants.TextViewFontSize)
        return textView
    }()
    lazy var helpButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" 点击查看帮助", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleHelp), for: .touchUpInside)
        return button
    }()
    
    func handleHelp() {
        delegate?.showHelp()
    }
    func selectUniversity() {
        delegate?.selectUniversity()
    }
    func selectDepartment() {
        delegate?.selectDepartment()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {

        addSubview(universityLabel)
        universityLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        universityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        universityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        universityLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(departmentLabel)
        departmentLabel.leftAnchor.constraint(equalTo: universityLabel.leftAnchor).isActive = true
        departmentLabel.rightAnchor.constraint(equalTo: universityLabel.rightAnchor).isActive = true
        departmentLabel.topAnchor.constraint(equalTo: universityLabel.bottomAnchor, constant: 10).isActive = true
        departmentLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(courseTextField)
        courseTextField.layoutView(equalToLeftAnchor: self.leftAnchor, leftConstant: 10,
                                 equalToRightAnchor: self.rightAnchor, rightConstant: -10,
                                 equalToTopAnchor: departmentLabel.bottomAnchor, topConstant: 10,
                                 equalToBottomAnchor: nil, bottomConstant: 0,
                                 widthConstant: 0, heightConstant: textFieldHeight)
        
        addSubview(linkExplanationLabel)
        linkExplanationLabel.layoutView(equalToLeftAnchor: self.leftAnchor, leftConstant: 10,
                                 equalToRightAnchor: self.rightAnchor, rightConstant: -10,
                                 equalToTopAnchor: courseTextField.bottomAnchor, topConstant: 10,
                                 equalToBottomAnchor: nil, bottomConstant: 0,
                                 widthConstant: 0, heightConstant: 22)
        
        addSubview(helpButton)
        helpButton.layoutView(equalToLeftAnchor: self.leftAnchor, leftConstant: 10,
                              equalToRightAnchor: nil, rightConstant: 0,
                              equalToTopAnchor: linkExplanationLabel.bottomAnchor, topConstant: 0,
                              equalToBottomAnchor: nil, bottomConstant: 0,
                              widthConstant: 0, heightConstant: 20)
        
        addSubview(linkTextView)
        linkTextView.layoutView(equalToLeftAnchor: self.leftAnchor, leftConstant: 10,
                                        equalToRightAnchor: self.rightAnchor, rightConstant: -10,
                                        equalToTopAnchor: helpButton.bottomAnchor, topConstant: 5,
                                        equalToBottomAnchor: nil, bottomConstant: 0,
                                        widthConstant: 0, heightConstant: 150)
        
        addSubview(descriptionLabel)
        descriptionLabel.layoutView(equalToLeftAnchor: self.leftAnchor, leftConstant: 10,
                                        equalToRightAnchor: self.rightAnchor, rightConstant: -10,
                                        equalToTopAnchor: linkTextView.bottomAnchor, topConstant: 10,
                                        equalToBottomAnchor: nil, bottomConstant: 0,
                                        widthConstant: 0, heightConstant: 22)
        
        addSubview(descriptionTextView)
        descriptionTextView.layoutView(equalToLeftAnchor: self.leftAnchor, leftConstant: 10,
                                equalToRightAnchor: self.rightAnchor, rightConstant: -10,
                                equalToTopAnchor: descriptionLabel.bottomAnchor, topConstant: 5,
                                equalToBottomAnchor:self.bottomAnchor, bottomConstant: -10,
                                widthConstant: 0, heightConstant: 0)
        
    }
    
}





