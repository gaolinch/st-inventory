//
//  UtilityApi.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/10/31.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//
import Alamofire

import SwiftyJSON

import RealmSwift

class UtilityApi: NSObject
{
    static func fetchRandom(parameters:Parameters, completion: ((Constants.CompletionStatus, String)->Void)!) -> Void
    {
        let routerRequest:URLRequestConvertible = Router.fetchRandom(parameters: parameters)
        
        let dataRequest:DataRequest = Alamofire.request(routerRequest)
        dataRequest.responseJSON(completionHandler:
            {
                response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.data as Any)     // server data
                print(response.result)   // result of response serialization
                
                var isSuccess:Bool = false
                
                var error:String = ""
                
                if response.data != nil
                {
                    let json:JSON = JSON(response.result.value as Any)
                    print(json)
                    if json != JSON.null
                    {
                        
                    }
                }
                
                if !isSuccess
                {
                    completion(Constants.CompletionStatus.Failure, error)
                }
        })
    }
    
    enum Router: URLRequestConvertible
    {
        case fetchRandom(parameters: Parameters)
        
        static let baseURLString = Constants.BASE_URL + "user"
        
        var method: HTTPMethod {
            switch self {
            case .fetchRandom:
                return .post
            }
        }
        
        var path: String {
            switch self {
            case .fetchRandom:
                return "/update"
            }
        }
        
        // MARK: URLRequestConvertible
        func asURLRequest() throws -> URLRequest
        {
            let url = try Router.baseURLString.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.timeoutInterval = Constants.HEADER_TIME_OUT
            urlRequest.addValue(Constants.HEADER_CONTENT_TYPE, forHTTPHeaderField: Constants.KEY_CONTENT_TYPE)
            
            urlRequest.httpMethod = method.rawValue
            urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            
            switch self
            {
            case .fetchRandom(let parameters):
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
                break
            }
            
            print(urlRequest)
            
            return urlRequest
        }
    }
}
