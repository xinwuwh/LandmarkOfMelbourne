//
//  HomeDetailViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 1/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import Alamofire

class HomeLandmarkDetailViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var largeImageView: UIImageView!
    
    @IBOutlet weak var placeIconImageView: UIImageView!
    public var index: Int!
    
    var predefinedCellData: Landmark?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi
        rotationAnimation.duration = 1.0
        
        self.largeImageView.layer.add(rotationAnimation, forKey: "loading")
        
        // Do any additional setup after loading the view.
        if let d = predefinedCellData{
            titleLable.text = d.landmarkName
            descriptionLabel.text = d.description

            Alamofire.request( d.imageURL!).responseImage { response in

                if let image = response.result.value {
                    self.largeImageView.layer.removeAllAnimations()
                    self.largeImageView.image = image
                }
            }
        }
        
//        let icon = UIImage(named: "\(self.index + 1)")!
//        let iconRadius = icon.af_imageRounded(withCornerRadius: CGFloat(15))
//        self.placeIconImageView.image =  iconRadius.af_imageRoundedIntoCircle()
//        self.placeIconImageView.image.layer
        placeIconImageView.image = UIImage(named: "\(self.index + 1)")
        placeIconImageView.layer.masksToBounds = true
        placeIconImageView.layer.borderWidth = 0.5
        placeIconImageView.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 1, alpha: 1)
        placeIconImageView.layer.cornerRadius = placeIconImageView.bounds.width / 2
        
       

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
