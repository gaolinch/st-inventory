//
//  RLMProduct.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/10/30.
//Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import Foundation
import RealmSwift

class RLMProduct: Object
{
    @objc dynamic var _sku:String?
    @objc dynamic var _status_name:String = "PS_STATUS_CHANGE"
    @objc dynamic var _status_comment:String = "for 1 min"
    @objc dynamic var _creator:String = "mobile_app"
    @objc dynamic var _date_added:Date = Date()
    
    @objc dynamic var _destination_id:Int = 0
    @objc dynamic var _location_code:String?
    
    @objc dynamic var _sent:Bool = false

    override static func primaryKey() -> String?
    {
        return "_sku"
    }
    
    func getAsDictionary() -> [String: Any]
    {
        var dictionary:[String:Any] = [:]
        dictionary[Constants.KEY_SKU] = self._sku
        dictionary[Constants.KEY_CREATE_BY] = self._creator
        dictionary[Constants.KEY_STATUS_NAME] = self._status_name
        dictionary[Constants.KEY_STATUS_COMMENT] = self._status_comment
        if self._location_code != nil
        {
            dictionary[Constants.KEY_LOCATION_CODE] = self._location_code
        }
        
        return dictionary
    }
}
