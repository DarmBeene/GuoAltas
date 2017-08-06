//
//  Service.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/29/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class Service: NSObject {
    
    var title: String?
    var content: String?
    var date: String?
    var uid: String?
    var serviceKey: String?
    var location: String?
    
    init(title: String?, content: String?, date: String?, uid: String?, location: String?) {
        self.title = title
        self.content = content
        self.date = date
        self.uid = uid
        self.location = location
    }
    
    init(snapshot: FIRDataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return }
        self.title = value["title"] as? String
        self.content = value["content"] as? String
        self.date = value["date"] as? String
        self.uid = value["uid"] as? String
        self.location = value["location"] as? String
        
        self.serviceKey = snapshot.key
        
    }
    
    func toAny() -> Any {
        return [
            "title": title,
            "content": content,
            "date": date,
            "location": location,
            "uid": uid
        ]
    }
    
}
