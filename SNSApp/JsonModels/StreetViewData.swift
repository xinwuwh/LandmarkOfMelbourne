//
//  SuggestionUserListModel.swift
//  SNSApp
//
//  Created by Kang Ning on 9/10/18.
//  Copyright © 2018 Kang Ning. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

//public class LandmarkData: Mappable{
//    var landMarks:[Landmark]?
//
//    public init() {
//        landMarks = []
//    }
//
//    public required init?(map: Map) {
//        self.mapping(map: map)
//    }
//
//    public func mapping(map: Map) {
//        self.landMarks <- map["users"]
//    }
//}

public class StreetView: Mappable{
    //    var id:Int?
    var streetViewName: String?
    //    var searchedName: String?
    //    var count: Int?
    var description: String?
    
    var imageURL: String?
    
    var googleFrame: String?
    
    public required init?(map: Map) {
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        self.streetViewName <- map["name"]
        self.description <- map["description"]
        self.imageURL <- map["imageUrl"]
        if(self.imageURL == nil){
            self.imageURL = "https://www.freeiconspng.com/uploads/no-image-icon-11.PNG"
        }
        self.googleFrame <- map["streetView"]
    }
    
    
}

