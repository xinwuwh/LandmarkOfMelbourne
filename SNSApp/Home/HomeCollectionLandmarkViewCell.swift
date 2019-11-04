//
//  HomeCollectionViewCell.swift
//  SNSApp
//
//  Created by 吴欣 on 18/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit

class HomeCollectionLandmarkViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelView: UILabel!
    
    public var landMark: Landmark!
    
    public var index: Int!
    
}
