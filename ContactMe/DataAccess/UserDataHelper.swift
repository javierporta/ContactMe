//
//  UserDataHelper.swift
//  ContactMe
//
//  Created by formando on 21/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation
import os.log
import SQLite3

class UserDataHelper: DataHelperProtocol {    
   
    typealias T = User
    static let TABLE_NAME = "Users"
    
    // we use prepared statements for efficiency and safe guard against sql injection.
    static var insertEntryStmt: OpaquePointer?
    static var readEntryStmt: OpaquePointer?
    static var readAllEntryStmt: OpaquePointer?
    static var updateEntryStmt: OpaquePointer?
    static var deleteEntryStmt: OpaquePointer?
    
    static let oslog = OSLog(subsystem: "codewithayush", category: "sqliteintegration")
    
    static let db = SQLiteDataStore.sharedInstance.db
   
    static func createTable() throws {
        
        let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS "+TABLE_NAME+" (id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL, password TEXT NOT NULL)", nil, nil, nil)
        if (ret != SQLITE_OK) {
            // corrupt database.
            logDbErr("Error creating db table - "+TABLE_NAME)
            throw DataAccessError.Datastore_Connection_Error
        }
       
    }
   
    static func insert(item: T) throws -> Int64 {
        
        // ensure statements are created on first usage if nil
        guard self.prepareInsertEntryStmt() == SQLITE_OK else
        {
             throw DataAccessError.Datastore_Connection_Error
        }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.insertEntryStmt)
        }
        
        if sqlite3_bind_text(insertEntryStmt, 1, (item.username as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            throw DataAccessError.Insert_Error
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 2, (item.password as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            throw DataAccessError.Insert_Error
        }
        
        //executing the query to insert values
        let r = sqlite3_step(self.insertEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(insertEntryStmt) \(r)")
            throw DataAccessError.Insert_Error
        }
        
         return 1
    }
    
    static func update(item: T) throws -> Int64 {
        
        // ensure statements are created on first usage if nil
        guard self.prepareUpdateEntryStmt() == SQLITE_OK else {  throw DataAccessError.Datastore_Connection_Error }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.updateEntryStmt)
        }
        if sqlite3_bind_text(self.updateEntryStmt, 1, (item.username as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(updateEntryStmt)")
            throw DataAccessError.Update_Error
        }
        
        if sqlite3_bind_text(self.updateEntryStmt, 2, (item.password as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(updateEntryStmt)")
            throw DataAccessError.Update_Error
        }
        
        //executing the query to update values
        let r = sqlite3_step(self.updateEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(updateEntryStmt) \(r)")
            throw DataAccessError.Update_Error
        }
        
        return 1
    }
   
    static func delete (item: T) throws -> Void {
        // ensure statements are created on first usage if nil
        guard self.prepareDeleteEntryStmt() == SQLITE_OK else {  throw DataAccessError.Datastore_Connection_Error }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.deleteEntryStmt)
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 1, String(item.id), -1, nil) != SQLITE_OK {
            throw DataAccessError.Delete_Error
        }
        
        //executing the query to delete row
        let r = sqlite3_step(self.deleteEntryStmt)
        if r != SQLITE_DONE {
            throw DataAccessError.Delete_Error
        }
    }
   
    static func find(id: Int) throws -> T? {
        // ensure statements are created on first usage if nil
        guard self.prepareReadEntryStmt() == SQLITE_OK else { throw SqliteError(message: "Error in prepareReadEntryStmt") }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.readEntryStmt)
        }
        
        //Inserting employeeID in readEntryStmt prepared statement
        if sqlite3_bind_text(self.readEntryStmt, 1, String(id), -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(readEntryStmt)")
            throw SqliteError(message: "Error in inserting value in prepareReadEntryStmt")
        }
        
        //executing the query to read value
        if sqlite3_step(readEntryStmt) != SQLITE_ROW {
            logDbErr("sqlite3_step COUNT* readEntryStmt:")
            throw SqliteError(message: "Error in executing read statement")
        }
        
        return T(username: String(cString: sqlite3_column_text(readEntryStmt, 1)),
                      password: String(cString: sqlite3_column_text(readEntryStmt, 2)))
    }
      
    
    
    // INSERT/CREATE operation prepared statement
    static private func prepareInsertEntryStmt() -> Int32 {
        guard insertEntryStmt == nil else { return SQLITE_OK }
        let sql = "INSERT INTO "+TABLE_NAME+" (Name, EmployeeID, Designation) VALUES (?,?,?)"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare insertEntryStmt")
        }
        return r
    }
    
    // READ operation prepared statement
    static func prepareReadEntryStmt() -> Int32 {
        guard readEntryStmt == nil else { return SQLITE_OK }
        let sql = "SELECT * FROM "+TABLE_NAME+"  WHERE id = ? LIMIT 1"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare readEntryStmt")
        }
        return r
    }
    
    // READ operation prepared statement
    static func prepareReadAllEntryStmt() -> Int32 {
        guard readAllEntryStmt == nil else { return SQLITE_OK }
        let sql = "SELECT * FROM "+TABLE_NAME
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &readAllEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare readAllEntryStmt")
        }
        return r
    }
    
    // UPDATE operation prepared statement
    static func prepareUpdateEntryStmt() -> Int32 {
        guard updateEntryStmt == nil else { return SQLITE_OK }
        let sql = "UPDATE "+TABLE_NAME+"  SET username = ?, password = ? WHERE id = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &updateEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare updateEntryStmt")
        }
        return r
    }
    
    // DELETE operation prepared statement
    static func prepareDeleteEntryStmt() -> Int32 {
        guard deleteEntryStmt == nil else { return SQLITE_OK }
        let sql = "DELETE FROM "+TABLE_NAME+"  WHERE id = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare deleteEntryStmt")
        }
        return r
    }
    
    static func logDbErr(_ msg: String) {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        os_log("ERROR %s : %s", log: oslog, type: .error, msg, errmsg)
    }
}
