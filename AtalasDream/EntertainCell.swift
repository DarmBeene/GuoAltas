//
//  EntertainCell.swift
//  AtalasDream
//
//  Created by Gongbin Guo on 7/31/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class EntertainCell: BaseCollectionViewCell {
    
    var entertainment: Entertainment? {
        didSet{
            if let date = entertainment?.date {
                dateLabel.text = date
            }
            if let title = entertainment?.title {
                titleLabel.text = title
            }
            if let uid = entertainment?.uid {
                let ref = FirDatabasePath.UserReference.child(uid)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    self.entertainment?.user = user
                    if let photoURL = user.photoURL {
                        self.imageView.loadImageFrom(urlString: photoURL)
                    }
                    if let displayName = user.displayName {
                        self.shareLabel.text = displayName
                    }
                })
            }
        }
    }
    
    let labelHeight: CGFloat = 30
    let seperationLineColor = UIColor(r: 242, g: 242, b: 242, alpha: 1)
    
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
    }
    
    
}















