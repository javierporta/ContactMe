//
//  ConnectionDetailViewController.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 23/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit

class ConnectionDetailViewController: UIViewController {

    
    //MARK: Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studiesLabel: UILabel!
    
    @IBOutlet weak var currentStatusLabel: UILabel!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var universityLabel: UILabel!
    
    @IBOutlet weak var studyingLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    
    @IBOutlet weak var interestsListLabel: UILabel!
    
    @IBOutlet weak var mondayFreeSchedule: UILabel!
    
    @IBOutlet weak var tuesdayFreeSchedule: UILabel!
    @IBOutlet weak var wednesdayFreeSchedule: UILabel!
    
    @IBOutlet weak var thursdayFreeSchedule: UILabel!
    
    @IBOutlet weak var fridayFreeSchedule: UILabel!
    
    @IBOutlet weak var saturdayFreeSchedule: UILabel!
    
    @IBOutlet weak var sundayFreeSchedule: UILabel!
    @IBOutlet weak var meetingLocation: UILabel!
    
    @IBOutlet weak var meetingDateTime: UILabel!
    
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
