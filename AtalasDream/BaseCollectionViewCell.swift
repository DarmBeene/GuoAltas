//
//  BaseCollectionViewCell.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/23/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
    }
}
