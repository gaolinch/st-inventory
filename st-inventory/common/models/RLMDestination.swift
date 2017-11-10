//
//  RLMDestination.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/03.
//Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import Foundation
import RealmSwift

class RLMDestination: Object
{
    @objc dynamic var _destination_id:Int = 0
    @objc dynamic var _code:String?
    @objc dynamic var _type_id:Int = 0
    @objc dynamic var _type_name:String?
    @objc dynamic var _created_date:Date?
    
    override static func primaryKey() -> String?
    {
        return "_destination_id"
    }
}
