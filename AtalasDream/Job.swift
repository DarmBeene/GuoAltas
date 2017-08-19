//
//  Job.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/23/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
import Foundation

class Job: NSObject {
    
    var title: String? //招聘信息名称
    var company: String? //公司名称
    var email: String? // email 地址
    var phoneNumber: String?
    var location: String? //工作地点
    var companyDescription: String? // g公司描述
    var positionDescription: String? //职位描述
    var requirement: String? // 任职要求
    var uid: String? //FIRAuth.auth()?.currentUser?.uid，发布者的user id
    var date: String? //发布的时间
    var jobKey: String? //  这个jobKey对应firebase上的key，获取jobKey的代码 self.jobKey = snapshot.key
 
    init(title: String?, company: String?, email: String?, phoneNumber: String?, location: String?, companyDescription: String?, positionDescription: String?, requirement: String?, uid: String?, date: String?) {
        self.title = title
        self.company = company
        self.email = email
        self.phoneNumber = phoneNumber
        self.location = location
        self.companyDescription = companyDescription
        self.positionDescription = positionDescription
        self.requirement = requirement
        self.uid = uid
        self.date = date
    }
    
    init(snapshot: FIRDataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return }
        
        self.title = value["title"] as? String
        self.company = value["company"] as? String
        self.email = value["email"] as? String
        self.phoneNumber = value["phoneNumber"] as? String
        self.location = value["location"] as? String
        self.companyDescription = value["companyDescription"] as? String
        self.positionDescription = value["positionDescription"] as? String
        self.requirement = value["requirement"] as? String
        self.uid = value["uid"] as? String
        self.date = value["date"] as? String
        self.jobKey = snapshot.key
        
    }
    func toAny() -> Any {
        return [
            "title": title,
            "company": company,
            "email": email,
            "phoneNumber": phoneNumber,
            "location": location,
            "companyDescription": companyDescription,
            "positionDescription": positionDescription,
            "requirement": requirement,
            "uid": uid,
            "date": date
        ]
    }
    
}
