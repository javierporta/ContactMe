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
        
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background4.png"))
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        
    }
    
    private func loadData(){
        if let currentUser = UserService.getCurrentUserSession() {
            self.contactList = try! ProfileDataHelper.findConectionsByProfileid(idobj: currentUser.profileId!)
        }
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
        cell.phoneLabel.text = contact.phone
        cell.emailLabel.text = contact.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let alert = UIAlertController(title: "Removing connection", message: "Are you sure you want to remove this connection?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                if(self.resultSearchController.isActive){
                    self.deleteConnection(connection: self.filteredContactList[indexPath.row])
                }else{
                    self.deleteConnection(connection: self.contactList[indexPath.row])
                }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteConnection(connection: Profile){
        try! ProfileDataHelper.delete(item: connection)
        loadData()
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
