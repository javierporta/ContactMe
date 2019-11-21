//
//  Record.swift
//  ContactMe
//
//  Created by formando on 14/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

class Record {
    // Name | Employee Id | Designation
    var name: String
    var employeeId: String
    var designation: String
    
    init(name: String, employeeId: String, designation: String) {
        self.name = name
        self.employeeId = employeeId
        self.designation = designation
    }
}
