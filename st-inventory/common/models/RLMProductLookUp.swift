//
//  RLMProductLookUp.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/05.
//Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import Foundation
import RealmSwift

class RLMProductLookUp: Object
{
    @objc dynamic var _sku:String?
    @objc dynamic var _name:String?

    @objc dynamic var _status_name:String?
    @objc dynamic var _status_comment:String?
    @objc dynamic var _creator:String?
    
    @objc dynamic var _created_date:Date?

    @objc dynamic var _location_code:String?
    @objc dynamic var _location_type:String?
    @objc dynamic var _location_name:String?

    @objc dynamic var _destination_code:String?
    @objc dynamic var _destination_name:String?
}
