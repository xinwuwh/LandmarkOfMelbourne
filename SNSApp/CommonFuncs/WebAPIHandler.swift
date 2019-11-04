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

struct ModelNames{
    static let MobileNet = "MobileNet"
    static let InceptionV3 = "InceptionV3"
    static let ResNet50 = "ResNet50"
    static let Xception = "Xception"
    
}

public struct WebAPIUrls{
    public static let IP = "api.landmarks.link"//"127.0.0.1"
    public static let baseURL = "http://\(IP)"

    public static let landmarkURL = baseURL + "/landmarks_predict?model="
    
    public static let streetViewUrl = baseURL + "/street_predict"
    public static let streetViewSelectLabelUrl = baseURL + "/street_collection?label="

    public static let listAllLandmarks = baseURL + "/get_landmark_description?All_result=True&Label_name=asdf"
    public static let listAllStreetView = baseURL + "/get_street_description?All_result=True&Label_name=asdf"

    
    
    
    
}


public class WebAPIHandler {
    
    
    
    public static var shared = WebAPIHandler()
    
    var allLandmarks: [Landmark] = []
    var allStreetView: [StreetView] = []
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
            },
            to: apiEndpoint,
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
    
    public func uploadAndMarkLabel(labelName: String ,image: UIImage,callback:@escaping ((DataResponse<Data>) -> Void) ){
        
        let imageData = image.jpeg(.medium)!
        
        UIFuncs.showLoadingLabel()
        
        _httpManager.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file",fileName:"upload.jpeg" ,mimeType:"image/jpeg")
        },
            to: WebAPIUrls.streetViewSelectLabelUrl + labelName,
            method:HTTPMethod.post,
            //            headers:self.headerWithToken,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success( let response, _, _):
                    response.responseData{ r in
                        UIFuncs.dismissLoadingLabel()
                        callback(r)
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
    
    public func getAllStreetView(callback:@escaping ((DataResponse<[StreetView]>) -> Void)) -> Void{
        UIFuncs.showLoadingLabel()
        _httpManager.request(WebAPIUrls.listAllStreetView,
                             method: HTTPMethod.post,
                             encoding: JSONEncoding.default)
            .validate()
            .responseArray{ (response: DataResponse<[StreetView]>) in
                UIFuncs.dismissLoadingLabel()
                if let streetViewData = response.result.value{
                    DispatchQueue.main.async {
                        self.allStreetView = streetViewData
                        callback(response)
                    }
                }
        }
        
    }
    
   

}
