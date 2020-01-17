//
//  SearchItem.swift
//  ContactMe
//
//  Created by formando on 17/01/2020.
//  Copyright © 2020 IPL-Master. All rights reserved.
//

import Foundation

class SearchItem {
    var attributedJonName: NSMutableAttributedString?
    var allAttributedName : NSMutableAttributedString?
    
    var jobName: String

    public init(jobName: String) {
        self.jobName = jobName
    }
    
    public func getFormatedText() -> NSMutableAttributedString{
        allAttributedName = NSMutableAttributedString()
        allAttributedName!.append(attributedJonName!)
        
        return allAttributedName!
    }
    
    public func getStringText() -> String{
        return "\(jobName)"
    }

}
