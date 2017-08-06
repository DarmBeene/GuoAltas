//
//  UIViewController_extensions.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/15/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIViewController {
    func showAlertPrompt(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}







