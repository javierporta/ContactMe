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
    
    //    MARK: Outlets
    @IBOutlet weak var qrButton: UIButton!
    
    @IBOutlet weak var cameraQrScannerButton: RoundButton!
    
    var isProfileShareable=false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    fileprivate func getIsProfileShareable() -> Bool{
        //Ask if it profile is shareable
        if let currentUser = UserService.getCurrentUserSession() {
            if let currentUserProfile = try? ProfileDataHelper.find(idobj: currentUser.profileId!){
                let myProfile = currentUserProfile
                
                if((myProfile.name ?? "").isEmpty || (myProfile.lastName ?? "").isEmpty ){
                    self.qrButton.backgroundColor = UIColor.darkGray
                    return false
                }else{
                    self.qrButton.backgroundColor = UIColor(named: "Primary")
                    return true
                }
                
            }
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        qrButton.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        cameraQrScannerButton.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        isProfileShareable=getIsProfileShareable()
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut],
                       animations: {[weak self] in
                        self?.qrButton.transform = CGAffineTransform.identity
            }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut],
                       animations: {[weak self] in
                        self?.cameraQrScannerButton.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //    MARK: Actions
    @IBAction func touchUpLogoutButton(_ sender: Any) {
        removeKeychainUserKey()
        navigateToLogin()
        
    }
    
    func removeKeychainUserKey() {
        
        _ = UserService.deleteUserSession()
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
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpQRShowView(_ sender: Any) {
        if(isProfileShareable){
            //navigate
        }else{
            // create the alert
            let alert = UIAlertController(title: "You have to work a bit more on your profile", message: "Please, complete at least your name and surname before sharing your card", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == Constants.Identifiers.QR_VIEW_SEGUE && !isProfileShareable){
            return false
        }
        return true
    }

    
}
