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
            
            if (self.getRegisterUserByUserName(username: user.username!) != nil){
                throw DataAccessError.User_Exist
            }
            
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
                    
                    //ToDo: quitar despues
                    let userArrayData = try! JSONEncoder().encode(userArray)
                    let userArrayJson = String(data: userArrayData, encoding: .utf8)!
                    print(userArrayJson)
                }
            }
            catch let error{
                print (error)
            }
        }
        return userArray
    }
    
    static func saveUserSession(user: User) -> Bool{
        
        if self.keychain[Constants.USER_DATA_KEY] != nil {
            
            do {
                
                let userData = try! JSONEncoder().encode(user)
                let userJson = String(data: userData, encoding: .utf8)!
                
                try self.keychain.set(userJson, key: Constants.CURRENT_USER_KEY)
                
                return true
            }
            catch let error {
                print(error)
            }
            
        }
        
        return false
    }
    
    static func deleteUserSession() -> Bool?{
        
        if self.keychain[Constants.CURRENT_USER_KEY] != nil {
            
            do {
                try self.keychain.remove(Constants.CURRENT_USER_KEY)
                
                return true
            }
            catch let error {
                print(error)
            }
            
        }
        
        return false
    }
    
    static func getCurrentUserSession()-> User?{
        if self.keychain[Constants.CURRENT_USER_KEY] != nil {
            do{
                let userJson = try self.keychain.get(Constants.CURRENT_USER_KEY)
                
                if let dataJson = userJson?.data(using: .utf8) {
                    let currentUser = try JSONDecoder().decode(User.self, from:dataJson)
                    
                    return currentUser
                }
            }
            catch let error{
                print (error)
            }
        }
        return nil
    }
    
    
    
}
