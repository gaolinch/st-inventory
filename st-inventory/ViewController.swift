//
//  ViewController.swift
//  st-inventory
//
//  Created by Philippe Benedetti on 17/10/17.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import Alamofire

import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ViewController.checkPhilApi();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  
    
    
    static func checkPhilApi() -> Void
    {
        let routerRequest:URLRequestConvertible = Router.checkPhilApi()
        
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
                    let json:JSON = JSON(response.result.value as Any)
                    print(json)
                    if json != nil
                    {
                        if json["yeah"].exists()
                        {
                            let yeah:String = json["yeah"].stringValue
                            let base:String = json["base"].stringValue
                            
                            print(yeah)
                            print(base)
                        }
                    }
                }
        })
    }
    
    enum Router: URLRequestConvertible
    {
        case getRandom()
        case checkPhilApi()
        
        static let baseURLString = Constants.BASE_URL
        
        var method: HTTPMethod {
            switch self {
            case .getRandom:
                return .get
            case .checkPhilApi:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .getRandom:
                return "/random_subject"
            case .checkPhilApi:
                return "/inventory/statuses"
            }
        }
        
        // MARK: URLRequestConvertible
        func asURLRequest() throws -> URLRequest
        {
            let url = try Router.baseURLString.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.timeoutInterval = Constants.HEADER_TIME_OUT
            //urlRequest.addValue(Constants.HEADER_CONTENT_TYPE, forHTTPHeaderField: Constants.KEY_CONTENT_TYPE)
            urlRequest.addValue(Constants.HEADER_APP_NAME, forHTTPHeaderField: Constants.KEY_APP_NAME)
            urlRequest.addValue(Constants.HEADER_APP_TOKEN, forHTTPHeaderField: Constants.KEY_APP_TOKEN)
            
            urlRequest.httpMethod = method.rawValue
            urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            
            print(urlRequest)
            
            return urlRequest
        }
    }

}

