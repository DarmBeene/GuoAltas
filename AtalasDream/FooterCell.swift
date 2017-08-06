//
//  CourseFooterCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/21/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class FooterCell: UICollectionViewCell {
    
    let grayBackgroundColor = UIColor(r: 237, g: 238, b: 240, alpha: 1)
    
    let indicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .black
        ai.startAnimating()
        return ai
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = grayBackgroundColor
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupViews() {
        self.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
