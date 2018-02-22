//
//  RLMCollectionProduct.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/22.
//Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import Foundation
import RealmSwift

class RLMCollectionProduct: Object
{
    @objc dynamic var _sku:String = ""
    @objc dynamic var _collection_id:String = ""
    
    override static func primaryKey() -> String?
    {
        return "_sku"
    }
}
