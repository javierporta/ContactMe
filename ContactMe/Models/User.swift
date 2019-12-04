//
//  User.swift
//  ContactMe
//
//  Created by formando on 20/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

class User: Entity, Codable {
    
    var username: String?
    var password: String?
    var profileId: Int64?
    
}

