//
//  Profile.swift
//  ContactMe
//
//  Created by formando on 20/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

class Profile: Entity {
    
    var name: String
    var lastName: String?
    var phone: String?
    var age: Int?
    var gender: String?
    var university: String?
    var specialty: String?
    var occupation: String?
    
    init(name: String) {
        self.name = name
        
        super.init()
    }
    
}
