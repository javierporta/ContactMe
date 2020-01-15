//
//  ContactListViewController.swift
//  ContactMe
//
//  Created by royli on 20/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit

class ContactListViewController: UITableViewController {

    var contactList = [Profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let currentUser = UserService.getCurrentUserSession() {
            self.contactList = try! ProfileDataHelper.findConectionsByProfileid(idobj: currentUser.profileId!)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return contactList.count
   }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ContactTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            cellIdentifier, for: indexPath) as? ContactTableViewCell else {
                fatalError("The dequeued cell is not an instance of ContactTableViewCell`.")
        }
        
        // Fetches the appropriate contact for the data source layout.
        let contact = contactList[indexPath.row]
        cell.contactNameLabel.text = contact.fullName()
        cell.carieerLabel.text = contact.carieer
        cell.interestLabel.text = contact.insterest
        
        return cell
    }
    
    override func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: Constants.Identifiers.STORYBOARD, bundle: nil)
        let profile = self.contactList[indexPath.row]
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.Identifiers.CONNECTION_DETAIL) as! ConnectionDetailViewController
        viewController.profileId = profile.connectionId!
        self.present(viewController, animated: true, completion: nil)
    }

}
