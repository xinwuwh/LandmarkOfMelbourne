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

public class Landmark: Mappable{
//    var id:Int?
    var landmarkName: String?
//    var searchedName: String?
//    var count: Int?
    var description: String?
    
    var imageURL: String?
    
    var coordinate: Coordinate!

    public required init?(map: Map) {
        self.mapping(map: map)
    }

    public func mapping(map: Map) {
        self.landmarkName <- map["name"]
        self.description <- map["description"]
        self.imageURL <- map["imageUrl"]
        if(self.imageURL == nil){
            self.imageURL = "https://www.freeiconspng.com/uploads/no-image-icon-11.PNG"
        }
        
        
        var coorString : String = ""
        coorString <- map["coordinate"]
        self.coordinate = Coordinate(locationString: coorString)
    }
    
    
}

public class Coordinate{
    var lat:Double!
    var lng:Double!
    
    public init(locationString: String){
        let c = locationString.split(separator: ",")
        lat = Double(c[0].trimmingCharacters(in: .whitespaces))
        lng = Double(c[1].trimmingCharacters(in: .whitespaces))
    }
}

//public class Coordinate: Mappable{
//    //    var id:Int?
//    var lat: Double
//    //    var searchedName: String?
//    //    var count: Int?
//    var lng: Double
//
//    public required init?(map: Map) {
//        self.mapping(map: map)
//    }
//
//    public func mapping(map: Map) {
//        //        var allDesc:[String]
//        //        allDesc <- map["description"]
//        //        var allImages:[String]
//        //        allImages <- map["imageUrl"]
//
//        //        for()
//        //        self.id <- map["Index"]
//        self.lat <- map["userId"]
//        //        self.searchedName <- map["avatarUrl"]
//        //        self.count <- map["count"]
//        self.description <- map["Description"]
//        self.imageURL <- map["imageURL"]
//    }
//}

