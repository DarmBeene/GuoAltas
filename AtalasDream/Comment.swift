//
//  Comment.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/11/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class Comment: NSObject {
    var content: String? //评论内容
    var date: String? //评论时间
    var commentKey: String? // 这个commentKey对应firebase上的key，获取commentKey的代码 self.commentKey = snapshot.key
    var uid: String? // FIRAuth.auth()?.currentUser?.uid，分享者的user id
    
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
