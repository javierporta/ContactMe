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
        self.hideKeyboardWhenTappedAround()
        
        //ToDo: quitar, esto e spara ver todos los usuarios registrados
        UserService.getAllUsers()
        
    }
    
    //    MARK: Actions
    
    @IBAction func touchUpLogIn(_ sender: Any) {
        
        if let userlogin = UserService.getRegisterUserByUserName(username: emailTextField.text!) {
            
            if ( emailTextField.text == userlogin.username && passwordTextField.text == userlogin.password) {
                
                _ = UserService.saveUserSession(user: userlogin)
                
                navigateToMainTab()
                
            } else {
                showWrongCredentialsAlert()
            }
            
        }else
        {
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
    
    func showNotExistUserRegisterAlert() {
        let alert = UIAlertController(title: "Alert", message: "There is not registers users", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:   #selector(UIInputViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

