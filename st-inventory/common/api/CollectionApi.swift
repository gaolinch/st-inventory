//
//  CollectionApi.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/03.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import Alamofire

import RealmSwift

import SwiftyJSON

class CollectionApi: NSObject
{
    static func fetchAll(completion: ((Constants.CompletionStatus)->Void)!) -> Void
    {
        let routerRequest:URLRequestConvertible = Router.fetchAll()
        
        let dataRequest:DataRequest = Alamofire.request(routerRequest)
        dataRequest.responseJSON(completionHandler:
            {
                response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.data as Any)     // server data
                print(response.result)   // result of response serialization
                
                var isSuccess:Bool = false
                
                if response.data != nil
                {
                    let json:JSON? = JSON(response.result.value as Any)
                    print(json as Any)
                    if json != JSON.null
                    {
                       // if json![Constants.KEY_DATA].exists()
                       // {
                            let data:[JSON]? = json!.array
                            if data != nil
                            {
                                let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
                                
                                try! realm.write
                                {
                                    for collectionJson in data!
                                    {
                                        let collectionId:String? = collectionJson[Constants.KEY_COLLECTION_NAME].string
                                        
                                        let collection:RLMCollection = RLMCollection()
                                        collection._collection_id = collectionId!
                                        
                                        realm.add(collection, update: true)
                                    }
                                }
                                
                                defer
                                {
                                    isSuccess = true
                                    
                                    completion(Constants.CompletionStatus.Success)
                                }
                            }
                        //}
                    }
                }
                
                if !isSuccess
                {
                    completion(Constants.CompletionStatus.Failure)
                }
        })
    }
    
    enum Router: URLRequestConvertible
    {
        case fetchAll()
        
        static let baseURLString = Constants.BASE_URL + ""
        
        var method: HTTPMethod {
            switch self {
            case .fetchAll:
                return .get
            }
        }

        var path: String {
            switch self {
            case .fetchAll:
                return "/admin/collections"
            }
        }
        
        // MARK: URLRequestConvertible
        func asURLRequest() throws -> URLRequest
        {
            let url = try Router.baseURLString.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.timeoutInterval = Constants.HEADER_TIME_OUT
            urlRequest.addValue(Constants.HEADER_CONTENT_TYPE, forHTTPHeaderField: Constants.KEY_CONTENT_TYPE)
            urlRequest.addValue(Constants.HEADER_APP_NAME, forHTTPHeaderField: Constants.KEY_APP_NAME)
            urlRequest.addValue(Constants.HEADER_APP_TOKEN_COLLECTION, forHTTPHeaderField: Constants.KEY_APP_TOKEN_COLLECTION)
            
            urlRequest.httpMethod = method.rawValue
            urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            
            switch self
            {
            case .fetchAll():
                urlRequest.url = URL(string: "https://temptest.styletribute.com/admin/collections")
                break
            }
            
            print(urlRequest)
            
            return urlRequest
        }
    }
}
