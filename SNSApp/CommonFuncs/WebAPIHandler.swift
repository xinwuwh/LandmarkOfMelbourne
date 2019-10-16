//
//  StaticValues.swift
//  SNSApp
//
//  Created by Kang Ning on 24/9/18.
//  Copyright © 2018 Kang Ning. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import PhotosUI
import AlamofireImage

struct WebAPIJSONHeader{
    static let USERNAME = "username"
    static let PASSWORD = "password"
}

public struct WebAPIUrls{
    public static let IP = "54.252.183.147"//"127.0.0.1"
    public static let baseURL = "http://\(IP)"
//    public static let photoResourceBaseURL = "http://\(IP):5001/photos/"
//
//    public static let loginURL = baseURL + "/login/login"
//    public static let signupURL = baseURL + "/login/sign-up"
    public static let landmarkURL = baseURL + "/upload_image?model=MobileNet"
    
    public static let streetViewUrl = baseURL + "/upload_image?model=MobileNet"
    
    public static let listAllLandmarks = baseURL + "/get_description?All_result=True&Label_name=asdf"
//    public static let updateAvatorURL = baseURL + "/upload/uploadAvator"
//    public static let stasticsURL = baseURL + "/UserProfile/poststat"
//    public static let myPhotosURL = baseURL + "/UserProfile/myphotos"
////    public static let suggestionURL = baseURL + "/UserProfile/myphotos"
//    public static let followedBy = baseURL + "/ActivityFeed/getFollowedUserList"
//    public static let followingWhom = baseURL + "/ActivityFeed/getFollowingUserList"
//    public static let discoverUserList = baseURL + "/Discover/index"
//    public static let followUser = baseURL + "/Discover/followUser"
//    public static let unFollowUser = baseURL + "/Discover/cancelFollowUser"
//    public static let queryUser = baseURL + "/Discover/queryUser"
    
    
    
}


public class WebAPIHandler {
    
    
    
    public static var shared = WebAPIHandler()
    
    var allLandmarks: [Landmark] = []
    public var username:String?
    
    private var token : String?
    
    public func setToken(token: String){
        self.token = "Bearer \(token)"
        headerWithToken = [
            "Accept": "application/json",
            "Authorization":self.token!,
            "Content-Type":"application/json"
        ]
    }
    
    private let jsonHeader:HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type":"application/json"
    ]
    
    var downloader:ImageDownloader!
    
    private var headerWithToken:HTTPHeaders?
    let imageCache = AutoPurgingImageCache()
    
    public let _httpManager : SessionManager =  {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            WebAPIUrls.IP: .disableEvaluation

        ]
        
        let sessionManager = SessionManager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return sessionManager
    }()
    
    private init(){
        let sessionManager = SessionManager(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            serverTrustPolicyManager: ServerTrustPolicyManager(
                policies: [WebAPIUrls.IP: .disableEvaluation]
            )
        )
        downloader = ImageDownloader(sessionManager: sessionManager, downloadPrioritization: .lifo, maximumActiveDownloads: 10, imageCache: self.imageCache) //ImageDownloader(sessionManager: sessionManager)
        UIImageView.af_sharedImageDownloader = ImageDownloader(sessionManager: sessionManager)
    }
    
    
    
    
    public func upload(apiEndpoint: String,image: UIImage,callback:@escaping ((DataResponse<PredictResult>) -> Void) ){
        
        let imageData = image.jpeg(.medium)!
        
        UIFuncs.showLoadingLabel()
        
        _httpManager.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file",fileName:"upload.jpeg" ,mimeType:"image/jpeg")
//                multipartFormData.append("", withName: "content")
//                multipartFormData.append(location.utf8(), withName: "location")
//                if let latiDouble = lati{
//                    multipartFormData.append(latiDouble.utf8(), withName: "lati")
//                }
//                if let logiDouble = logi{
//                    multipartFormData.append(logiDouble.utf8(), withName: "logi")
//                }
                
            },
            to: WebAPIUrls.landmarkURL,
            method:HTTPMethod.post,
//            headers:self.headerWithToken,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                   
                    upload.responseObject { (response: DataResponse<PredictResult>) in
                        UIFuncs.dismissLoadingLabel()
                        callback(response)
                        
                    }
                case .failure(let encodingError):
                    UIFuncs.dismissLoadingLabel()
                    print(encodingError)
                }
        }
        )
        
    }
    
    public func getAllLandmarks(callback:@escaping ((DataResponse<[Landmark]>) -> Void)) -> Void{
        UIFuncs.showLoadingLabel()
        _httpManager.request(WebAPIUrls.listAllLandmarks,
            method: HTTPMethod.post,
            encoding: JSONEncoding.default)
            .validate()
            .responseArray{ (response: DataResponse<[Landmark]>) in
                UIFuncs.dismissLoadingLabel()
                if let landmarkData = response.result.value{
                    DispatchQueue.main.async {
                        self.allLandmarks = landmarkData
                        callback(response)
                    }
                }
        }
        
    }
    
    
   

}
