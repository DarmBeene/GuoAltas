//
//  CourseCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 5/18/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class CourseCell: BaseCollectionViewCell {
    
    let labelHeight: CGFloat = 30
    let seperationLineColor = UIColor(r: 242, g: 242, b: 242, alpha: 1)
    
    var course: Course? {
        didSet{
            if let university = course?.university {
                universityLabel.text = "学校: \(university)"
            }
            if let department = course?.department {
                departmentLabel.text = "学院: \(department)"
            }
            if let courseDescription = course?.courseDescription {
                descriptionLabel.text = "描述: \(courseDescription)"
            }
            if let title = course?.name {
                titleLabel.text = "课程: \(title)"
            }
            if let uid = course?.uid {
                let ref = FirDatabasePath.UserReference.child(uid)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    if let photoURL = user.photoURL {
                        self.imageView.loadImageFrom(urlString: photoURL)
                    }
                    if let displayName = user.displayName {
                        self.shareLabel.text = "\(displayName) 分享了"
                    }
                })
            }
            if let date = course?.date {
                dateLabel.text = date
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "anonymous")
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    let shareLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let universityLabel: UILabel = {
        let label = UILabel()
        label.text = "university name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let departmentLabel: UILabel = {
        let label = UILabel()
        label.text = "department name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "description context"
        label.font = UIFont.systemFont(ofSize: CourseConstants.DescriptionLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    lazy var shareSeperationLine: UIView = {
        let view = UIView()
        view.backgroundColor = self.seperationLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleSeperationLine: UIView = {
        let view = UIView()
        view.backgroundColor = self.seperationLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descriptionSeperationLine: UIView = {
        let view = UIView()
        view.backgroundColor = self.seperationLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var universitySeperationLine: UIView = {
        let view = UIView()
        view.backgroundColor = self.seperationLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var descriptionHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        self.backgroundColor = .white
        
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(dateLabel)
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(shareLabel)
        shareLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        shareLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        shareLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        shareLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(shareSeperationLine)
        shareSeperationLine.leftAnchor.constraint(equalTo: shareLabel.leftAnchor).isActive = true
        shareSeperationLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        shareSeperationLine.topAnchor.constraint(equalTo: shareLabel.bottomAnchor).isActive = true
        shareSeperationLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: shareLabel.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: shareLabel.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: shareLabel.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(titleSeperationLine)
        titleSeperationLine.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        titleSeperationLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleSeperationLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        titleSeperationLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.leftAnchor.constraint(equalTo: shareLabel.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: shareLabel.rightAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: labelHeight * 3)
        descriptionHeightConstraint?.isActive = true
        
        addSubview(descriptionSeperationLine)
        descriptionSeperationLine.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor).isActive = true
        descriptionSeperationLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        descriptionSeperationLine.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        descriptionSeperationLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        

        addSubview(universityLabel)
        universityLabel.leftAnchor.constraint(equalTo: shareLabel.leftAnchor).isActive = true
        universityLabel.rightAnchor.constraint(equalTo: shareLabel.rightAnchor).isActive = true
        universityLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        universityLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(universitySeperationLine)
        universitySeperationLine.leftAnchor.constraint(equalTo: universityLabel.leftAnchor).isActive = true
        universitySeperationLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        universitySeperationLine.topAnchor.constraint(equalTo: universityLabel.bottomAnchor).isActive = true
        universitySeperationLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(departmentLabel)
        departmentLabel.leftAnchor.constraint(equalTo: shareLabel.leftAnchor).isActive = true
        departmentLabel.rightAnchor.constraint(equalTo: shareLabel.rightAnchor).isActive = true
        departmentLabel.topAnchor.constraint(equalTo: universityLabel.bottomAnchor).isActive = true
        departmentLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
    }
    
}
