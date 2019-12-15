//
//  MyProfileViewController.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 21/11/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit
import GooglePlaces

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var placesClient: GMSPlacesClient!
    var autocompleteSender="" // ToDo Serach a better way to do that
    
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
    
    
    @IBOutlet weak var mondayStartTimeTextField: UITextField!
    @IBOutlet weak var mondayEndTimeTextField: UITextField!
    
    @IBOutlet weak var tuesdayStartTimeTextField: UITextField!
    @IBOutlet weak var tuesdayEndTimeTextField: UITextField!
    
    @IBOutlet weak var wednesdayStartTimeTextField: UITextField!
    @IBOutlet weak var wednesdayEndTimeTextField: UITextField!
    
    @IBOutlet weak var thursdayStartTimeTextField: UITextField!
    @IBOutlet weak var thursdayEndTimeTextField: UITextField!
    
    @IBOutlet weak var fridayStartTimeTextField: UITextField!
    @IBOutlet weak var fridayEndTimeTextField: UITextField!
    
    @IBOutlet weak var saturdayStartTimeTextField: UITextField!
    @IBOutlet weak var saturdayEndTimeTextField: UITextField!
    
    @IBOutlet weak var sundayStartTimeTextField: UITextField!
    @IBOutlet weak var sundayEndTimeTextField: UITextField!
    
    @IBOutlet weak var placeFreeTimeTextField: UITextField!
    
    let interests: Array<String> = ["Beer","Food","Sports","Programming","Music", "Technology","Football","Padel","Kayaking","Traveling","Crafts","Painting","Philosophy","Economy","Politics","Netflix","Ted Talks","Recycling", "Healthcare","Design","Runnning"].sorted()
    
    //Uidate picker
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var myProfile = Profile()
    
    fileprivate func prepareInterestTokenControl() {
        interestsKsToken.delegate = self as KSTokenViewDelegate
        interestsKsToken.promptText = "Top 5 interests: "
        interestsKsToken.placeholder = "Type to search"
        interestsKsToken.descriptionText = "Interests"
        interestsKsToken.maxTokenLimit = 5 /// default is -1 for unlimited number of tokens
        interestsKsToken.style = .squared
        interestsKsToken.minimumCharactersToSearch = 0 /// Show all results without without typing anything
        interestsKsToken.searchResultHeight = self.view.frame.size.height - 400 //todo: get real value of header
        interestsKsToken.returnKeyType(type: .done)
        
        /// An array of string values. Default values are "." and ",". Token is created with typed text, when user press any of the character mentioned in this Array
        interestsKsToken.tokenizingCharacters = [","]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveMyProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPersonalTab()
        
        prepareInterestTokenControl()
        
        prepareDofDatePicker()
        
        prepareTimePickers(senderTextField: mondayStartTimeTextField, doneFunction: "mondayStartDoneTimePicker")
        prepareTimePickers(senderTextField: mondayEndTimeTextField, doneFunction: "mondayEndDoneTimePicker")
        prepareTimePickers(senderTextField: tuesdayStartTimeTextField, doneFunction: "tuesdayStartDoneTimePicker")
        prepareTimePickers(senderTextField: tuesdayEndTimeTextField, doneFunction: "tuesdayEndDoneTimePicker")
        prepareTimePickers(senderTextField: wednesdayStartTimeTextField, doneFunction: "wednesdayStartDoneTimePicker")
        prepareTimePickers(senderTextField: wednesdayEndTimeTextField, doneFunction: "wednesdayEndDoneTimePicker")
        prepareTimePickers(senderTextField: thursdayStartTimeTextField, doneFunction: "thursdayStartDoneTimePicker")
        prepareTimePickers(senderTextField: thursdayEndTimeTextField, doneFunction: "thursdayEndDoneTimePicker")
        prepareTimePickers(senderTextField: fridayStartTimeTextField, doneFunction: "fridayStartDoneTimePicker")
        prepareTimePickers(senderTextField: fridayEndTimeTextField, doneFunction: "fridayEndDoneTimePicker")
        prepareTimePickers(senderTextField: saturdayStartTimeTextField, doneFunction: "saturdayStartDoneTimePicker")
        prepareTimePickers(senderTextField: saturdayEndTimeTextField, doneFunction: "saturdayEndDoneTimePicker")
        prepareTimePickers(senderTextField: sundayStartTimeTextField, doneFunction: "sundayStartDoneTimePicker")
        prepareTimePickers(senderTextField: sundayEndTimeTextField, doneFunction: "sundayEndDoneTimePicker")
        
        placesClient = GMSPlacesClient.shared()
        
        
        if let currentUser = UserService.getCurrentUserSession() {
            if let currentUserProfile = try? ProfileDataHelper.find(idobj: currentUser.profileId!){
                self.myProfile = currentUserProfile
                setMyProfileValues()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setMyProfileValues(){
        //Header
        fullNameLabel.text = myProfile.fullName()
        if (myProfile.avatar != nil){
            profileImage.image = myProfile.avatar?.toImage()
        }
        //        Personal
        nameTextField.text = myProfile.name
        surnameTextField.text = myProfile.lastName
        
        phoneTextField.text = myProfile.phone
        
        if(myProfile.gender == "F"){
            genderSegmentedControl.selectedSegmentIndex = Gender.female.rawValue
        }
        else {
            genderSegmentedControl.selectedSegmentIndex = Gender.male.rawValue
        }
        setGenderSegmentedControlColor()
        
        dateOfBirthTextField.text = myProfile.dateOfBirth
        
        //        Career
        //ToDo
        //universityTextField.text = myProfile.
        jobTextField.text = myProfile.job
        careerTextField.text = myProfile.carieer
        
        
        //        Interests
        
        
        
        if myProfile.insterestArray != nil && myProfile.insterestArray!.count > 0 {
            for interest in myProfile.insterestArray!  {
                let token: KSToken = KSToken(title: interest)
                interestsKsToken.addToken(token)
            }
            
        }
        
        
        //        Free Time
        //ToDo
        //        placeFreeTimeTextField.text = myProfile.
        
        mondayStartTimeTextField.text = myProfile.mondayFreeStartTime
        mondayEndTimeTextField.text = myProfile.mondayFreeEndTime
        
        tuesdayStartTimeTextField.text = myProfile.tuesdayFreeStartTime
        tuesdayEndTimeTextField.text = myProfile.tuesdayFreeEndTime
        
        wednesdayStartTimeTextField.text = myProfile.wednesdayFreeStartTime
        wednesdayEndTimeTextField.text = myProfile.wednesdayFreeEndTime
        
        thursdayStartTimeTextField.text = myProfile.thursdayFreeStartTime
        thursdayEndTimeTextField.text = myProfile.thursdayFreeEndTime
        
        fridayStartTimeTextField.text = myProfile.fridayFreeStartTime
        fridayEndTimeTextField.text = myProfile.fridayFreeEndTime
        
        saturdayStartTimeTextField.text = myProfile.saturdayFreeStartTime
        saturdayEndTimeTextField.text = myProfile.saturdayFreeEndTime
        
        sundayStartTimeTextField.text = myProfile.sundayFreeStartTime
        sundayEndTimeTextField.text = myProfile.sundayFreeEndTime
        
    }
    
    
    func saveMyProfile() {
        
        //Header
        
        
        myProfile.avatar = profileImage.image?.toString()
        
        //        Personal
        myProfile.name = nameTextField.text
        myProfile.lastName = surnameTextField.text
        
        myProfile.phone = phoneTextField.text
        
        myProfile.gender = genderSegmentedControl.selectedSegmentIndex == Gender.male.rawValue ? "M" : "F"
        
        myProfile.dateOfBirth = dateOfBirthTextField.text
        
        //        Career
        
        universityTextField.text = myProfile.universityName
        myProfile.job = jobTextField.text
        myProfile.carieer = careerTextField.text
        
        
        //        Interests
        
        if let tokens = interestsKsToken.tokens(){
            myProfile.insterestArray = tokens.map({$0.title})
        }
        
        //        Free Time
        
        
        myProfile.freeTimePlaceName = placeFreeTimeTextField.text
        
        myProfile.mondayFreeStartTime = mondayStartTimeTextField.text
        myProfile.mondayFreeEndTime = mondayEndTimeTextField.text
        
        myProfile.tuesdayFreeStartTime = tuesdayStartTimeTextField.text
        myProfile.tuesdayFreeEndTime = tuesdayEndTimeTextField.text
        
        myProfile.wednesdayFreeStartTime = wednesdayStartTimeTextField.text
        myProfile.wednesdayFreeEndTime = wednesdayEndTimeTextField.text
        
        myProfile.thursdayFreeStartTime = thursdayStartTimeTextField.text
        myProfile.thursdayFreeEndTime = thursdayEndTimeTextField.text
        
        myProfile.fridayFreeStartTime = fridayStartTimeTextField.text
        myProfile.fridayFreeEndTime = fridayEndTimeTextField.text
        
        myProfile.saturdayFreeStartTime = saturdayStartTimeTextField.text
        myProfile.saturdayFreeEndTime = saturdayEndTimeTextField.text
        
        myProfile.sundayFreeStartTime = sundayStartTimeTextField.text
        myProfile.sundayFreeEndTime = sundayEndTimeTextField.text
        
        DispatchQueue.global(qos: .utility).async {
            let _ = try? ProfileDataHelper.update(item: self.myProfile)
            
            print("profile saved")
        }
      
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
    
    func prepareTimePickers(senderTextField: UITextField, doneFunction: String){
        //Formate Date
        timePicker.datePickerMode = .time
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: Selector((doneFunction)));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        senderTextField.inputAccessoryView = toolbar
        senderTextField.inputView = timePicker
        
    }
    
    @objc func mondayStartDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        mondayStartTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    @objc func mondayEndDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        mondayEndTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func tuesdayStartDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        tuesdayStartTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    @objc func tuesdayEndDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        tuesdayEndTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func wednesdayStartDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        wednesdayStartTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    @objc func wednesdayEndDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        wednesdayEndTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func thursdayStartDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        thursdayStartTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    @objc func thursdayEndDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        thursdayEndTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func fridayStartDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        fridayStartTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    @objc func fridayEndDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        fridayEndTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func saturdayStartDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        saturdayStartTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    @objc func saturdayEndDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        saturdayEndTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func sundayStartDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        sundayStartTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    @objc func sundayEndDoneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        sundayEndTimeTextField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    
    
    @objc func cancelTimePicker(){
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
    
    @IBAction func universityTapped(_ sender: UITextField) {
        universityTextField.resignFirstResponder()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue) |
            UInt(GMSPlaceField.addressComponents.rawValue)
            )!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        autocompleteSender="university"
        
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func placeFreeTimeTapped(_ sender: UITextField) {
        
        placeFreeTimeTextField.resignFirstResponder()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue) |
            UInt(GMSPlaceField.addressComponents.rawValue)
            )!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        autocompleteSender="freetime"
        
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
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
        
        saveMyProfile()
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

extension MyProfileViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Coordinate: \(String(describing: place.coordinate))")
        print("Address components: \(String(describing: place.addressComponents))")
        // Get the place name from 'GMSAutocompleteViewController'
        
        
        
        // Then display the name in textField
        //ToDO: How to work with both. Need to know the sender
        if(autocompleteSender=="university"){
            universityTextField.text = place.name
            
            myProfile.universityName = place.name
            myProfile.universityLatitude = place.coordinate.latitude
            myProfile.universityLongitude = place.coordinate.longitude
            
            
        }else if(autocompleteSender=="freetime"){
            placeFreeTimeTextField.text = place.name
            
            myProfile.freeTimePlaceName = place.name
            myProfile.freeTimeLatitude = place.coordinate.latitude
            myProfile.freeTimeLongitude = place.coordinate.longitude
        }
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
