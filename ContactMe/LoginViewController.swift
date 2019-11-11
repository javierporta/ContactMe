//
//  ViewController.swift
//  ContactMe
//
//  Created by formando on 07/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {
    
    //    MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //    MARK: Actions
    @IBAction func touchUpLogIn(_ sender: Any) {
        if ( emailTextField.text == "a" && passwordTextField.text == "a") {
            
            let keychain = Keychain(service: "com.ipleiria.contactme")
            do {
                try keychain.set("a", key: "userPassword")
            }
            catch let error {
                print(error)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "homeViewController")
            self.present(vc, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Alert", message: "Username or password are not correct", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}

