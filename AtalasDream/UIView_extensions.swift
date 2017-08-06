//
//  Extensions.swift
//  AtalasDream
//
//  Created by GuoGongbin on 5/29/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}

extension UIView {
    func prompt(message: String, completion: (() -> Void)? = nil) {
        for subview in self.subviews {
            if subview is PromptView {
                subview.removeFromSuperview()
            }
        }
        let rect = CGRect(x: 0, y: 0, width: 200, height: 80)
        let promptView = PromptView(frame: rect)
        self.addSubview(promptView)
        promptView.center = self.center
        
        promptView.label.text = message
        UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            promptView.alpha = 1
        }, completion: { (completed) in
            promptView.alpha = 0
            if completion != nil {
                completion!()
            }
        })
    }
    
    func layoutView(equalToLeftAnchor lAnchor: NSLayoutXAxisAnchor?, leftConstant: CGFloat = 0,
                    equalToRightAnchor rAnchor: NSLayoutXAxisAnchor?, rightConstant: CGFloat = 0,
                    equalToTopAnchor tAnchor: NSLayoutYAxisAnchor?, topConstant: CGFloat = 0,
                    equalToBottomAnchor bAnchor: NSLayoutYAxisAnchor?, bottomConstant: CGFloat = 0,
                    widthConstant: CGFloat, heightConstant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let lAnchor = lAnchor {
            leftAnchor.constraint(equalTo: lAnchor, constant: leftConstant).isActive = true
        }
        if let rAnchor = rAnchor {
            rightAnchor.constraint(equalTo: rAnchor, constant: rightConstant).isActive = true
        }
        if let tAnchor = tAnchor {
            topAnchor.constraint(equalTo: tAnchor, constant: topConstant).isActive = true
        }
        if let bAnchor = bAnchor {
            bottomAnchor.constraint(equalTo: bAnchor, constant: bottomConstant).isActive = true
        }
        if widthConstant > 0 {
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        if heightConstant > 0 {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }
}


