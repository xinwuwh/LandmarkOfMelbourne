//
//  PredictStreetViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 23/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import WebKit

class PredictStreetViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    public var streetView: StreetView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var html = "<html><style>iframe{width:100%;height:100%;}</style><body>\(streetView.googleFrame!)</body></html>"
        webView.loadHTMLString(html, baseURL: nil)
        descriptionLabel.text = streetView.description
        titleLabel.text = streetView.streetViewName
        
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
