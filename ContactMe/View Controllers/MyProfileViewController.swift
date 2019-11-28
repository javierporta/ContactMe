//
//  MyProfileViewController.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 21/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet{
            profileImage.makeRounded()
        }
    }
    @IBOutlet weak var interestsKsToken: KSTokenView!
    
    
    @IBOutlet weak var personalStackView: UIStackView!
    @IBOutlet weak var careerStackView: UIStackView!
    @IBOutlet weak var interestsStackView: UIStackView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet {
            phoneTextField.tintColor = UIColor.lightGray
            phoneTextField.setIcon(#imageLiteral(resourceName: "icons-phone"))
        }
    }
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!{
        didSet {
            setGenderSegmentedControlColor()
        }
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField! {
        didSet {
            jobTextField.tintColor = UIColor.lightGray
            jobTextField.setIcon(#imageLiteral(resourceName: "icon-job"))
        }
    }
    @IBOutlet weak var careerTextField: UITextField!
        {
        didSet {
            careerTextField.tintColor = UIColor.lightGray
            careerTextField.setIcon(#imageLiteral(resourceName: "icon-studying"))
        }
    }
    
    @IBOutlet weak var universityTextField: UITextField! {
        didSet {
            universityTextField.tintColor = UIColor.lightGray
            universityTextField.setIcon(#imageLiteral(resourceName: "icon-uni"))
        }
    }
    @IBOutlet weak var interestsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPersonalTab()
//        TODO:  Here we must get all user data from db and fill the controls
        
        
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
    
    //    MARK: Actions
   
    
    @IBAction func tabsSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case MyProfileTabs.personal.rawValue:
            showPersonalTab()
            
           break
        case MyProfileTabs.career.rawValue:
            showCareerTab()
            break
        case MyProfileTabs.interests.rawValue:
            showInterestsTabs()
           break
        case MyProfileTabs.freeTime.rawValue:
            break
        default:
            break
        }
    }
    @IBAction func genderSegmentedControlValueChanged(_ sender: Any) {
        setGenderSegmentedControlColor()
        
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user
        //        pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an
        //        image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func nameTextFieldEditingDidEnd(_ sender: Any) {
        setFullName()
    }
    
    @IBAction func surnameTextFieldEditingDidEnd(_ sender: Any) {
        setFullName()
    }
    
    func setFullName(){
        let fullName = "\(nameTextField.text ?? "") \(surnameTextField.text ?? "")"
        fullNameLabel.text = fullName
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :
        Any]) {
        
        // The info dictionary may contain multiple representations of the   image. You want to use the original.
        guard let selectedImage =
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        profileImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    

    private func setGenderSegmentedControlColor(){
        switch genderSegmentedControl.selectedSegmentIndex {
            
        case Gender.male.rawValue:   genderSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: UIControl.State.selected)
            
        case Gender.female.rawValue:
            genderSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink], for: UIControl.State.selected)
        default:
            break
        }
        genderSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: UIControl.State.normal)
    }
    
     fileprivate func showPersonalTab() {
           personalStackView.isHidden=false
           careerStackView.isHidden=true
           interestsStackView.isHidden=true
       }
       
       fileprivate func showCareerTab() {
           personalStackView.isHidden=true
           careerStackView.isHidden=false
           interestsStackView.isHidden=true
       }
       
       fileprivate func showInterestsTabs() {
           personalStackView.isHidden=true
           careerStackView.isHidden=true
           interestsStackView.isHidden=false
       }
    
    
    
    
}
