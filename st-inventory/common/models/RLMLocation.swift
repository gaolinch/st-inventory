//
//  RLMLocation.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/03.
//Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import Foundation
import RealmSwift

class RLMLocation: Object
{
    @objc dynamic var _code:String?
    @objc dynamic var _name:String?
    @objc dynamic var _type:String?
    @objc dynamic var _destination_id:Int = 0
    
    override static func primaryKey() -> String?
    {
        return "_code"
    }
}
