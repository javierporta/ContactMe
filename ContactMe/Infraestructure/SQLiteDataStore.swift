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
    
    func deleteDatabase(){
        var path = "ContactMeDb.sqlite"
        
        
        if let dirs: [NSString] =          NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [NSString] {
            
            let dir = dirs[0]
            print(dir)
            path = dir.appendingPathComponent("ContactMeDb.sqlite");
            
            let fm = FileManager.default
            do {
                let vFileURL = NSURL(fileURLWithPath: path)
                try fm.removeItem(at: vFileURL as URL)
                print("Database Deleted!")
            } catch {
                print("Error on Delete Database!!!")
            }
        }
        
    }
    
}
