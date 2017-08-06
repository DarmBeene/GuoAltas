//
//  University.swift
//  AtalasDream
//
//  Created by GuoGongbin on 7/4/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

class University: NSObject, NSCoding {
    
    var name: String?
    var departments: [String]?
    
    init(name: String?, departments: [String]?) {
        self.name = name
        self.departments = departments
        super.init()
    }
    
    init(snapshot: FIRDataSnapshot) {
        guard let value = snapshot.value as? NSArray else { return }
        self.departments = value as? [String]
        self.name = snapshot.key
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String, let departments = aDecoder.decodeObject(forKey: "departments") as? [String] {
            self.name = name
            self.departments = departments
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(departments, forKey: "departments")
    }
    
    
    
    
}
