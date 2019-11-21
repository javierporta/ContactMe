//
//  DataHelperProtocol.swift
//  ContactMe
//
//  Created by formando on 21/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

protocol DataHelperProtocol {
    
    associatedtype T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func update(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func find(id: Int) throws -> T?
}

