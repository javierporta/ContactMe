//
//  Entity.swift
//  ContactMe
//
//  Created by formando on 20/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

class Entity {
    
    var id: String
    
    init() {
        self.id = NSUUID().uuidString
    }
}
