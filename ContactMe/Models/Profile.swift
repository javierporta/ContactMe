//
//  Profile.swift
//  ContactMe
//
//  Created by formando on 20/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

class Profile: Entity, Codable {
    
    var name: String
    var lastName: String?
    var phone: String?
    var age: Int?
    var gender: String?
    var university: String?
    var specialty: String?
    var occupation: String?
    
    func fullName() -> String {
        return "\(self.name) \(self.lastName ?? "")"
    }
    
    
    init(name: String) {
        self.name = name
        self.lastName = ""
        self.phone = ""
        self.age = 0
        self.gender = ""
        self.university = ""
        self.specialty = ""
        self.occupation = ""
        
        super.init()
    }
    
}
