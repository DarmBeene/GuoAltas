//
//  CustomBackButton.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/5/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class CustomBackButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(named: "back_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
