//
//  UserService.swift
//  ContactMe
//
//  Created by royli on 04/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation
import KeychainAccess

class UserService {
    
    private static let keychain = Keychain(service: Constants.KEYCHAIN_SERVICE)
    
    
    static func createUser(user: User)->String{
        var userJson = ""
        do {
            let userData = try! JSONEncoder().encode(user)
            userJson = String(data: userData, encoding: .utf8)!
            try self.keychain.set(userJson, key: Constants.USER_DATA_KEY)
        }
        catch let error {
            print(error)
        }
        return userJson
    }
    
    static func getRegisterUser()-> User?{
        if self.keychain[Constants.USER_DATA_KEY] != nil {
            do{
                let userJson = try self.keychain.get(Constants.USER_DATA_KEY)
                
                if let dataJson = userJson?.data(using: .utf8) {
                    let user = try JSONDecoder().decode(User.self, from:dataJson)
                    
                    return user
                }
            }
            catch let error{
                print (error)
            }
        }
        return nil
    }
    
}
