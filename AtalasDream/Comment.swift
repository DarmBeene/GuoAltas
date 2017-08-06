//
//  Comment.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/11/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class Comment: NSObject {
    var content: String?
    var date: String?
    var commentKey: String?
    var uid: String?
    
    init(content: String?, date: String?, uid: String?) {
        self.content = content
        self.date = date
        self.uid = uid
    }
    init(snapshot: FIRDataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return }
        
        self.content = value["content"] as? String
        self.date = value["date"] as? String
        self.uid = value["uid"] as? String
        self.commentKey = snapshot.key
    }
    
    
    func toAny() -> Any {
        return [
        "content": content,
        "date": date,
        "uid": uid
        ]
    }
    
    
}
