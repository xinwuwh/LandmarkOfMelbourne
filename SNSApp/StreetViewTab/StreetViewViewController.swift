//
//  TabBarViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 7/9/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import PhotosUI
import FCAlertView


class StreetViewViewController: UIViewController {
    
    
    @IBOutlet weak var streetViewNameLabel: UILabel!
    @IBOutlet weak var streetViewScoreLabel: UILabel!
    @IBOutlet weak var streetViewUploadButton: UIButton!
    @IBOutlet weak var streetViewImageView: UIImageView!
    
    @IBOutlet weak var showStreetViewButton: UIButton!
    internal var apiEndpoint: String?
    
    var imagePicker = UIImagePickerController()
    
    var actionSheet : UIAlertController!
    
    private var selectedImage: UIImage?
    
    private var predictResult: PredictResult?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.apiEndpoint = WebAPIUrls.landmarkURL + ModelNames.MobileNet ;
        
        UIFuncs.setBorder(layer: streetViewUploadButton.layer, width: 0, cornerRadius: 15, color: UIColor.white.cgColor)
        
        streetViewUploadButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft

        showStreetViewButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        showStreetViewButton.isHidden = true

        UIFuncs.setBorder(layer: showStreetViewButton.layer, width: 0, cornerRadius: 15, color: UIColor.white.cgColor)
        
        streetViewImageView.contentMode = .center
        
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showActionSheet))
        
        imagePicker.delegate = self
        
        actionSheet = UIAlertController(title: "Photo Source", message: "Choose A Photo", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }else
            {
                print("Camera is Not Available")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction)in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        
        // add it to the image view;
        streetViewImageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        streetViewImageView.isUserInteractionEnabled = true
        
        self.apiEndpoint = WebAPIUrls.streetViewUrl;
    }
    
    
    @IBAction func upload(_ sender: Any) {
        if let image = self.selectedImage{
            image.af_inflate()
            WebAPIHandler.shared.upload(apiEndpoint:self.apiEndpoint! ,image: image){ response in
                switch response.result{
                case .failure(let error):
                    print(error.localizedDescription)
                    UIFuncs.popUp(title: "Error", info: "Upload failed, \(error.localizedDescription)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
                case .success(_):
                    if let data = response.result.value{
                        self.streetViewNameLabel.text =  "\(data.bestResult!)"
                        self.streetViewScoreLabel.text = "(score: \(data.bestResultScore!))"
                        self.predictResult = data
                        self.showStreetViewButton.isHidden = false
                        let alert = FCAlertView();
                        
                        alert.delegate = self
                        alert.hideDoneButton = true
                        alert.showAlert(inView: self,
                                        withTitle:"Predict Result",
                                        withSubtitle:"Your image is [\(data.bestResult ?? "Nowhere")] \n (Score:\(data.bestResultScore!) ",
                                        withCustomImage: self.selectedImage,
                                        withDoneButtonTitle:nil,
                                        andButtons:["Correct!", "Wrong Predict"]) // Set your button titles here
                    }
                }
            }
        }else{
            UIFuncs.popUp(title: "Warning", info: "Please select an image first", type: .caution, sender: self, callback:{})
        }
//        findLocationButton.isHidden = false
    
    }
    @objc func showActionSheet() {
        
        self.present(actionSheet,animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectLabel"{
            let selectLabel = segue.destination as! SelectLableViewController
            selectLabel.image = self.selectedImage
        }else if segue.identifier == "googleStreetView"{
            let googleStreetView = segue.destination as! PredictStreetViewController
            googleStreetView.streetView = WebAPIHandler.shared.allStreetView.first{ item in
                item.streetViewName == predictResult!.bestResult
                }!
        }
        
        
    }
    
    
}

extension StreetViewViewController : FCAlertViewDelegate {
    func fcAlertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        if title == "Correct!" {
            WebAPIHandler.shared.uploadAndMarkLabel(labelName: (predictResult?.bestResult!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!, image: self.selectedImage!){ response in
                switch response.result{
                case .failure(let error):
                    print(error.localizedDescription)
                    UIFuncs.popUp(title: "Error", info: "Loading street view data failed, \(String(data: response.data!, encoding: String.Encoding.utf8)!)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
                case .success( _):
                    UIFuncs.popUp(title: "Succ", info: "Thanks for your contribution!", type: UIFuncs.BlockPopType.success , sender: self, callback: {})
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }else if title == "Wrong Predict"{
            self.performSegue(withIdentifier: "selectLabel", sender: self)
        }
    }
    
}


extension StreetViewViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        let originalCIImage = CIImage(data: newImage.pngData()!)
        
        self.streetViewImageView.image = UIImage(ciImage:originalCIImage!)
        
        // do something interesting here!
        self.selectedImage = newImage
        self.streetViewImageView.image = newImage
        streetViewImageView.contentMode = .scaleAspectFit
        self.imagePicker.dismiss(animated: true, completion: nil)
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
    
    
}
