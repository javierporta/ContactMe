//
//  UIImage.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 11/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
