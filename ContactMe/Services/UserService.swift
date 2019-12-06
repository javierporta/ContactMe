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
        var userArrayJson = ""
        do {
            
            var array = self.getAllUsers()
            array.append(user)
            
            let userArrayData = try! JSONEncoder().encode(array)
            userArrayJson = String(data: userArrayData, encoding: .utf8)!
            try self.keychain.set(userArrayJson, key: Constants.USER_DATA_KEY)
        }
        catch let error {
            print(error)
        }
        return userArrayJson
    }
    
    static func getRegisterUserByUserName(username: String)-> User?{
        if self.keychain[Constants.USER_DATA_KEY] != nil {
            do{
                let userArrayJson = try self.keychain.get(Constants.USER_DATA_KEY)
                
                if let dataJson = userArrayJson?.data(using: .utf8) {
                    let userArray = try JSONDecoder().decode([User].self, from:dataJson)
                    
                    let user = userArray.filter{ $0.username == username}.first
                    
                    return user
                }
            }
            catch let error{
                print (error)
            }
        }
        return nil
    }
    
    static func getAllUsers()-> [User]{
        
        var userArray = [User]()
        
        if self.keychain[Constants.USER_DATA_KEY] != nil {
            do{
                let userArrayJson = try self.keychain.get(Constants.USER_DATA_KEY)
                
                if let dataJson = userArrayJson?.data(using: .utf8) {
                    userArray = try JSONDecoder().decode([User].self, from:dataJson)
                }
            }
            catch let error{
                print (error)
            }
        }
        return userArray
    }
    
}
