//
//  Constants.swift
//  st-inventory
//
//  Created by Philippe Benedetti on 22/10/17.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import Foundation

struct Constants {
    static let BASE_URL = "https://ce6919or4j.execute-api.ap-southeast-1.amazonaws.com/dev"
    static let HEADER_TIME_OUT = TimeInterval(500)
    
    static let KEY_CONTENT_TYPE = "Content-Type"
    static let HEADER_CONTENT_TYPE = "application/json"
    
    static let KEY_APP_NAME = "x-styletribute-verification"
    static let HEADER_APP_NAME = "inventoryApp"
    
    static let KEY_APP_TOKEN = "x-styletribute-token"
    static let HEADER_APP_TOKEN = "style123"
}
