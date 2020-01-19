//
//  DashboardView.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 14/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit
import KeychainAccess

private let reuseIdentifier = "Cell"

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    //    MARK: Outlets
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var cameraQrScannerButton: RoundButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var connectionsCountLabel: UILabel!
    @IBOutlet weak var lastConnectionLabel: UILabel!
    
    var isProfileShareable=false;
    var currentUserProfile = Profile()
    
    
    @IBOutlet weak var imgCountContact: UIImageView!
    
    private let reuseIdentifier = "ContactCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 25.0,
            left: 20.0,
            bottom: 25.0,
            right: 20.0)
    private var contactList = [Profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getIsProfileShareable
               
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.contactList.count
    }
    
        //important: code to recalculate width on each rotation
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        Code to force resizing on each rotation
            collectionView.collectionViewLayout.invalidateLayout()
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ContactCollectionViewCell
        
        cell.userImageView.setUIImageView(imgUrl: self.contactList[indexPath.item].avatar)
        cell.userImageView.makeRounded()
        cell.nameLabel.text = self.contactList[indexPath.item].fullName()
        cell.phoneLabel.text = self.contactList[indexPath.item].phone
        cell.emailLabel.text = self.contactList[indexPath.item].email
        
        return cell
    }
       
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let itemWidth = (view.frame.width - paddingSpace) / itemsPerRow
        print(view.frame.width)
        print(paddingSpace)
        print(itemWidth)
        return CGSize(width: itemWidth, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    fileprivate func getIsProfileShareable() -> Bool{
        //Ask if it profile is shareable
              print("getIsProfileShareable")
        if((self.currentUserProfile.name ?? "").isEmpty || (self.currentUserProfile.lastName ?? "").isEmpty ){
            self.qrButton.backgroundColor = UIColor.darkGray
            return false
        }else{
            self.qrButton.backgroundColor = UIColor(named: "Primary")
            return true
        }
    }
    
    private func loadData(){
        if let currentUser = UserService.getCurrentUserSession() {
            if let currentUserProfile = try? ProfileDataHelper.find(idobj: currentUser.profileId!){
                self.currentUserProfile = currentUserProfile
                
                self.imgCountContact.makeRounded()
                self.userImageView.makeRounded()
                self.userImageView.setUIImageView(imgUrl: self.currentUserProfile.avatar)
                self.usernameLabel.text = self.currentUserProfile.fullName()
                
                self.contactList = try! ProfileDataHelper.findConectionsByProfileid(idobj: currentUser.profileId!)
                self.contactList = self.contactList.filter{ $0.visit > 0 }
                self.contactList.sort{ $0.visit > $1.visit }
                self.contactList = Array(self.contactList.prefix(4))
                
                connectionsCountLabel.text = String(self.contactList.count)
                if let lastConnetion = self.contactList.min(by: { a, b in a.getConnectionDate() < b.getConnectionDate()}) {
                    
                    if #available(iOS 13.0, *), lastConnetion.connectionDateTime != nil {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let connectionDateTime = dateFormatter.date(from: lastConnetion.connectionDateTime ?? "")!
                        let formatter = RelativeDateTimeFormatter()
                        formatter.unitsStyle = .full
                        let relativeDate = formatter.localizedString(for: connectionDateTime, relativeTo: Date())
                        lastConnectionLabel.text = relativeDate
                    } else {
                        // Fallback on earlier versions
                        lastConnectionLabel.text = lastConnetion.connectionDateTime
                    }
                    
                }
                
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        qrButton.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        cameraQrScannerButton.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        isProfileShareable=getIsProfileShareable()
        
        collectionView.reloadData()
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut],
                       animations: {[weak self] in
                        self?.qrButton.transform = CGAffineTransform.identity
            }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut],
                       animations: {[weak self] in
                        self?.cameraQrScannerButton.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        guard
            segue.identifier == "contactDetail",
            let indexPath = self.collectionView.indexPathsForSelectedItems?.first,
            let detailViewController = segue.destination as? ConnectionDetailViewController
        else {
              return
          }
          
        var contact = contactList[indexPath.row]
       
        detailViewController.profileId = contact.id
       
     }
     
    
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
