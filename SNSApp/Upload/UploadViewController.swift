////
////  UploadViewController.swift
////  SNSApp
////
////  Created by Kang Ning on 2/10/18.
////  Copyright © 2018 Kang Ning. All rights reserved.
////
//
//import UIKit
//import PhotosUI
//
//class UploadViewController: UIViewController,UITextFieldDelegate {        
//    
//    var imageView: UIImageView!
//    
//    private var selectedImage: UIImage?
//    
//    private let context = CIContext()
//    
//    internal var apiEndpoint: String?
//
//    var imagePicker = UIImagePickerController()
//    
//    var actionSheet : UIAlertController!
//    
//    var nameLabel: UILabel!
//    var scoreLabel: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // add tap gesture for image view to allow select image
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showActionSheet))
//        
//        imagePicker.delegate = self
//        
//        actionSheet = UIAlertController(title: "Photo Source", message: "Choose A Photo", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction)in
//            if UIImagePickerController.isSourceTypeAvailable(.camera){
//                self.imagePicker.sourceType = .camera
//                self.present(self.imagePicker, animated: true, completion: nil)
//            }else
//            {
//                print("Camera is Not Available")
//            }
//            
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction)in
//            self.imagePicker.sourceType = .photoLibrary
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        
//        
//        // add it to the image view;
//        imageView.addGestureRecognizer(tapGesture)
//        // make sure imageView can be interacted with by user
//        imageView.isUserInteractionEnabled = true
//        
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//       
//        
//    }
//    
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//    
//    
//    func uploadAndPredict(_ sender: Any) {
//
////        if !isImageSelected{
////            return
////        }
//        
////        self.selectedImage = imageView.image
//        if let image = self.selectedImage{
//            image.af_inflate()
//            WebAPIHandler.shared.upload(apiEndpoint:self.apiEndpoint! ,image: image){ response in
//                switch response.result{
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    UIFuncs.popUp(title: "Error", info: "Upload failed, \(error.localizedDescription)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
//                case .success(_):
//                    if let data = response.result.value{
//                        self.nameLabel.text =  "\(data.bestResult!)"
//                        self.scoreLabel.text = "(score: \(data.bestResultScore!))"
//                        
//                        var mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
//                        
//                        mapViewController.placeName = data.bestResult!
//                        mapViewController.scoreValue = data.bestResultScore!
//                        let coorFromList = WebAPIHandler.shared.allLandmarks.first{ item in
//                            item.landmarkName == data.bestResult
//                        }?.coordinate
//                        
//                        if let coord = coorFromList{
//                            mapViewController.coordinate = coord
//                            self.present(mapViewController, animated: true, completion: nil)
//                        }else{
//                            UIFuncs.popUp(title: "Warning", info: "No coordinator found from Predifined Landmark List", type: .caution, sender: self, callback:{})
//                        }
//                        
//                        
//                        
//                    }
//                }
//            }
//        }else{
//            UIFuncs.popUp(title: "Warning", info: "Please select an image first", type: .caution, sender: self, callback:{})
//        }
//    }
//
//    
//}
//
//
//extension UploadViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.imagePicker.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        var newImage: UIImage
//
//        
//        if let possibleImage = info[.editedImage] as? UIImage {
//            newImage = possibleImage
//        } else if let possibleImage = info[.originalImage] as? UIImage {
//            newImage = possibleImage
//        } else {
//            return
//        }
//        let originalCIImage = CIImage(data: newImage.pngData()!)
//
//        self.imageView.image = UIImage(ciImage:originalCIImage!)
//
//        // do something interesting here!
//        self.selectedImage = newImage
//        self.imageView.image = newImage
//        self.imagePicker.dismiss(animated: true, completion: nil)
//    }
////    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
////        self.dismiss(animated: true, completion: nil)
////    }
////
////    @objc private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
////
////        var newImage: UIImage
////
////        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
////            newImage = possibleImage
////        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
////            newImage = possibleImage
////        } else {
////            return
////        }
////        let originalCIImage = CIImage(data: newImage.pngData()!)
////
////        self.imageView.image = UIImage(ciImage:originalCIImage!)
////
////        // do something interesting here!
////        self.selectedImage = newImage
////        self.imageView.image = newImage
//////        self.isImageSelected = true
////        dismiss(animated: true)
////    }
//    
//    
//    func camera()
//    {
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            let myPickerController = UIImagePickerController()
//            myPickerController.delegate = self;
//            myPickerController.modalPresentationStyle = .popover
//            myPickerController.sourceType = .camera
//            myPickerController.allowsEditing = true
//            
//            self.present(myPickerController, animated: true, completion: nil)
//        }
//        
//    }
//    
//    func photoLibrary()
//    {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            let myPickerController = UIImagePickerController()
//            myPickerController.delegate = self;
//            myPickerController.sourceType = .photoLibrary
//            myPickerController.allowsEditing = true
//            self.present(myPickerController, animated: true, completion: nil)
//        }
//    }
//    
//    func checkPhotoPermission(hanler: @escaping () -> Void) {
//        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//        switch photoAuthorizationStatus {
//        case .authorized:
//            // Access is already granted by user
//            hanler()
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization { (newStatus) in
//                if newStatus == PHAuthorizationStatus.authorized {
//                    // Access is granted by user
//                    hanler()
//                }
//            }
//        default:
//            print("Error: no access to photo album.")
//        }
//    }
//    
//    @objc func showActionSheet() {
////        imageView.contentMode = .scaleAspectFit
//////        present(picker, animated: true, completion: nil)
////        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
////            print("Button capture")
////
////            imagePicker.delegate = self
////            imagePicker.sourceType = .savedPhotosAlbum
////            imagePicker.allowsEditing = false
////
////            present(imagePicker, animated: true, completion: nil)
////        }
//        self.present(actionSheet,animated: true, completion: nil)
//    }
//}
//
//
