//
//  RealmUtils.swift
//  UShift
//
//  Created by Christophe Danguien on 9/14/16.
//  Copyright © 2016 UShift. All rights reserved.
//

import UIKit
import RealmSwift

class RealmUtils
{
    //MARK: Constants
    let SCHEMA_VERSION:UInt64 = 6
    let REALM_IN_MEMORY:String = "StInventoryInMemoryRealm"
    let REALM_PERSISTENT:String = "StInventoryPersistentRealm.realm"
    
    //MARK: Shared Instance
    static let sharedInstance : RealmUtils =
        {
        let instance = RealmUtils()
        return instance
    }()
    
    //MARK: Local Variable
    
    var _ream_in_memory : Realm
    private var _realm_persistent : Realm
    
    //MARK: Init
    
    init()
    {
        // Init realm in memory
        _ream_in_memory = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: self.REALM_IN_MEMORY))
        
        // Init realm persistent
        var config:Realm.Configuration = Realm.Configuration()
        
        let configurationUrl:URL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(self.REALM_PERSISTENT)
        config.fileURL = configurationUrl
        config.readOnly = false
        config.schemaVersion = SCHEMA_VERSION
        
        // Open the Realm with the configuration
        _realm_persistent = try! Realm(configuration: config)
    }
    
    func getRealmInMemory() -> Realm?
    {
        // Open the Realm with the configuration
        let realm:Realm? = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: self.REALM_IN_MEMORY))
        
        return realm
    }

    func getRealmPersistentParallel() -> Realm?
    {
        var config:Realm.Configuration = Realm.Configuration()
        
        let configurationUrl:URL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(self.REALM_PERSISTENT)
        config.fileURL = configurationUrl
        config.readOnly = false
        config.schemaVersion = SCHEMA_VERSION
        
        // Open the Realm with the configuration
        let realm:Realm? = try! Realm(configuration: config)
        
        return realm
    }
    /*
    // Get the default Realm
    let realm = try! Realm()
    // You only need to do this once (per thread)
    
    // Add to the Realm inside a transaction
    try! realm.write {
    realm.add(author)
    }
 */
}
