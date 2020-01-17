//
//  ContactListViewController.swift
//  ContactMe
//
//  Created by royli on 20/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit

class ContactListViewController: UITableViewController, UISearchResultsUpdating {
       

    var contactList = [Profile]()
    var filteredContactList = [Profile]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = UserService.getCurrentUserSession() {
            self.contactList = try! ProfileDataHelper.findConectionsByProfileid(idobj: currentUser.profileId!)
        }
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContactList.removeAll(keepingCapacity: false)
        
        let value = searchController.searchBar.text!
        filteredContactList = contactList.filter{ ($0.name != nil && ($0.name?.lowercased().contains(value.lowercased()))!) || ($0.lastName != nil && ($0.lastName?.lowercased().contains(value.lowercased()))!)  || ($0.carieer != nil && ($0.carieer?.lowercased().contains(value.lowercased()))!) 
            || ($0.email != nil && ($0.email?.lowercased().contains(value.lowercased()))!)  || ($0.insterest != nil && ($0.insterest?.lowercased().contains(value.lowercased()))!) }
        
        self.tableView.reloadData()
    }
    

     
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(resultSearchController.isActive){
            return filteredContactList.count
        }
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
         var contact = contactList[indexPath.row]
        
         if(resultSearchController.isActive){
            contact = self.filteredContactList[indexPath.row]
         }
        
         cell.contactNameLabel.text = contact.fullName()
         cell.carieerLabel.text = contact.carieer
         cell.interestLabel.text = contact.insterest
         cell.avatarImage.setUIImageView(imgUrl: contact.avatar)
         
         return cell
     }
     
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        guard
            segue.identifier == Constants.Identifiers.SHOW_DETAILS_SEGUE,
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? ConnectionDetailViewController
            else {
              return
          }
          
        var contact = contactList[indexPath.row]
        if(resultSearchController.isActive){
            contact = filteredContactList[indexPath.row]
        }
        detailViewController.profileId = contact.id
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
