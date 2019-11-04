//
//  HomeCollectionStreetViewCellCollectionViewCell.swift
//  SNSApp
//
//  Created by 吴欣 on 23/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit

class HomeCollectionStreetViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelView: UILabel!
    
    public var streetView: StreetView!
    
    public var index: Int!
}
