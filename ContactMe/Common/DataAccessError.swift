//
//  DataAccessError.swift
//  ContactMe
//
//  Created by formando on 21/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

enum DataAccessError: Error {
    
    case Datastore_Connection_Error
    case Insert_Error
    case Update_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
    
}