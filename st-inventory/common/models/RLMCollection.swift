//
//  RLMCollection.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/21.
//Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import Foundation
import RealmSwift

class RLMCollection: Object
{
    @objc dynamic var _collection_id:String?
    @objc dynamic var _status_name:String = "IDLE"
    let _product_list:List<RLMProduct> = List<RLMProduct>()

    override static func primaryKey() -> String?
    {
        return "_collection_id"
    }

}
