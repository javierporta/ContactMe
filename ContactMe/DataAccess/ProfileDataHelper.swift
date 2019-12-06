//
//  ProfileDataHelper.swift
//  ContactMe
//
//  Created by royli on 05/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation
import SQLite

class ProfileDataHelper: DataHelperProtocol {
    
    static let TABLE_NAME = "Profiles"
    
    static let table = Table(TABLE_NAME)
    static let dbId = Expression<Int64>("id")
    static let dbName = Expression<String>("name")
    static let dbLastName = Expression<String?>("lastname")
    static let dbPhone = Expression<String?>("phone")
    static let dbAge = Expression<Int?>("age")
    static let dbGender = Expression<String?>("gender")
    static let dbUniversity = Expression<String?>("university")
    static let dbSpecialty = Expression<String?>("specialty")
    static let dbOccupation = Expression<String?>("occupation")
    
    
    typealias T = Profile
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(dbId, primaryKey: true)
                t.column(dbName)
                t.column(dbLastName)
                t.column(dbPhone)
                t.column(dbAge)
                t.column(dbGender)
                t.column(dbUniversity)
                t.column(dbSpecialty)
                t.column(dbOccupation)
            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.name != "") {
            let insert = table.insert(dbName <- item.name, dbLastName <- item.lastName!, dbPhone <- item.phone!, dbAge <- item.age!, dbGender <- item.gender!, dbUniversity <- item.university!, dbSpecialty <- item.specialty!, dbOccupation <- item.occupation!)
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
            
            let entity = T(name: item[dbName])
            entity.id = item[dbId]
            entity.lastName = item[dbLastName]
            entity.phone = item[dbPhone]
            entity.age = item[dbAge]
            entity.gender = item[dbGender]
            entity.university = item[dbUniversity]
            entity.specialty = item[dbSpecialty]
            entity.occupation = item[dbOccupation]
            
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
            
            let entity = T(name: item[dbName])
            entity.id = item[dbId]
            entity.lastName = item[dbLastName]
            entity.phone = item[dbPhone]
            entity.age = item[dbAge]
            entity.gender = item[dbGender]
            entity.university = item[dbUniversity]
            entity.specialty = item[dbSpecialty]
            entity.occupation = item[dbOccupation]
            
            retArray.append(entity)
        }
        return retArray
    }
    
}
