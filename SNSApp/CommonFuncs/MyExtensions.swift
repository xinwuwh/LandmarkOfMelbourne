//
//  MyExtensions.swift
//  SNSApp
//
//  Created by Kang Ning on 2/10/18.
//  Copyright © 2018 Kang Ning. All rights reserved.
//

import Foundation
import UIKit

extension String{
  
    public func utf8() -> Data{
        return self.data(using:String.Encoding.utf8)!
    }
        
}

extension Float{
    public func utf8() -> Data{
        return "\(self)".data(using: String.Encoding.utf8)!
    }
}

extension Double{
    public func utf8() -> Data{
        return "\(self)".data(using: String.Encoding.utf8)!
    }
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
