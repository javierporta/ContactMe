//
//  UIViewController.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 18/01/2020.
//  Copyright © 2020 IPL-Master. All rights reserved.
//

import UIKit

extension UIViewController {
   func hideKeyboardWhenTappedAround() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
   }

   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
}


