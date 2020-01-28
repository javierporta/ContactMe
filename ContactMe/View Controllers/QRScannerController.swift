//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class QRScannerController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    var currentProfileId : Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentProfileId = UserService.getCurrentUserSession()?.profileId ?? 0
        
        if(currentProfileId == 0){
            print("Error! ProfileId = 0")
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentLocation = locValue
        
        manager.stopUpdatingLocation()
    }
    
    func processQR(decodedURL: String) {
        if presentedViewController != nil {
            return
        }
        
        //        Try to decode
        do {
            // Decode data to object
            
            let jsonData = decodedURL.data(using: .utf8)!
            let jsonDecoder = JSONDecoder()
            let connectionProfile = try jsonDecoder.decode(Profile.self, from: jsonData)
            
            print("Name : \(connectionProfile.name ?? "")")
            
            //            generate success haptics
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            AudioServicesPlaySystemSound(SystemSoundID(4095))

            
            // create a sound ID, in this case its the tweet sound.
            //let systemSoundID: SystemSoundID = 1016
            // to play sound iOS13
            
            AudioServicesPlaySystemSound(SystemSoundID(1322))


            
            let alertPrompt = UIAlertController(title: "Adding a new connection", message: "You're about to add \(connectionProfile.name ?? "") as a contact", preferredStyle: .actionSheet)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
                self.captureSession.stopRunning()
                self.prepareForAddOrUpdateConnection(connectionProfile)
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(action) -> Void in
                
            })
            
            alertPrompt.addAction(confirmAction)
            alertPrompt.addAction(cancelAction)
            
            present(alertPrompt, animated: true, completion: nil)
            
        }
        catch {
            print(error)
            
            let alertPrompt = UIAlertController(title: "Oops!", message: "We cannot read this QR code. Looks like it's not a valid contact. Make sure you are scanning a ContactMe generated QR code.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil)
            alertPrompt.addAction(okAction)
            
            present(alertPrompt, animated: true, completion: nil)
        }
        
        
    }
    
    
    fileprivate func updateProfileConnection(_ scannedConnectionProfile: Profile, _
        localConnectionFound: ProfileDataHelper.T) {
        //Means user is already in list. Then update connection!
        
        // Get metadata
        // 1. Get datetime
        let currentDateTime = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTimeAsString = df.string(from: currentDateTime)
        
        // 2. Get gps location
        let connectionLocation = currentLocation
        
        
        // Set id to update the correct connection in local database
        scannedConnectionProfile.id = localConnectionFound.id
        scannedConnectionProfile.connectionDateTime = currentDateTimeAsString
        scannedConnectionProfile.connectionLocationLatitude = connectionLocation.latitude
        scannedConnectionProfile.connectionLocationLongitude = connectionLocation.longitude
        
        //do not update count of views when updating
        scannedConnectionProfile.visit = localConnectionFound.visit
        
        //Add reference (FK)
        scannedConnectionProfile.connectionId = currentProfileId
        
        // Geocoding current location
        lookUpCurrentLocation { (placeMark: CLPlacemark?) in
            //In case it fails we show coordinates
            print("Meeting location: " + (placeMark?.name ?? "Not found"))
            
            scannedConnectionProfile.connectionLocationName = placeMark?.name ?? "\(connectionLocation.latitude) \(connectionLocation.longitude)"
            
            DispatchQueue.global(qos: .utility).sync {
                _ = try? ProfileDataHelper.update(item: scannedConnectionProfile)
            }
            //Show  message
            let alertPrompt = UIAlertController(title: "Contact Updated", message: "You can access updated info of your connection now!", preferredStyle: .alert)
            
            let navigateAction = UIAlertAction(title: "Sure!", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
                self.captureSession.startRunning()
            })
            
            alertPrompt.addAction(navigateAction)
            
            self.present(alertPrompt, animated: true, completion: nil)
            
        }
        
        
    }
    
    fileprivate func addProfileConnection(_ scannedConnectionProfile: Profile) {
        // Get metadata
        // 1. Get datetime
        let currentDateTime = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTimeAsString = df.string(from: currentDateTime)
        
        // 2. Get gps location
        let connectionLocation = currentLocation
        
        //Add metadata
        scannedConnectionProfile.connectionDateTime = currentDateTimeAsString
        scannedConnectionProfile.connectionLocationLatitude = connectionLocation.latitude
        scannedConnectionProfile.connectionLocationLongitude = connectionLocation.longitude
        
        //Add reference (FK)
        scannedConnectionProfile.connectionId = currentProfileId
        
        // Geocoding current location
        lookUpCurrentLocation { (placeMark: CLPlacemark?) in
            //In case it fails we show coordinates
            print("Meeting location: " + (placeMark?.name ?? "Not found"))
            scannedConnectionProfile.connectionLocationName = placeMark?.name ?? "\(connectionLocation.latitude) \(connectionLocation.longitude)"
            
            //Add connection
            DispatchQueue.global(qos: .utility).async {
                _ = try? ProfileDataHelper.insert(item: scannedConnectionProfile)
                
            }
            
            //Show  message
            let alertPrompt = UIAlertController(title: "Contact Added", message: "You can see your new connection on Contacts List tab", preferredStyle: .alert)
            
            let navigateAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
                self.captureSession.startRunning()
            })
            
            alertPrompt.addAction(navigateAction)
            
            self.present(alertPrompt, animated: true, completion: nil)
        }
        
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    private func navigateToConnectionDetail (_ profileId: Int64) {
        let storyboard = UIStoryboard(name: Constants.Identifiers.STORYBOARD, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.Identifiers.CONNECTION_DETAIL) as! ConnectionDetailViewController
        viewController.profileId = profileId
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func prepareForAddOrUpdateConnection(_ scannedConnectionProfile: Profile){
        print("Adding or updating connection \(scannedConnectionProfile.name ?? "")")
        
        //        Check if connection's email already exists
        if let connectionList = try? ProfileDataHelper.findConectionsByProfileid(idobj: currentProfileId) {
            for connection in connectionList {
                // Is there smth like LINQ here to avoid this loop?
                if connection.email == scannedConnectionProfile.email {
                    updateProfileConnection(scannedConnectionProfile, connection)
                    //after update there is no need to keep going with loop and function
                    return
                }
                
            }
        }
        
        addProfileConnection(scannedConnectionProfile)
        
    }
    
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            
            if previewLayerConnection.isVideoOrientationSupported {
                switch (orientation) {
                case .portrait:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                case .landscapeRight:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                    break
                case .landscapeLeft:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                    break
                case .portraitUpsideDown:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                    break
                default:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                }
            }
        }
    }
    
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                processQR(decodedURL: metadataObj.stringValue!)
                // messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}
