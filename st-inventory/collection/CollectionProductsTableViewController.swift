//
//  CollectionProductsTableViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/21.
//  Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class CollectionProductsTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Constants
    let CELL_IDENTIFIER:String = "CollectionProductTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var table_view:UITableView!
    
    @IBOutlet weak var button_status:UIButton!
    
    // MARK: - Class attribute
    var _collection_id:String?
    
    var _list_products:Results<RLMCollectionProduct>?
    
    var _list_collection_change_listener:NotificationToken?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
        
        var predicate:NSPredicate = NSPredicate(format: "\(Constants.PREDICATE_COLLECTION_ID) = %@", argumentArray: [self._collection_id!])
        
        self._list_products = realm.objects(RLMCollectionProduct.self).filter(predicate)
        
        if self._list_products != nil
        {
            print("\(self._list_products!.count)")
            self._list_collection_change_listener = self._list_products!.observe
            {
                [weak self] (changes: RealmCollectionChange) in
                
                switch changes
                {
                case .initial:
                    print("intial")
                case .update(_, _, let insertions, _):
                    // Query results have changed, so apply them to the UITableView
                    if insertions.count > 0
                    {
                        self?.table_view.beginUpdates()
                        self?.table_view.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .fade)
                        self?.table_view.endUpdates()
                    }
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    print("\(error)")
                }
            }
        }
        
        // Status
        let rlmCollection:RLMCollection? = realm.object(ofType: RLMCollection.self, forPrimaryKey: self._collection_id!)
        if rlmCollection != nil
        {
            let collectionStatus:RLMCollectionStatus? = RealmUtils.sharedInstance.getRealmPersistentParallel()!.object(ofType: RLMCollectionStatus.self, forPrimaryKey: rlmCollection!._status_id)
            
            if collectionStatus != nil
            {
                self.button_status.setTitle(collectionStatus!._label, for: UIControlState.normal)
            }
        }
    }
    
    deinit
    {
        print("DEINIT COLLECTION_PRODUCTS_TABLE_VIEW_CONTOLLER")
        
        self._list_collection_change_listener!.invalidate()
        self._list_collection_change_listener = nil
    }
    
    @IBAction func clickedBack(sender:UIBarButtonItem) -> Void
    {
        if self.tryLock()
        {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self._list_products != nil
        {
            return self._list_products!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CollectionProductTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as? CollectionProductTableViewCell
        
        if cell == nil
        {
            cell = CollectionProductTableViewCell()
        }
        
        let product:RLMCollectionProduct = self._list_products![indexPath.row]
        cell!.label_sku.text = product._sku
        
        return cell!
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let viewController:CollectionAddProductViewController? = segue.destination as? CollectionAddProductViewController
        if viewController != nil
        {
            viewController?._collection_id = self._collection_id
        }
        
        self.releaseLockWDelay()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if self.tryLock()
        {
            return true
        }
        else
        {
            return false
        }
    }
}
