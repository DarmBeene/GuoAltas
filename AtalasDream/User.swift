//
//  User.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/19/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class User {
    
    var displayName: String?
    var email: String?
    var photoURL: String?
    
    init(displayName: String?, email: String?, photoURL: String?) {
        self.displayName = displayName
        self.email = email
        self.photoURL = photoURL
    }
    
    init(snapshot: FIRDataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return }
        
        self.displayName = value["displayName"] as? String
        self.email = value["email"] as? String
        self.photoURL = value["photoURL"] as? String
    }
    
    func toAny() -> Any {
        return [
            "displayName": displayName,
            "email": email,
            "photoURL": photoURL
        ]
        
        
    }
    
}
