//
//  HomeDetailViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 1/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import Alamofire

class HomeDetailViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var largeImageView: UIImageView!
    
    var predefinedCellData: Landmark?//(title: String,description: String, smallImageUrl :String, largeImageUrl: String)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let d = predefinedCellData{
            titleLable.text = d.landmarkName
            descriptionLabel.text = d.description

            Alamofire.request( d.imageURL!).responseImage { response in

                if let image = response.result.value {
                    self.largeImageView.image = image
                }
            }
        }

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
