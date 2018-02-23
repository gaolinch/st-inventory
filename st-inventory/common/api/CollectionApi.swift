//
//  CollectionApi.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/22.
//  Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import UIKit

import Alamofire

import RealmSwift

import SwiftyJSON

class CollectionApi: NSObject
{
    static func fetchAll(completion: ((Constants.CompletionStatus)->Void)?) -> Void
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
                                    collection._id = collectionId!
                                    
                                    let statusJson:JSON? = JSON(collectionJson[Constants.KEY_STATUS].dictionaryObject as Any)
                                    if statusJson != JSON.null
                                    {
                                        let rlmCollectionStatus:RLMCollectionStatus = RLMCollectionStatus()
                                        rlmCollectionStatus._id = statusJson![Constants.KEY_ID].stringValue
                                        rlmCollectionStatus._label = statusJson![Constants.KEY_LABEL].stringValue
                                        rlmCollectionStatus._code = statusJson![Constants.KEY_CODE].stringValue
                                        
                                        realm.add(rlmCollectionStatus, update: true)
                                        
                                        collection._status_id = rlmCollectionStatus._id
                                    }
                                    
                                    realm.add(collection, update: true)
                                }
                            }
                            
                            defer
                            {
                                isSuccess = true
                                
                                if completion != nil
                                {
                                    completion!(Constants.CompletionStatus.Success)
                                }
                            }
                        }
                    }
                }
                
                if !isSuccess && completion != nil
                {
                    completion!(Constants.CompletionStatus.Failure)
                }
        })
    }
    
    static func fetchProducts(collectionId:String, completion: @escaping (Constants.CompletionStatus)->Void) -> Void
    {
        let routerRequest:URLRequestConvertible = Router.fetchProducts(collectionId: collectionId)
        
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
                        let data:[JSON]? = json![Constants.KEY_PRODUCTS].array
                        if data != nil
                        {
                            let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
                            
                            try! realm.write
                            {
                                for productJson in data!
                                {
                                    print(productJson)
                                    
                                    let sku:String? = productJson[Constants.KEY_SKU].string
                                    if sku != nil
                                    {
                                        let collectionProduct:RLMCollectionProduct = RLMCollectionProduct()
                                        collectionProduct._sku = sku!
                                        collectionProduct._collection_id = collectionId
                                        
                                        realm.add(collectionProduct, update: true)
                                    }
                                }
                            }
                            
                            defer
                            {
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
    
    static func addProduct(sku:String, collectionId:String, completion: @escaping (Constants.CompletionStatus)->Void) -> Void
    {
        let routerRequest:URLRequestConvertible = Router.addProduct(sku: sku, collectionId: collectionId)
        
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
                        let data:JSON? = json!
                        if data != nil
                        {
                            let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
                            
                            try! realm.write
                            {
                                let rlmCollectionProduct:RLMCollectionProduct = RLMCollectionProduct()
                                rlmCollectionProduct._sku = sku
                                rlmCollectionProduct._collection_id = collectionId
                                
                                realm.add(rlmCollectionProduct, update: true)
                            }
                            
                            defer
                            {
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
    
    static func fetchStatuses() -> Void
    {
        let routerRequest:URLRequestConvertible = Router.fetchStatuses()
        
        let dataRequest:DataRequest = Alamofire.request(routerRequest)
        dataRequest.responseJSON(completionHandler:
            {
                response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.data as Any)     // server data
                print(response.result)   // result of response serialization
                
                if response.data != nil
                {
                    let json:JSON? = JSON(response.result.value as Any)
                    print(json as Any)
                    if json != JSON.null
                    {
                        let data:[JSON]? = json![Constants.KEY_PRODUCTS].array
                        if data != nil
                        {
                            let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
                            
                            try! realm.write
                            {

                            }
                        }
                    }
                }
        })
    }
    
    enum Router: URLRequestConvertible
    {
        case fetchAll()
        case fetchProducts(collectionId:String)
        case addProduct(sku:String, collectionId:String)
        case fetchStatuses()
        
        //static let baseURLString = Constants.BASE_URL + ""
        static let baseURLString = "https://api.styletribute.com" + ""
        
        var method: HTTPMethod {
            switch self {
            case .fetchAll:
                return .get
            case .fetchProducts(_):
                return .get
            case .addProduct(_, _):
                return .post
            case .fetchStatuses:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .fetchAll:
                return "/admin/collections"
            case .fetchProducts(let collectionId):
                return "/admin/collection/\(collectionId)"
            case .addProduct(let sku, let collectionId):
                return "/admin/collection/assign/\(sku)/\(collectionId)"
            case .fetchStatuses:
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

            print(urlRequest)
            
            return urlRequest
        }
    }
}
