//
//  RLMCollectionStatus.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/22.
//Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import Foundation
import RealmSwift

class RLMCollectionStatus: Object
{
    @objc dynamic var _id:Int = 0
    @objc dynamic var _code:String = ""
    @objc dynamic var _label:String = ""
    @objc dynamic var _is_active:Bool = true

    override static func primaryKey() -> String?
    {
        return "_id"
    }
}
