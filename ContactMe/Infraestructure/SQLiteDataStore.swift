//
//  SQLiteDataStore.swift
//  ContactMe
//
//  Created by formando on 21/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//
import Foundation
import SQLite

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let BBDB: Connection?
   
    private init() {
       
        var path = "ContactMeDb.sqlite"
       
        if let dirs: [NSString] =          NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [NSString] {
               
             let dir = dirs[0]
            print(dir)
            path = dir.appendingPathComponent("ContactMeDb.sqlite");
        }
       
        do {
            BBDB = try Connection(path)
        } catch _ {
            BBDB = nil
        }
    }
   
    func createTables() throws{
        do {
           try UserDataHelper.createTable()
        } catch {
            throw DataAccessError.Datastore_Connection_Error
        }
    }
}
