//
//  EventApi.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/10/30.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//
import Alamofire

import SwiftyJSON

import RealmSwift

class ProductApi: NSObject
{
    static func findProduct(sku:String, completion: ((Constants.CompletionStatus)->Void)!) -> Void
    {
        let routerRequest:URLRequestConvertible = Router.findProduct(sku: sku)
        
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
                        let productsLookUp:[JSON]? = json.array
                        print(json)
                        
                        if productsLookUp != nil
                        {
                            let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
                            
                            // Remove previous products looked up
                            realmMemory.beginWrite()
                            
                            let previousLookedUpProducts:Results = realmMemory.objects(RLMProductLookUp.self)
                            
                            realmMemory.delete(previousLookedUpProducts)
                            
                            try! realmMemory.commitWrite()
                            
                            // Add new products
                            realmMemory.beginWrite()

                            for product in productsLookUp!
                            {
                                let sku:String? = product[Constants.KEY_SKU].string
                                let creator:String? = product[Constants.KEY_CREATE_BY].string
                                let statusComment:String? = product[Constants.KEY_STATUS_COMMENT].string
                                var creationDate:Int? = product[Constants.KEY_CREATED_DATE].int

                                let status:JSON? = JSON(product[Constants.KEY_STATUS].dictionaryObject as Any)
                                let statusName:String? = status?[Constants.KEY_NAME].string

                                let locationJson:JSON? = JSON(product[Constants.KEY_LOCATION].dictionaryObject as Any)
                                let locationCode:String? = locationJson?[Constants.KEY_CODE].string
                                let locationType:String? = locationJson?[Constants.KEY_TYPE].string
                                let locationName:String? = locationJson?[Constants.KEY_NAME].string

                                let destinationJson:JSON? = JSON(locationJson![Constants.KEY_DESTINATION].dictionaryObject as Any)
                                let destinationCode:String? = destinationJson?[Constants.KEY_CODE].string
                                
                                let destinationTypeJson:JSON? = JSON(destinationJson![Constants.KEY_DESTINATION_TYPE].dictionaryObject as Any)
                                let destinationName:String? = destinationTypeJson?[Constants.KEY_NAME].string
                                
                                if sku != nil && locationName != nil && destinationName != nil
                                {
                                    let productLookUp:RLMProductLookUp = RLMProductLookUp()
                                    productLookUp._sku = sku
                                    productLookUp._creator = creator
                                    productLookUp._status_name = statusName
                                    productLookUp._status_comment = statusComment
                                    productLookUp._location_code = locationCode
                                    productLookUp._location_name = locationName
                                    productLookUp._location_type = locationType
                                    productLookUp._destination_name = destinationName
                                    productLookUp._destination_code = destinationCode
                                    
                                    if creationDate != nil
                                    {
                                        creationDate = creationDate! / 1000
                                        
                                        productLookUp._created_date = Date(timeIntervalSince1970: TimeInterval(creationDate!))
                                    }
                                    
                                    realmMemory.add(productLookUp)
                                }
                            }
                            
                            try! realmMemory.commitWrite()
                            
                            let productNum:Int = realmMemory.objects(RLMProductLookUp.self).filter(NSPredicate(format: "_sku = %@", argumentArray: [sku])).count
                            
                            if productNum > 0
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
    
    static func fetchExtraInfo(sku:String, completion: ((Constants.CompletionStatus)->Void)!) -> Void
    {
        let routerRequest:URLRequestConvertible = Router.fetchExtraInfo(sku: sku)
        
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
                        let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
                        
                        // Remove previous products looked up
                        realmMemory.beginWrite()
                        
                        let product:RLMProductLookUp = realmMemory.object(ofType: RLMProductLookUp.self, forPrimaryKey: sku)!
                        
                        product._name = json[Constants.KEY_NAME].string
                        
                        try! realmMemory.commitWrite()
                        
                        isSuccess = true
                        
                        completion(Constants.CompletionStatus.Success)
                    }
                }
                
                if !isSuccess
                {
                    completion(Constants.CompletionStatus.Failure)
                }
        })
    }
    
    static func submit(parameters:Parameters, completion: ((Constants.CompletionStatus)->Void)!) -> Void
    {
        let routerRequest:URLRequestConvertible = Router.submit(parameters: parameters)
        
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
        case findProduct(sku:String)
        case fetchExtraInfo(sku:String)
        case submit(parameters:Parameters)
        
        static let baseURLString = Constants.BASE_URL

        var method: HTTPMethod
        {
            switch self
            {
            case .findProduct:
                return .get
            case .fetchExtraInfo:
                return .get
            case .submit:
                return .post
            }
        }
        
        var path: String
        {
            switch self
            {
            case .findProduct(let sku):
                return "/inventory/event/sku/\(sku)"
            case .fetchExtraInfo(let sku):
                return "/admin/product/sku/\(sku)"
            case .submit:
                return "/inventory/batch"
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
