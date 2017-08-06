//
//  SafariActivity.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/8/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class SafariActivity: UIActivity {
    
    var url: URL?
    
    override var activityType: UIActivityType? {
        get {
            return UIActivityType("SafariActivity")
        }
    }
    override var activityTitle: String?{
        get {
            return "Open in Safari"
        }
    }
    override var activityImage: UIImage?{
        return UIImage(named: "safari_icon")
    }
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if (item is URL) && UIApplication.shared.canOpenURL(item as! URL) {
                return true
            }
        }
        return false
    }
    override class var activityCategory: UIActivityCategory {
        return .action
    }
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if (item is URL) && UIApplication.shared.canOpenURL(item as! URL) {
                self.url = item as? URL
            }
        }
    }
    override func perform() {
        UIApplication.shared.open(self.url!, options: [:], completionHandler: nil)
        UIApplication.shared.open(self.url!, options: [:]) { (completed) in
            self.activityDidFinish(completed)
        }
    }
    
}

