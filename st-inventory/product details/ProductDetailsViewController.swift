//
//  ProductDetailsViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/09.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class ProductDetailsViewController: BaseViewController
{
    // MARK: - Constants
    let SEGUE_SELECT_DESTINATION:String = "SegueProductDetailsToDestination"
    
    // MARK: - Outlets
    @IBOutlet weak var label_product_name:UILabel!

    @IBOutlet weak var label_destination_name:UILabel!
    @IBOutlet weak var label_destination_code:UILabel!
    
    @IBOutlet weak var label_location_name:UILabel!
    @IBOutlet weak var label_location_code:UILabel!
    @IBOutlet weak var label_location_type:UILabel!
    
    // MARK: - Class attributes
    var _product_sku:String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let realm:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
        
        let sku:String = self._product_sku!
        
        let productLookUp:RLMProductLookUp! = realm.objects(RLMProductLookUp.self).filter(NSPredicate(format: "_sku = %@", argumentArray: [sku])).first!
        
        self.label_product_name.text = productLookUp._name

        self.label_destination_name.text = productLookUp._destination_name
        self.label_destination_code.text = productLookUp._destination_code
        
        self.label_location_name.text = productLookUp._location_name
        self.label_location_code.text = productLookUp._location_code
        self.label_location_type.text = productLookUp._location_type
        // Do any additional setup after loading the view.
        self.title = self._product_sku
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        return self.tryLock()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC:DestinationViewController? = segue.destination as? DestinationViewController
        if destinationVC != nil
        {
            // Create a product in DB
            let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
            realm.beginWrite()
            
            let product:RLMProduct = RLMProduct()
            product._sku = self._product_sku!
            
            realm.add(product, update: true)
            
            try! realm.commitWrite()
        }
        
        self.releaseLockWDelay()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
