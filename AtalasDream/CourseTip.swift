//
//  CourseTip.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/8/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class CourseTip: NSObject {
    
    var name: String?
    var content: String?
    var university: String?
    var department: String?
    var uid: String?
    var date: String?
    var courseTipKey: String?
    
    init(name: String?, content: String?, university: String?, department: String?, uid: String?, date: String?) {
        self.name = name
        self.content = content
        self.university = university
        self.department = department
        self.uid = uid
        self.date = date
    }
    init(snapshot: FIRDataSnapshot) {
        
    }
    
    func toAny() -> Any {
        return [
        "name": name,
        "content": content,
        "university": university,
        "department": department,
        "uid": uid,
        "date": date
        ]
    }
}
