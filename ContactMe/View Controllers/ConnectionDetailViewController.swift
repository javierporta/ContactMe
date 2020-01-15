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
    @IBOutlet weak var genderUIImage: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
  
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var currentStatusLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberTextView: UITextView!
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
    
    var profileId: Int64 = 0
    
    var connectionProfile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ToDo: Pass Id as parameter
        getConnectionProfile(profileId: self.profileId)
        setProfileOutlets()
        
        
    }
    
    func getConnectionProfile(profileId: Int64) {
        if let currentProfile = try? ProfileDataHelper.find(idobj: profileId){
            connectionProfile = currentProfile
        }
    }
    
    func setProfileOutlets(){
        avatarImageView.image = connectionProfile.avatar?.toImage()
        
        if (connectionProfile.gender == "F"){
            genderUIImage.image = UIImage(named: "icon-gender-female")
        }else{
            genderUIImage.image = UIImage(named: "icon-gender-male")
        }
        
        nameLabel.text = connectionProfile.name
        
        emailTextView.text = connectionProfile.email
        emailTextView.centerVertically()
        
        if(!(connectionProfile.dateOfBirth ?? "").isEmpty){
            ageLabel.text = calculateAge()
        }
        fullnameLabel.text = connectionProfile.fullName()
        
        phoneNumberTextView.text = connectionProfile.phone
        phoneNumberTextView.centerVertically()
        
        universityLabel.text = connectionProfile.universityName
        studyingLabel.text = connectionProfile.carieer
        jobLabel.text = connectionProfile.job
        interestsListLabel.text = connectionProfile.insterest
        
        currentStatusLabel.text = "Busy Now" //Or Free TODO
        if(currentStatusLabel.text == "Busy Now"){
             currentStatusLabel.textColor = UIColor.red

        }else{
            currentStatusLabel.textColor = UIColor.green

        }
        
        if(!(connectionProfile.mondayFreeStartTime ?? "").isEmpty && !(connectionProfile.mondayFreeEndTime ?? "").isEmpty ){
            mondayFreeSchedule.text = "From: \(connectionProfile.mondayFreeStartTime ?? "") To: \(connectionProfile.mondayFreeEndTime ?? "")"
        }else{
            mondayFreeSchedule.text = "Busy"
        }
        
        if(!(connectionProfile.tuesdayFreeStartTime ?? "").isEmpty && !(connectionProfile.tuesdayFreeEndTime ?? "").isEmpty ){
            tuesdayFreeSchedule.text = "From: \(connectionProfile.tuesdayFreeStartTime ?? "") To: \(connectionProfile.tuesdayFreeEndTime ?? "")"
        }else{
            tuesdayFreeSchedule.text = "Busy"
        }
        
        if(!(connectionProfile.wednesdayFreeStartTime ?? "").isEmpty && !(connectionProfile.wednesdayFreeEndTime ?? "").isEmpty ){
            wednesdayFreeSchedule.text = "From: \(connectionProfile.wednesdayFreeStartTime ?? "") To: \(connectionProfile.wednesdayFreeEndTime ?? "")"
        }else{
            wednesdayFreeSchedule.text = "Busy"
        }
        
        if(!(connectionProfile.thursdayFreeStartTime ?? "").isEmpty && !(connectionProfile.thursdayFreeEndTime ?? "").isEmpty ){
            thursdayFreeSchedule.text = "From: \(connectionProfile.thursdayFreeStartTime ?? "") To: \(connectionProfile.thursdayFreeEndTime ?? "")"
        }else{
            thursdayFreeSchedule.text = "Busy"
        }
        
        if(!(connectionProfile.fridayFreeStartTime ?? "").isEmpty && !(connectionProfile.fridayFreeEndTime ?? "").isEmpty ){
            fridayFreeSchedule.text = "From: \(connectionProfile.fridayFreeStartTime ?? "") To: \(connectionProfile.fridayFreeEndTime ?? "")"
        }else{
            fridayFreeSchedule.text = "Busy"
        }
        
        if(!(connectionProfile.saturdayFreeStartTime ?? "").isEmpty && !(connectionProfile.saturdayFreeEndTime ?? "").isEmpty ){
            saturdayFreeSchedule.text = "From: \(connectionProfile.saturdayFreeStartTime ?? "") To: \(connectionProfile.saturdayFreeEndTime ?? "")"
        }else{
            saturdayFreeSchedule.text = "Busy"
        }
        
        if(!(connectionProfile.sundayFreeStartTime ?? "").isEmpty && !(connectionProfile.sundayFreeEndTime ?? "").isEmpty ){
            sundayFreeSchedule.text = "From: \(connectionProfile.sundayFreeStartTime ?? "") To: \(connectionProfile.sundayFreeEndTime ?? "")"
        }else{
            sundayFreeSchedule.text = "Busy"
        }
        
        meetingLocation.text = connectionProfile.connectionLocationName
        
        // ask for the full relative date
        if #available(iOS 13.0, *), connectionProfile.connectionDateTime != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let connectionDateTime = dateFormatter.date(from: connectionProfile.connectionDateTime ?? "")!
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            let relativeDate = formatter.localizedString(for: connectionDateTime, relativeTo: Date())
            meetingDateTime.text = relativeDate
        } else {
            // Fallback on earlier versions
            meetingDateTime.text = connectionProfile.connectionDateTime
        }
            
    }
    
    private func calculateAge() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateOfBirth = dateFormatter.date(from: connectionProfile.dateOfBirth ?? "")!
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)

        let age = ageComponents.year
        return "\(String(age ?? 0)) years old"
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
