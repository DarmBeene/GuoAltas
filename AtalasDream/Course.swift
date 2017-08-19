//
//  Course.swift
//  AtalasDream
//
//  Created by GuoGongbin on 5/19/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
import Foundation

class Course: NSObject {
    var university: String? //学校信息
    var department: String? // 学院信息
    var name: String? // 课程名称, 课程名称全部小写
    var link: String? // 分享链接
    var courseDescription: String? // 对课程的描述
    var courseKey: String? // 这个courseKey对应firebase上的key，获取courseKey的代码 self.courseKey = snapshot.key
    var uid: String? // FIRAuth.auth()?.currentUser?.uid，分享者的user id
    var date: String? //分享的时间
    
    init(university: String?, department: String?, name: String?, link: String?, courseDescription: String?, uid: String?, date: String?) {
        self.university = university
        self.department = department
        self.name = name?.lowercased()
        self.link = link
        self.courseDescription = courseDescription
        self.uid = uid
        self.date = date
    }
    
    init(snapshot: FIRDataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return }
        
        self.university = value["university"] as? String
        self.department = value["department"] as? String
        self.name = value["name"] as? String
        self.link = value["link"] as? String
        self.courseDescription = value["courseDescription"] as? String
        self.courseKey = snapshot.key
        self.uid = value["uid"] as? String
        self.date = value["date"] as? String
    }
    
    func toAny() -> Any {
        return [
            "university": university,
            "department": department,
            "name": name,
            "link": link,
            "courseDescription": courseDescription,
            "uid": uid,
            "date": date
        ]
    }
}
