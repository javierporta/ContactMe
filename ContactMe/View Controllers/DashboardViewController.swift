//
//  DashboardView.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 14/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit
import KeychainAccess

class DashboardViewController: UIViewController {

    
//    MARK: Actions
    
   
    
    @IBAction func touchUpLogoutButton(_ sender: Any) {
        removeKeychainUserKey()
        navigateToLogin()
        
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
    
    func removeKeychainUserKey() {
           //        Remove keychain key
           let keychain = Keychain(service: Constants.KEYCHAIN_SERVICE)
           do {
               try keychain.remove(Constants.USER_PASSWORD_KEY)
           }
           catch let error {
               print(error)
                showErrorAlert()
           }
       }
    
    func navigateToLogin(){
        let storyboard = UIStoryboard(name: Constants.Identifiers.STORYBOARD, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.Identifiers.LOGIN)
        self.present(viewController, animated: true, completion: nil)
    }
    
    func showErrorAlert(){
//        ToDo: this could be a generic alert for all errors
        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
