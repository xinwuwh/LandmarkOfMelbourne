//
//  TabBarViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 7/9/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import PhotosUI
class LandmarkViewController: UIViewController {
    
    @IBOutlet weak var landmarkNameLable: UILabel!
    @IBOutlet weak var landmarkScoreTextLabel: UILabel!
    @IBOutlet weak var landmarkUploadButton: UIButton!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var landmarkModelSelector: UISegmentedControl!
    @IBOutlet weak var landmarkImageView: UIImageView!
    
    internal var apiEndpoint: String?
    
    var imagePicker = UIImagePickerController()
    
    var actionSheet : UIAlertController!
    
    private var selectedImage: UIImage?
    
    private var predictResult: PredictResult?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiEndpoint = WebAPIUrls.landmarkURL + ModelNames.MobileNet ;
        
        UIFuncs.setBorder(layer: landmarkUploadButton.layer, width: 0, cornerRadius: 15, color: UIColor.white.cgColor)
        
        landmarkUploadButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        UIFuncs.setBorder(layer: findLocationButton.layer, width: 0, cornerRadius: 15, color: UIColor.white.cgColor)
        
        findLocationButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        UIFuncs.setBorder(layer: findLocationButton.layer, width: 0, cornerRadius: 15, color: UIColor.white.cgColor)
        findLocationButton.isHidden = true
        landmarkImageView.contentMode = .center
        
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
        landmarkImageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        landmarkImageView.isUserInteractionEnabled = true
    }

    @IBAction func upload(_ sender: UIButton) {
        if let image = self.selectedImage{
            image.af_inflate()
            WebAPIHandler.shared.upload(apiEndpoint:self.apiEndpoint! ,image: image){ response in
                switch response.result{
                case .failure(let error):
                    print(error.localizedDescription)
                    UIFuncs.popUp(title: "Error", info: "Upload failed, \(error.localizedDescription)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
                case .success(_):
                    if let data = response.result.value{
                        self.landmarkNameLable.text =  "\(data.bestResult!)"
                        self.landmarkScoreTextLabel.text = "(score: \(data.bestResultScore!))"
                        self.predictResult = data
                        self.findLocationButton.isHidden = false
                        
                        
                        
                    }
                }
            }
        }else{
            UIFuncs.popUp(title: "Warning", info: "Please select an image first", type: .caution, sender: self, callback:{})
        }
        findLocationButton.isHidden = false
    }
    
    @IBAction func showLocation(_ sender: UIButton) {
        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        
        mapViewController.placeName = predictResult?.bestResult!
        mapViewController.scoreValue = predictResult?.bestResultScore!
        let coorFromList = WebAPIHandler.shared.allLandmarks.first{ item in
            item.landmarkName == predictResult!.bestResult
            }?.coordinate
        
        if let coord = coorFromList{
            mapViewController.coordinate = coord
            
        }else{
            UIFuncs.popUp(title: "Warning", info: "No coordinator found from Predifined Landmark List", type: .caution, sender: self, callback:{})
        }
         self.present(mapViewController, animated: true, completion: nil)
    }
    @objc func showActionSheet() {
        
        self.present(actionSheet,animated: true, completion: nil)
    }
}
	

extension LandmarkViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
        
        self.landmarkImageView.image = UIImage(ciImage:originalCIImage!)
        
        // do something interesting here!
        self.selectedImage = newImage
        self.landmarkImageView.image = newImage
        landmarkImageView.contentMode = .scaleAspectFit
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
