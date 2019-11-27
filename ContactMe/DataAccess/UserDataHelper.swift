//
//  UserDataHelper.swift
//  ContactMe
//
//  Created by formando on 21/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation
import SQLite

class UserDataHelper: DataHelperProtocol {    
   
     static let TABLE_NAME = "Teams"
    
     static let table = Table(TABLE_NAME)
     static let dbId = Expression<Int64>("id")
     static let dbUsername = Expression<String>("username")
     static let dbPassword = Expression<String>("password")
    
    
     typealias T = User
    
     static func createTable() throws {
         guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
             throw DataAccessError.Datastore_Connection_Error
         }
         do {
             let _ = try DB.run( table.create(ifNotExists: true) {t in
                 t.column(dbId, primaryKey: true)
                 t.column(dbUsername)
                 t.column(dbPassword)
             })
            
         } catch _ {
             // Error throw if table already exists
         }
        
     }
    
     static func insert(item: T) throws -> Int64 {
         guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
             throw DataAccessError.Datastore_Connection_Error
         }
         if (item.username != "" && item.password != "") {
            let insert = table.insert(dbUsername <- item.username!, dbPassword <- item.password!)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            } catch _ {
                throw DataAccessError.Insert_Error
            }
         }
         throw DataAccessError.Nil_In_Data
        
     }
    
     static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(dbId == item.id)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
     }
    
     static func find(idobj: Int64) throws -> T? {
         guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
             throw DataAccessError.Datastore_Connection_Error
         }
        let query = table.filter(dbId == idobj)
        let items = try DB.prepare(query)
         for item in  items {
            
            let entity = T()
            entity.id = item[dbId]
            entity.username = item[dbUsername]
            entity.password = item[dbPassword]
            
            return entity
         }
        
         return nil
     }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
           
           let entity = T()
           entity.id = item[dbId]
           entity.username = item[dbUsername]
           entity.password = item[dbPassword]
           
           retArray.append(entity)
       }
        return retArray
    }
     
}
