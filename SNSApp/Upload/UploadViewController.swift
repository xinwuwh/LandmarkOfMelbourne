//
//  UploadViewController.swift
//  SNSApp
//
//  Created by Kang Ning on 2/10/18.
//  Copyright © 2018 Kang Ning. All rights reserved.
//

import UIKit
import PhotosUI
import YPImagePicker


class UploadViewController: UIViewController,UITextFieldDelegate {		
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var selectedImage: UIImage?
    
    private let context = CIContext()
    
//    private var isImageSelected = false
    
    internal var apiEndpoint: String?
    //    @IBOutlet weak var isUseLocation: UISwitch!
    
//    let locationManager = CLLocationManager()
    
    var picker:YPImagePicker!
    
    @IBOutlet weak var resultTextLabel: UILabel!
    
//    @IBOutlet weak var cameraGrid: UIImageView!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var contentTextView: UITextField!
//    var currentLocation:(address:String,lati:CLLocationDegrees?,logi:CLLocationDegrees?) = (address:"N/A",lati:nil,logi:nil){
//        didSet{
//            if isUseLocation.isOn{
//                addressLabel.text = currentLocation.address
//            }else{
//                addressLabel.text = ""
//            }
//        }
//    }
    
    @IBOutlet var viewsNeedBorder: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        contentTextView.delegate = self
//        locationManager.delegate = self
        
        UIFuncs.setBorder(views: viewsNeedBorder, width: 2, cornerRadius: 15, color: UIColor.white.cgColor)
    
        
        
        // add tap gesture for image view to allow select image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showActionSheet))
        
        // add it to the image view;
        imageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        imageView.isUserInteractionEnabled = true
        
        // 3rd photo library
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .original
        config.usesFrontCamera = true
//        config.showsFilters = true
        config.screens = [.library, .photo]
        config.hidesStatusBar = false
        config.usesFrontCamera = false
        
        config.showsCrop = .rectangle(ratio: (1/1))
//        config.overlayView = cameraGrid
        
        picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [picker] items, _ in
            if let photo = items.singlePhoto {
                self.imageView.image = photo.image
                self.selectedImage = photo.image
            }
            
            self.picker.dismiss(animated: true, completion: nil)
        }
        
        
//        let application = UIApplication.shared.delegate as! AppDelegate
//        let tabbarController = application.window?.rootViewController as! UITabBarController
    
        
        
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        self.imageView.image = #imageLiteral(resourceName: "tap-to-add")
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    @IBAction func upload(_ sender: Any) {

//        if !isImageSelected{
//            return
//        }
        
//        self.selectedImage = imageView.image
        if let image = self.selectedImage{
            image.af_inflate()
            WebAPIHandler.shared.upload(apiEndpoint:self.apiEndpoint! ,image: image){ response in
                switch response.result{
                case .failure(let error):
                    print(error.localizedDescription)
                    UIFuncs.popUp(title: "Error", info: "Upload failed, \(error.localizedDescription)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
                case .success(_):
                    if let data = response.result.value{
                        self.resultTextLabel.text =  "\(data.bestResult!)(score: \(data.bestResultScore!))"
                        
                        var mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
                        
                        mapViewController.placeName = self.resultTextLabel.text
                        let coorFromList = WebAPIHandler.shared.allLandmarks.first{ item in
                            item.landmarkName == data.bestResult
                        }?.coordinate
                        
                        if let coord = coorFromList{
                            mapViewController.coordinate = coord
                            self.present(mapViewController, animated: true, completion: nil)
                        }else{
                            UIFuncs.popUp(title: "Warning", info: "No coordinator found from Predifined Landmark List", type: .caution, sender: self, callback:{})
                        }
                        
                        
                        
                    }
                }
            }
        }else{
            UIFuncs.popUp(title: "Warning", info: "Please select an image first", type: .caution, sender: self, callback:{})
        }
    }
    
    
    
    @IBAction func imagePickerY(_ sender: Any) {
        
    }
    
}


extension UploadViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        let originalCIImage = CIImage(data: newImage.pngData()!)
        
        self.imageView.image = UIImage(ciImage:originalCIImage!)
        
        // do something interesting here!
        self.selectedImage = newImage
        self.imageView.image = newImage
//        self.isImageSelected = true
        dismiss(animated: true)
    }
    
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.modalPresentationStyle = .popover
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func checkPhotoPermission(hanler: @escaping () -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            // Access is already granted by user
            hanler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    // Access is granted by user
                    hanler()
                }
            }
        default:
            print("Error: no access to photo album.")
        }
    }
    
    @objc func showActionSheet() {
        imageView.contentMode = .scaleAspectFit
        present(picker, animated: true, completion: nil)
    }
}
//
//extension UploadViewController:CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways || status == .authorizedWhenInUse{
//            self.getLocationAsyn()
//            self.isUseLocation.isOn = true
//        }else{
//            self.isUseLocation.isOn = false
//        }
//    }
//
//    func getCoordinate() -> (lati:CLLocationDegrees?,logi:CLLocationDegrees?){
//
//        var lati:CLLocationDegrees?
//        var logi:CLLocationDegrees?
//        if let currentLocation = locationManager.location?.coordinate{
//            lati = currentLocation.latitude
//            logi = currentLocation.longitude
//        }
//
//        return (lati, logi)
//
//    }
//
//    func getLocationAsyn(){
//
//        let coordinate = getCoordinate()
//
//        var address: String = ""
//
//        guard let lati = coordinate.lati, let logi = coordinate.logi else{
//            currentLocation.address = address
//            currentLocation = (address:address,lati:nil,logi:nil)
//            return
//        }
//
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: lati, longitude: logi)
//
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//
//            if let e = error{
//                print("Reverse geocoder failed with error" + e.localizedDescription)
//                self.currentLocation = (address:address,lati:nil,logi:nil)
//                return
//            }
//            guard let placeMark = placemarks?[0] else{
//                print("Problem with the data received from geocoder")
//                self.currentLocation = (address:address,lati:nil,logi:nil)
//                return
//            }
//
//            // Address dictionary
//            //print(placeMark.addressDictionary ?? "")
//
//            // Location name
//            if let locationName = placeMark.name {
//                address += "\(locationName),"
//            }
//
////            // Street address
////            if let street = placeMark.thoroughfare {
////                address += "\(street),"
////            }
//
//            // City
//            if let city = placeMark.locality { // city
//                address += "\(city),"
//            }
//
//            // Country
//            if let country = placeMark.country{
//                address += "\(country)"
//            }
//
//            self.currentLocation = (address:address,lati:lati,logi:logi)
//
//        })
    
//    }
//}

