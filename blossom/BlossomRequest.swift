//
//  BlossomRequest.swift
//  blossom
//
//  Created by Seong Phil on 2016. 10. 14..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Mixpanel

struct BlossomRequest {
}

extension BlossomRequest {
    static func makeHeaders() -> [String:String]? {
        if let me = Session.load(){
            Mixpanel.sharedInstance().identify(String(me.id))
            return ["Authorization": String(me.id) + ":" + me.accessToken]
        }
        
        return nil
    }
    
    
    static func request(method: HTTPMethod, endPoint: String, params: [String : Any]? = nil,
                        completionHandler: @escaping
        (_ response: Alamofire.DataResponse<Any>, _ statusCode:Int, _ json:JSON) -> ()) -> Request{
        
        
        return Alamofire.request(endPoint, method: method, parameters: params, encoding: JSONEncoding.default, headers: BlossomRequest.makeHeaders())
            .responseJSON{response in
                switch response.result {
                case .failure(_):
                    log.error("Request failed!! \(endPoint) \(response)")
                case .success(_):
                    completionHandler(response, (response.response?.statusCode)!, JSON(response.result.value!))
                }
        }
    }
    
    static func upload(_ method: Alamofire.HTTPMethod, urlString: String, multipartFormData: @escaping (Alamofire.MultipartFormData)->(), completionHandler: @escaping
        (_ response: Alamofire.DataResponse<Any>, _ statusCode:Int, _ json:JSON) -> ()){
            Alamofire.upload(multipartFormData: multipartFormData,
                             usingThreshold:UInt64.init(),
                             to: urlString,
                             method: method,
                             headers: BlossomRequest.makeHeaders(),
                             encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .failure:
                        log.error("Upload request failed!!")
                    case .success:
                        completionHandler(response, (response.response?.statusCode)!, JSON(response.result.value!))
                    }
                }
            case .failure(let error):
                log.warning((error as NSError).localizedDescription)
            }
        })
    }
}