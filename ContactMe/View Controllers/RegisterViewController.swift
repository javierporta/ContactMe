//
//  RegisterViewController.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 08/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit
import EGFormValidator

class RegisterViewController: ValidatorViewController {

//    MARK: Outlets


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
  
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addValidatorEmail(toControl: self.emailTextField,
        errorPlaceholder: self.emailErrorLabel,
            errorMessage: "Email is invalid")
        self.addValidatorMandatory(toControl: self.emailTextField,
        errorPlaceholder: self.emailErrorLabel,
            errorMessage: "This field is required")
        
        
        self.addValidatorMinLength(toControl: self.passwordTextField,                 errorPlaceholder: self.passwordErrorLabel,
            errorMessage: "Enter at least %d characters", minLength: 8)
        self.addValidatorMandatory(toControl: self.passwordTextField,                   errorPlaceholder: self.passwordErrorLabel,
            errorMessage: "This field is required")
        
        self.addValidatorMinLength(toControl: self.repeatPasswordTextField,                 errorPlaceholder: self.repeatPasswordErrorLabel,
            errorMessage: "Enter at least %d characters", minLength: 8)
        self.addValidatorMandatory(toControl: self.repeatPasswordTextField,                   errorPlaceholder: self.repeatPasswordErrorLabel,
            errorMessage: "This field is required")
    }
    
//    MARK:Actions
    @IBAction func signUpButton(_ sender: Any) {
        print("Sign Up pressed")
        
        if self.validate(){
            print("esta bien")
        }else{
             print("esta mal")
        }
    }
            
    @IBAction func emailEditingChanged(_ sender: Any) {
        _ = self.validate()
    }
    @IBAction func passwordEditingChanged(_ sender: Any) {
        _ = self.validate()
    }
    @IBAction func repeatPasswordEditingChanged(_ sender: Any) {
        _ = self.validate()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
