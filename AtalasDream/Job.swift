//
//  Job.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/23/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//
//title，工作内容，任职要求，工作地点，合同期限，邮箱，电话
import Foundation

class Job: NSObject {
    
    var title: String?
    var company: String?
    var email: String?
    var phoneNumber: String?
    var location: String?
    var companyDescription: String?
    var positionDescription: String?
    var requirement: String?
    var uid: String? //FIRAuth.auth()?.currentUser?.uid
    var date: String?
    var jobKey: String?
 
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
