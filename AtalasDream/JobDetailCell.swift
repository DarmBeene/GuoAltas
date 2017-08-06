//
//  JobDetailCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/27/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class JobDetailCell: BaseCollectionViewCell {
    let labelHeight: CGFloat = 20
    let emptyTextViewHeight: CGFloat = 10
    
    var job: Job? {
        didSet{
            if let companyDescription = job?.companyDescription {
                companyTextView.text = companyDescription
            }
            if let positionDescription = job?.positionDescription {
                positionTextView.text = positionDescription
            }
            if let requirement = job?.requirement {
                requirementTextView.text = requirement
            }
        }
    }
    
    let companyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "公司描述:"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let companyTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: JobConstant.TextViewFontSize)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = GlobalConstants.TextFieldBGC
        return tv
    }()
    
    let positionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "职位描述:"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let positionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: JobConstant.TextViewFontSize)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = GlobalConstants.TextFieldBGC
        return tv
    }()
    
    let requirementLabel: UILabel = {
        let label = UILabel()
        label.text = "任职要求:"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var requirementTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: JobConstant.TextViewFontSize)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = GlobalConstants.TextFieldBGC
        return tv
    }()
    
    var companyHeightAnchor: NSLayoutConstraint?
    var positionHeightAnchor: NSLayoutConstraint?
    var requirementHeightAnchor: NSLayoutConstraint?
    
    override func setupViews() {
        backgroundColor = .white
        
        addSubview(companyDescriptionLabel)
        companyDescriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        companyDescriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        companyDescriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        companyDescriptionLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(companyTextView)
        companyTextView.leftAnchor.constraint(equalTo: companyDescriptionLabel.leftAnchor).isActive = true
        companyTextView.rightAnchor.constraint(equalTo: companyDescriptionLabel.rightAnchor).isActive = true
        companyTextView.topAnchor.constraint(equalTo: companyDescriptionLabel.bottomAnchor, constant: 5).isActive = true
        companyHeightAnchor = companyTextView.heightAnchor.constraint(equalToConstant: emptyTextViewHeight)
        companyHeightAnchor?.isActive = true
//        companyTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(positionDescriptionLabel)
        positionDescriptionLabel.leftAnchor.constraint(equalTo: companyDescriptionLabel.leftAnchor).isActive = true
        positionDescriptionLabel.topAnchor.constraint(equalTo: companyTextView.bottomAnchor, constant: 5).isActive = true
        positionDescriptionLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(positionTextView)
        positionTextView.leftAnchor.constraint(equalTo: companyDescriptionLabel.leftAnchor).isActive = true
        positionTextView.rightAnchor.constraint(equalTo: companyDescriptionLabel.rightAnchor).isActive = true
        positionTextView.topAnchor.constraint(equalTo: positionDescriptionLabel.bottomAnchor, constant: 5).isActive = true
        positionHeightAnchor = positionTextView.heightAnchor.constraint(equalToConstant: emptyTextViewHeight)
        positionHeightAnchor?.isActive = true
        
        addSubview(requirementLabel)
        requirementLabel.leftAnchor.constraint(equalTo: companyDescriptionLabel.leftAnchor).isActive = true
        requirementLabel.topAnchor.constraint(equalTo: positionTextView.bottomAnchor, constant: 5).isActive = true
        requirementLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(requirementTextView)
        requirementTextView.leftAnchor.constraint(equalTo: companyDescriptionLabel.leftAnchor).isActive = true
        requirementTextView.rightAnchor.constraint(equalTo: companyDescriptionLabel.rightAnchor).isActive = true
        requirementTextView.topAnchor.constraint(equalTo: requirementLabel.bottomAnchor, constant: 5).isActive = true
        requirementHeightAnchor = requirementTextView.heightAnchor.constraint(equalToConstant: emptyTextViewHeight)
        requirementHeightAnchor?.isActive = true
    }
    
    
}
