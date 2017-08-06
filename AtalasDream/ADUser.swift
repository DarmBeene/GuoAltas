//
//  ADUser.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/17/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import Foundation
import UIKit

class ADUser {
    static let shared = ADUser()
    
    var displayName: String?
    var email: String?
    var photoUrl: URL?
    var profileImage: UIImage?
    var gender: String?
    
    
}
