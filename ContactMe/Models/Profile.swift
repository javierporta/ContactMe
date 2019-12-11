//
//  Profile.swift
//  ContactMe
//
//  Created by formando on 20/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation
import GooglePlaces

class Profile: Entity, Codable {
    
    var name: String?
    var lastName: String?
    var phone: String?
    var dateOfBirth: String?
    var gender: String?
    var carieer: String?
    var job: String?
    var insterest: String?
    var avatar: String?
    var mondayFreeStartTime: String?
    var mondayFreeEndTime: String?
    var tuesdayFreeStartTime: String?
    var tuesdayFreeEndTime: String?
    var wednesdayFreeStartTime: String?
    var wednesdayFreeEndTime: String?
    var thursdayFreeStartTime: String?
    var thursdayFreeEndTime: String?
    var fridayFreeStartTime: String?
    var fridayFreeEndTime: String?
    var saturdayFreeStartTime: String?
    var saturdayFreeEndTime: String?
    var sundayFreeStartTime: String?
    var sundayFreeEndTime: String?
    var connectionId: Int64?
    var connections: [Profile]?
    
    //var university: GMSPlace?
    //var freeTimePlace: GMSPlace?
    
    func fullName() -> String {
        return "\(self.name ?? "") \(self.lastName ?? "")"
    }
    
    override init() {
        self.connections  = [Profile]()
        super.init()
    }
    
    
}
