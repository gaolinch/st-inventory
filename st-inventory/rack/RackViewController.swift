//
//  RackViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/01.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class RackViewController: BaseScanViewController
{
    // MARK: - Constants
    let SEGUE_VALIDATION:String = "SegueValidationFromRack"

    // MARK: - Class attributes
    var _rack_number:String?
    
    var _destination_id:Int?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC:ValidationViewController? = segue.destination as? ValidationViewController
        if destinationVC != nil
        {
            destinationVC?._location_code = self._rack_number
            destinationVC?._destination_id = self._destination_id
        }
    }
    
    override func captureSessionMedataFound(data:String) -> Void
    {
        super.captureSessionMedataFound(data: data)

        self._rack_number = data
        
        self.saveRackMoveToValidation()
        
        self.releaseLockWDelay()
    }
    
    override func enteredTextfieldData(data:String) -> Void
    {
        self._rack_number = data
        
        self.saveRackMoveToValidation()
        
        self.releaseLockWDelay()
    }
    
    private func saveRackMoveToValidation() -> Void
    {
        let realm:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
        
        realm.beginWrite()
        
        let location:RLMLocation = RLMLocation()
        location._code = self._rack_number
        location._name = self._rack_number
        location._type = self._rack_number
        
        realm.add(location, update: true)
        
        try! realm.commitWrite()
        
        self.performSegue(withIdentifier: self.SEGUE_VALIDATION, sender: nil)
    }
}
