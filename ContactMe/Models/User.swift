//
//  User.swift
//  ContactMe
//
//  Created by formando on 20/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

class User: Entity {
    
    var username: String
    var password: String
    var profile: Profile
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.profile = Profile(name: username)
        
        super.init()
    }
}

