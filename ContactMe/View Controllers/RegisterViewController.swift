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
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
//    MARK:Actions
    @IBAction func signUpButton(_ sender: Any) {
        print("Sign Up pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
