//
//  Constants.swift
//  st-inventory
//
//  Created by Philippe Benedetti on 22/10/17.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//
import Foundation

struct Constants
{
    static let BASE_URL:String = "https://temptest.styletribute.com"
    static let HEADER_TIME_OUT:TimeInterval = TimeInterval(500)
    
    static let KEY_CONTENT_TYPE:String = "Content-Type"
    static let HEADER_CONTENT_TYPE:String = "application/json"
    
    static let KEY_APP_NAME:String = "x-styletribute-verification"
    static let HEADER_APP_NAME:String = "inventoryApp"
    
    static let KEY_APP_TOKEN:String = "x-styletribute-token"
    static let HEADER_APP_TOKEN:String = "style123"
    
    
    static let KEY_APP_TOKEN_COLLECTION:String = "X-Styletribute-Admin-Token"
    static let HEADER_APP_TOKEN_COLLECTION:String = "schnitzelbrot"
    
    // MARK: - Notifications
    static let NOTIFICATION_UPDATE_PRODUCT_LIST:NSNotification.Name = NSNotification.Name(rawValue: "NOTIFICATION_UPDATE_PRODUCT_LIST")
    
    // MARK: - Keys
    static let KEY_DATA:String = "data"
    
    
    static let KEY_COLLECTION_ID:String = "collectionId"
    static let KEY_COLLECTION_NAME:String = "collectionNo"
    
    static let KEY_PRODUCTS:String = "products"
    
    static let KEY_DESTINATION_ID:String = "destinationId"
    static let KEY_CODE:String = "code"
    static let KEY_DESTINATION_TYPE:String = "destinationType"
    static let KEY_DESTINATION_TYPE_ID:String = "destinationTypeId"
    static let KEY_NAME:String = "name"
    static let KEY_CREATED_DATE:String = "createdDate"
    
    static let KEY_LOCATION_ID:String = "locationId"
    static let KEY_TYPE:String = "type"
    static let KEY_DESTINATION:String = "destination"
    
    static let KEY_STATUS:String = "status"
    static let KEY_LOCATION:String = "location"
    
    static let KEY_PRODUCT_ID:String = "productId"
    static let KEY_SKU:String = "sku"
    static let KEY_LOCATION_CODE:String = "locationCode"
    static let KEY_CREATE_BY:String = "createdBy"
    static let KEY_STATUS_NAME:String = "statusName"
    static let KEY_STATUS_COMMENT:String = "statusComment"
    
    static let KEY_ID:String = "id"
    static let KEY_LABEL:String = "label"
    
    static let KEY_ACTIVE:String = "active"

    static let KEY_METHOD:String = "method"
    static let KEY_CONTENT:String = "content"
    
    static let VALUE_TYPE:String = "Event"
    static let VALUE_METHOD:String = "create"
    
    static let PREDICATE_ID:String = "_id"
    static let PREDICATE_COLLECTION_ID:String = "_collection_id"
    
    // MARK: - Api Status Back
    enum CompletionStatus
    {
        case NoInternet
        case Success
        case Failure
    }
}
