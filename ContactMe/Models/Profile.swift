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
    var email: String?
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
    var universityName: String?
    var universityLongitude: Double?
    var universityLatitude: Double?
    var freeTimePlaceName: String?
    var freeTimeLongitude: Double?
    var freeTimeLatitude: Double?
    
    var connectionDateTime: String?
    var connectionLocationName: String?
    var connectionLocationLatitude: Double?
    var connectionLocationLongitude: Double?
    
    var insterestArray:Array<String>?
    {
        get{
            if (self.insterest == nil || self.insterest == " - " || self.insterest == "") {
                return Array<String>()
            }else{
               return self.insterest?.components(separatedBy: " - ")
            }
        }
        set{
            self.insterest = newValue?.joined(separator: " - ")
        }
    }
    
    func fullName() -> String {
        return "\(self.name ?? "") \(self.lastName ?? "")"
    }
    
    override init() {
        super.init()
    }
    
    
}
