//
//  GlobalVariables.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/13/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation

struct BlackListType {
    static let LocalEntertainBlackList = "LocalEntertainBlackList"
    static let LocalEntertainBlackListMessage = "LocalEntertainBlackListMessage"
    
}

struct AdMobConstants {
    static let AppID = "ca-app-pub-4312045484173854~5233054508"
    static let AdUnitID = "ca-app-pub-4312045484173854/3213040605"
}

struct GlobalConstants {
    static let CollectionViewBGC = UIColor(r: 237, g: 238, b: 240)
    static let TextFieldBGC = UIColor(r: 245, g: 250, b: 255)
    static let ButtonFontSize: CGFloat = 17
    static let TextViewFontSize: CGFloat = 16
    static let AppName = "AtlasDream"
}

struct UserDefaultsKey {
    static let State = "State"
    static let MyUniversity = "MyUniversity"
    static let MyDepartment = "MyDepartment"
    static let UniversityName = "UniversityName"
    static let Town = "Town"
}

struct NotificationNameConstants {
    static let RegisterSuccessNotification = "RegisterSuccess"
    static let LoginSuccessNotification = "LoginSuccess"
    static let ChangeNameNotification = "ChangeNameNotification"
    static let ChangeStateNotification = "ChangeStateNotification"
    static let ReloadMyPublishedService = "ReloadMyPublishedService"
    static let ReloadMyJobNotification = "ReloadMyJobNotification"
    static let ReloadMyFavoritesNotification = "ReloadMyFavoritesNotification"
    static let ReloadMyEntertainNotification = "ReloadMyEntertainNotification"
    static let ChangeTownNotification = "ChangeTownNotification"
}

struct FirDatabasePath {
    static let CourseReference = FIRDatabase.database().reference(withPath: "Course")
    static let UserReference = FIRDatabase.database().reference(withPath: "Users")
    static let JobReference = FIRDatabase.database().reference(withPath: "Job")
    static let SecondHandReference = FIRDatabase.database().reference(withPath: "SecondHand")
    static let RentHouseReference = FIRDatabase.database().reference(withPath: "RentHouse")
    static let HoldActivityReference = FIRDatabase.database().reference(withPath: "HoldActivity")
    static let PartTimeJobReference = FIRDatabase.database().reference(withPath: "PartTimeJob")
    static let TownsReference = FIRDatabase.database().reference(withPath: "Towns")
    static let CommentReference = FIRDatabase.database().reference(withPath: "Comment")
    static let FeedbackReference = FIRDatabase.database().reference(withPath: "Feedback")
}



