//
//  Constants.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 14/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import Foundation

struct Constants {
    
    static let KEYCHAIN_SERVICE = "com.ipleiria.contactme"
    static let USER_PASSWORD_KEY = "userPassword"
    static let USER_DATA_KEY = "userDataJson"
    static let CURRENT_USER_KEY = "currentUserJson"
    static let JOBS_API_URL = "https://www.mocky.io/v2/5e25e6062f00006300ce2d6e"
    
    struct Identifiers {
        
        static let STORYBOARD = "Main"
        
        static let MAIN_TAB = "MainTabBarController"
        static let LOGIN = "LoginViewController"
        static let CONNECTIONS_LIST = "ContactListViewController"
        static let CONNECTION_DETAIL = "ConnectionDetailViewController"
        
        static let QR_VIEW_SEGUE = "goToQRCardSegue"
        static let SHOW_DETAILS_SEGUE = "showDetails"

        
    }
}
