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
    
    @IBOutlet weak var freeTimeStackView: UIStackView!
    
    @IBOutlet weak var personalStackView: UIStackView!
    @IBOutlet weak var careerStackView: UIStackView!
    @IBOutlet weak var interestsStackView: UIStackView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
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
    
    //ToDo: Get from db
    let interests: Array<String> = ["Beer","Food","Sports","Programming","Music", "Technology"]
    
    //Uidate picker
    let datePicker = UIDatePicker()
    
    fileprivate func prepareInterestTokenControl() {
        interestsKsToken.delegate = self as? KSTokenViewDelegate
        interestsKsToken.promptText = "Top 5 interests: "
        interestsKsToken.placeholder = "Type to search"
        interestsKsToken.descriptionText = "Interests"
        interestsKsToken.maxTokenLimit = 5 /// default is -1 for unlimited number of tokens
        interestsKsToken.style = .squared
        interestsKsToken.minimumCharactersToSearch = 0 /// Show all results without without typing anything
        interestsKsToken.maximumHeight = 100.0
        interestsKsToken.returnKeyType(type: .done)
        
        /// An array of string values. Default values are "." and ",". Token is created with typed text, when user press any of the character mentioned in this Array
        interestsKsToken.tokenizingCharacters = [","]
        interestsKsToken.searchResultHeight = 100
        
        /// Show all results without without typing anything
        interestsKsToken.minimumCharactersToSearch = 0
        
        interestsKsToken.tokens()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPersonalTab()
        
        prepareInterestTokenControl()
        
        prepareDofDatePicker()
        
        
        
        //        TODO:  Here we must get all user data from db and fill the controls
        
        
        // Do any additional setup after loading the view.
    }
    
    func prepareDofDatePicker(){
        //set min and max dates: 13 to 100 years old
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = -13
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate=maxDate
        datePicker.minimumDate=minDate
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateOfBirthTextField.inputAccessoryView = toolbar
        dateOfBirthTextField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateOfBirthTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
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
            showInterestsTab()
            break
        case MyProfileTabs.freeTime.rawValue:
            showFreeTimeTab()
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
        freeTimeStackView.isHidden=true
    }
    
    fileprivate func showCareerTab() {
        personalStackView.isHidden=true
        careerStackView.isHidden=false
        interestsStackView.isHidden=true
        freeTimeStackView.isHidden=true
    }
    
    fileprivate func showInterestsTab() {
        personalStackView.isHidden=true
        careerStackView.isHidden=true
        interestsStackView.isHidden=false
        freeTimeStackView.isHidden=true
    }
    fileprivate func showFreeTimeTab() {
        personalStackView.isHidden=true
        careerStackView.isHidden=true
        interestsStackView.isHidden=true
        freeTimeStackView.isHidden=false
    }
    
    
    
    
}


//ToDo: Create another file for this extension
extension MyProfileViewController: KSTokenViewDelegate {
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        if (string.isEmpty){
            completion!(interests as Array<AnyObject>)
            return
        }
        
        var data: Array<String> = []
        for value: String in interests {
            if value.lowercased().range(of: string.lowercased()) != nil {
                data.append(value)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool {
        
        // Restrict adding token based on token text
        //            Allow only string in the intersts array list
        if !interests.contains(token.title) {
            return false
        }
        
        // If user input something, it can be checked
        //        print(tokenView.text)
        
        return true
    }
    //    IMPORTANT: To get all array of tokens!!!
    //    interestsKsToken.tokens()
}
