//
//  PromptView.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/3/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class PromptView: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews(){
        self.addSubview(label)
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.backgroundColor = .black
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.alpha = 0
        
    }
}
