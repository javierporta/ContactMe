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

        // Do any additional setup after loading the view.
        
        let profile1 = Profile()
        profile1.name = "contecto 1"
        profile1.lastName = "apellido"
        profile1.carieer = "Medicina"
        profile1.insterest = "sport"
                
        let profile2 = Profile()
        profile2.name = "contecto 2"
        profile2.lastName = "apellido"
        profile2.carieer = "Medicina"
        profile2.insterest = "sport"
        
        self.contactList += [profile1, profile2]
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

}
