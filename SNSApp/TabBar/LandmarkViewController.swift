//
//  TabBarViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 7/9/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit

class LandmarkViewController: UploadViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiEndpoint = WebAPIUrls.landmarkURL;
        // Do any additional setup after loading the view.
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
	
