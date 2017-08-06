//
//  CustomTextField.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/24/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor(r: 226, g: 226, b: 228).cgColor
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
