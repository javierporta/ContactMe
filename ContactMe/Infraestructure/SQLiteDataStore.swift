//
//  SQLiteDataStore.swift
//  ContactMe
//
//  Created by formando on 21/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//
import Foundation
import os.log
import SQLite3

class SQLiteDataStore {
    
    static let sharedInstance = SQLiteDataStore()
   
    // Get the URL to db store file
    let dbURL: URL
    // The database pointer.
    var db: OpaquePointer?
    // Prepared statement https://www.sqlite.org/c3ref/stmt.html to insert an event into Table.
    // we use prepared statements for efficiency and safe guard against sql injection.
    var insertEntryStmt: OpaquePointer?
    var readEntryStmt: OpaquePointer?
    var updateEntryStmt: OpaquePointer?
    var deleteEntryStmt: OpaquePointer?
    
    let oslog = OSLog(subsystem: "codewithayush", category: "sqliteintegration")
    
    private init() {
        do {
            do {
                dbURL = try FileManager.default
                    .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("ContactMe.db")
                os_log("URL: %s", dbURL.absoluteString)
            } catch {
                //TODO: Just logging the error and returning empty path URL here. Handle the error gracefully after logging
                os_log("Some error occurred. Returning empty path.")
                dbURL = URL(fileURLWithPath: "")
                return
            }
            
            try openDB()
            try createTables()
            
        } catch {
            //TODO: Handle the error gracefully after logging
            os_log("Some error occurred. Returning.")
            return
        }
    }
    
    // Command: sqlite3_open(dbURL.path, &db)
    // Open the DB at the given path. If file does not exists, it will create one for you
    func openDB() throws {
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK { // error mostly because of corrupt database
            os_log("error opening database at %s", log: oslog, type: .error, dbURL.absoluteString)
//            deleteDB(dbURL: dbURL)
            throw SqliteError(message: "error opening database \(dbURL.absoluteString)")
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

