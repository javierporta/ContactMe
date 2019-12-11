//
//  String.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 11/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
