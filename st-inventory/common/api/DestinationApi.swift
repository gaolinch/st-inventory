//
//  DestinationApi.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/03.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import Alamofire

import RealmSwift

import SwiftyJSON

class DestinationApi: NSObject
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
                        if json![Constants.KEY_DATA].exists()
                        {
                            let data:[JSON]? = json![Constants.KEY_DATA].array
                            if data != nil
                            {
                                let realm:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
                                
                                realm.beginWrite()

                                for destinationJson in data!
                                {
                                    let destinationId:Int? = destinationJson[Constants.KEY_DESTINATION_ID].int
                                    let code:String? = destinationJson[Constants.KEY_CODE].string
                                    
                                    let destinationType:JSON? = JSON(destinationJson[Constants.KEY_DESTINATION_TYPE].dictionaryObject as Any)
                                    
                                    if destinationType != JSON.null
                                    {
                                        let typeId:Int? = destinationType![Constants.KEY_DESTINATION_TYPE_ID].int
                                        let typeName:String? = destinationType![Constants.KEY_NAME].string
                                        
                                        if destinationId != nil && code != nil && typeId != nil && typeName != nil
                                        {
                                            let destination:RLMDestination = RLMDestination()
                                            destination._destination_id = destinationId!
                                            destination._code = code!
                                            destination._type_id = typeId!
                                            destination._type_name = typeName!
                                            
                                            var createdDateInt:Int? = destinationJson[Constants.KEY_CREATED_DATE].int
                                            if createdDateInt != nil
                                            {
                                                createdDateInt = createdDateInt! / 1000

                                                destination._created_date = Date(timeIntervalSince1970: TimeInterval(createdDateInt!))
                                            }
                                            
                                            realm.add(destination)
                                        }
                                    }
                                }
                                
                                try! realm.commitWrite()
                                
                                isSuccess = true
                                
                                completion(Constants.CompletionStatus.Success)
                            }
                        }
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
        
        static let baseURLString = Constants.BASE_URL + "/inventory"
        
        var method: HTTPMethod {
            switch self {
            case .fetchAll:
                return .get
            }
        }

        var path: String {
            switch self {
            case .fetchAll:
                return "/destinations?size=20&page=1&sortCriteria=code-DESC&q=code-DEST"
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
            urlRequest.addValue(Constants.HEADER_APP_TOKEN, forHTTPHeaderField: Constants.KEY_APP_TOKEN)
            
            urlRequest.httpMethod = method.rawValue
            urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            
            switch self
            {
            case .fetchAll():
                urlRequest.url = URL(string: "https://temptest.styletribute.com/inventory/destinations?size=30&page=1&sortCriteria=code-DESC&q=code-DEST")
                break
            }
            
            print(urlRequest)
            
            return urlRequest
        }
    }
}
