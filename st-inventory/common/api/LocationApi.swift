//
//  RackApi.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/10/30.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//
import Alamofire

import SwiftyJSON

import RealmSwift

class LocationApi: NSObject
{
    static func fetchAll(destinationId:Int, completion: ((Constants.CompletionStatus)->Void)!) -> Void
    {
        let routerRequest:URLRequestConvertible = Router.fetchAll(destinationId: destinationId)
        
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
                    print(response.data as Any)

                    let json:JSON = JSON(response.result.value as Any)
                    print(json)
                    if json != JSON.null
                    {
                        let locations:[JSON]? = json.array
                        print(json)

                        if locations != nil
                        {
                            let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!

                            realmMemory.beginWrite()

                            for locationJson in locations!
                            {
                                let code:String? = locationJson[Constants.KEY_CODE].string
                                let name:String? = locationJson[Constants.KEY_NAME].string
                                let type:String? = locationJson[Constants.KEY_TYPE].string
                                
                                let destinationJson:JSON? = JSON(locationJson[Constants.KEY_DESTINATION].dictionaryObject as Any)
                                let destinationId:Int? = destinationJson?[Constants.KEY_DESTINATION_ID].int
                                
                                if code != nil && name != nil && type != nil && destinationId != nil
                                {
                                    let location:RLMLocation = RLMLocation()
                                    location._name = name!
                                    location._type = type!
                                    location._code = code!
                                    location._destination_id = destinationId!
                                    
                                    realmMemory.add(location, update: true)
                                }
                            }
                            
                            try! realmMemory.commitWrite()
                            
                            isSuccess = true

                            completion(Constants.CompletionStatus.Success)
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
        case fetchAll(destinationId:Int)
        
        static let baseURLString = Constants.BASE_URL + "/inventory/locations"
        
        var method: HTTPMethod
        {
            switch self
            {
            case .fetchAll:
                return .get
            }
        }
        
        var path: String
        {
            switch self
            {
            case .fetchAll(let destinationId):
                return "/destinationId/\(destinationId)"
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
            
            print(urlRequest)
            
            return urlRequest
        }
    }
}
