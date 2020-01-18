//
//  QRShowViewController.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 01/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit

class QRShowViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    
    @IBOutlet weak var careerLabel: UILabel!
    
    @IBOutlet weak var specialityJobLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet{
            avatarImageView.makeRounded()
        }
    }
    
    var currentUserProfile = Profile()
    var currentUser = User()
    
    @IBOutlet weak var dataStackView: UIStackView!
    
    fileprivate func getMyProfileData() {
        //        1 Get current user id
        //        2 Get profile with that user id
        
        if let currentUser = UserService.getCurrentUserSession() {
            self.currentUser = currentUser
            if let currentUserProfile = try? ProfileDataHelper.find(idobj: currentUser.profileId!){
                self.currentUserProfile = currentUserProfile
                
                setMyProfileControls()
            }
        }
        
        
    }
    
    fileprivate func setMyProfileControls(){
        avatarImageView.image = currentUserProfile.avatar?.toImage()
        fullNameLabel.text = currentUserProfile.fullName()
        universityLabel.text=currentUserProfile.universityName
        careerLabel.text = currentUserProfile.carieer
        specialityJobLabel.text=currentUserProfile.job
        emailLabel.text = currentUserProfile.email
        phoneLabel.text = currentUserProfile.phone
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMyProfileData()
        
        addQrCodeToImage()
        hideOrShowItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //duplicated to update values if needed
        getMyProfileData()
        
        addQrCodeToImage()
        hideOrShowItems()
    }
    
    
    func addQrCodeToImageFancy(){
        //IMPORTANT: WITH THIS CODE READERS ARE NOT DETECTING QR CODE
        // Get define string to encode
        let myString = "https://pennlabs.org"
        // Get data from the string
        let data = myString.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("Q", forKey: "inputCorrectionLevel")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return }
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        // Invert the colors
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return }
        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return }
        // Replace the black with transparency
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return }
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return }
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        
        qrImageView.image = processedImage
    }
    
    func addQrCodeToImage(){
        
        
        // Encode
        let jsonEncoder = JSONEncoder()
        do {
            
            let jsonData = try jsonEncoder.encode(currentUserProfile)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            
            // Get data from the string
            let data = json?.data(using: String.Encoding.ascii)
            // Get a QR CIFilter
            guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
            // Input the data
            qrFilter.setValue(data, forKey: "inputMessage")
            qrFilter.setValue("Q", forKey: "inputCorrectionLevel")
            // Get the output image
            guard let qrImage = qrFilter.outputImage else { return }
            // Scale the image
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledQrImage = qrImage.transformed(by: transform)
            // Do some processing to get the UIImage
            let context = CIContext()
            guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
            let processedImage = UIImage(cgImage: cgImage)
            
            qrImageView.image = processedImage
            //all fine with jsonData here
        } catch {
            //handle error
            print(error)
        }
        
        
        
        
    }
    
    func showAllItems(){
        dataStackView.isHidden = false
        avatarImageView.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    func hideSomeItems(){
        dataStackView.isHidden = true
        avatarImageView.isHidden = true
        
        self.view.layoutIfNeeded()
    }
    
    func hideOrShowItems(){
        print("current screen height size \(UIScreen.main.bounds.height)")
        if UIDevice.current.orientation.isLandscape || UIScreen.main.bounds.height < 700 {
            print("Landscape")
            hideSomeItems()
        } else {
            print("Portrait")
            showAllItems()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        hideOrShowItems()
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
