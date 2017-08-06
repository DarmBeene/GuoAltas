//
//  String+Extension.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/11/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

extension String {
    func height(withWidth width: CGFloat, attributes: [String : Any]? = nil) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let rect = (self as NSString).boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil)
        return ceil(rect.height)
    }
}
