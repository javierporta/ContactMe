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
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*self.addValidatorEmail(toControl: self.emailTextField,
        errorPlaceholder: self.emailErrorLabel,
            errorMessage: "Email is invalid")*/
        
        self.addValidatorMinLength(toControl: self.emailTextField,
        errorPlaceholder: self.emailErrorLabel,
            errorMessage: "Enter at least %d characters",
               minLength: 8)
    }
    
//    MARK:Actions
    @IBAction func signUpButton(_ sender: Any) {
        print("Sign Up pressed")
    }
        
    @IBAction func emailEditingChanged(_ sender: Any) {
        if self.validate(){
            print("esta bien")
        }else{
             print("esta mal")
        }
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
