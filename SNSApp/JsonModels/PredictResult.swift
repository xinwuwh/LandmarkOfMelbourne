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

public class PredictResult: Mappable{
    //    var id:Int?
    var bestResult: String?
    
    var bestResultScore: String? {
        get{
            for item in allResults {
                if(item.landMarkName == bestResult){
                    return item.score
                }
            }
            return nil
        }
    }
    //    var searchedName: String?
    //    var count: Int?
    var allResults: [(landMarkName:String, score: String)] = []
 
    public required init?(map: Map) {
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        self.bestResult <- map["best_result"]
        var allResultsList: [[String]] = []
        allResultsList <- map["all_results"]
        
        for onePredict in allResultsList {
            allResults.append((landMarkName:onePredict[0] , score: onePredict[1]))
        }
        
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

