//
//  HomeTableViewCell.swift
//  SNSApp
//
//  Created by 吴欣 on 1/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import Alamofire
class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var titlaLable: UILabel!
    @IBOutlet weak var smallImageView: UIImageView!
    var index = 0
//    var predefinedCellData: (title: String,description: String, smallImageUrl :String, largeImageUrl: String)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
