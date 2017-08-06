//
//  Service.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/28/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

struct ServiceType {
    var serviceName: String?
    var serviceImage: UIImage?
}

struct ServiceName {
    static let SecondHand = "SecondHand"
    static let RentHouse = "RentHouse"
    static let HoldActivity = "HoldActivity"
    static let PartTimeJob = "PartTimeJob"
}

struct ServiceConstants {
    static let services = [ServiceType(serviceName: "二手市场", serviceImage: UIImage(named: "flea_market")),
                           ServiceType(serviceName: "房屋出租", serviceImage: UIImage(named: "rent_house")),
                           ServiceType(serviceName: "活动", serviceImage: UIImage(named: "activities_icon")),
                           ServiceType(serviceName: "兼职", serviceImage: UIImage(named: "partTime"))
                           ]
    
    static let states = ["Baden_Wuerttemberg": "巴-符",
                         "Bayern": "巴伐利亚",
                         "Berlin": "柏林",
                         "Brandenburg": "勃兰登堡",
                         "Bremen": "不来梅",
                         "Hamburg": "汉堡",
                         "Hessen": "黑森",
                         "Mecklenburg_Vorpommern": "梅-前",
                         "Niedersachsen": "下萨克森",
                         "Nordrhein_Westfalen": "北-威",
                         "Rheinland_Pfalz": "莱-普",
                         "Saarland": "萨尔",
                         "Sachsen": "萨克森",
                         "Sachsen_Anhalt": "萨-安",
                         "Schleswig_Holstein": "石-荷",
                         "Thueringen": "图林根"
    ]
    
}
