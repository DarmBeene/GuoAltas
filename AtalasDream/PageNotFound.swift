//
//  PageNotFound.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/8/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class PageNotFound: UIView {
    let label404: UILabel = {
        let label = UILabel()
        label.text = "404"
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        //        label.backgroundColor = .red
        return label
    }()
    let labelImage: UILabel = {
        let label = UILabel()
        label.text = "😞😞😞"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        //                label.backgroundColor = .red
        return label
    }()
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops, 链接出错了"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupViews() {
        self.addSubview(label404)
        label404.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label404.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label404.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 3 / 10 ).isActive = true
        label404.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addSubview(labelImage)
        labelImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        labelImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        labelImage.topAnchor.constraint(equalTo: label404.bottomAnchor).isActive = true
        labelImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(textLabel)
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: labelImage.bottomAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }

}
