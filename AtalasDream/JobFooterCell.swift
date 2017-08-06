//
//  JobFooterCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/26/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class JobFooterCell: BaseCollectionViewCell {
    let indicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .black
        ai.startAnimating()
        return ai
    }()
    
    override func setupViews() {
        self.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
