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
        
        do {
            
            try UserDataHelper.createTable()
            
            let entity = User()
            entity.username =  "rhdelgado"
            entity.password = "1234"
            
            let userId = try UserDataHelper.insert(item: entity)
            print(userId)
            	
        } catch _{
            print("caca")
        }
    }
    
    //    MARK: Actions
    
    @IBAction func touchUpLogIn(_ sender: Any) {
        
//        ToDo:  use sqlite here
        if ( emailTextField.text == "a" && passwordTextField.text == "a") {
            
            let keychain = Keychain(service: Constants.KEYCHAIN_SERVICE)
            do {
                // ToDo: Save user json instead of "a"
                try keychain.set("a", key: Constants.USER_PASSWORD_KEY)
            }
            catch let error {
                print(error)
            }
            
            navigateToMainTab()
            
        } else {
            
            showWrongCredentialsAlert()
            
        }
    }
    
    func navigateToMainTab(){
        let storyboard = UIStoryboard(name: Constants.Identifiers.STORYBOARD, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.Identifiers.MAIN_TAB)
        self.present(viewController, animated: true, completion: nil)
    }
    
    func showWrongCredentialsAlert() {
        let alert = UIAlertController(title: "Alert", message: "Username or password are not correct", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

