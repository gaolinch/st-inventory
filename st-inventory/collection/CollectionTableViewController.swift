//
//  CollectionTableViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/21.
//  Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

import SVProgressHUD

class CollectionTableViewController: BaseTableTableViewController
{
    // MARK: - Constants
    let CELL_IDENTIFIER:String = "CollectionTableViewCell"
    
    static let SEGUE_LIST_PRODUCTS:String = "SegueCollectionProducts"
    
    // MARK: - Class attributes
    var _list_collections:Results<RLMCollection>?
    
    var _list_collection_change_listener:NotificationToken?
    
    var _list_collection_test_change_listener:NotificationToken?
    
    var _selected_index:IndexPath?
    
    var _list_collections_test:Results<RLMCollectionProduct>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self._list_collections = RealmUtils.sharedInstance.getRealmPersistentParallel()!.objects(RLMCollection.self)
        
        print("\(self._list_collections!.count)")
        
        self._list_collection_change_listener = self._list_collections!.observe
            {
                [weak self] (changes: RealmCollectionChange) in

                switch changes
                {
                case .initial:
                    print("intial")
                case .update(_, _, let insertions, let modifications):
                    // Query results have changed, so apply them to the UITableView
                    if insertions.count > 0
                    {
                        self?.tableView.beginUpdates()
                        self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        self?.tableView.endUpdates()
                    }
                    else if modifications.count > 0
                    {
                        self?.tableView.beginUpdates()
                        self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        self?.tableView.endUpdates()
                    }
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    print("\(error)")
                }
        }
        
        self._list_collections_test = RealmUtils.sharedInstance.getRealmPersistentParallel()!.objects(RLMCollectionProduct.self)
        self._list_collection_test_change_listener = self._list_collections_test!.observe
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
                        let indexInsertion:Int = insertions[0]
                        
                        let collectionProduct:RLMCollectionProduct = (self?._list_collections_test![indexInsertion])!
                        
                        var indexCollection:Int = 0
                        
                        for collection in (self?._list_collections)!
                        {
                            if collection._id == collectionProduct._collection_id
                            {
                                let indexPath:IndexPath = IndexPath(row: indexCollection, section: 0)
                                
                                self?.tableView.beginUpdates()
                                self?.tableView.reloadRows(at: [indexPath], with: .fade)
                                self?.tableView.endUpdates()
                                
                                break
                            }
                            
                            indexCollection += 1
                        }
                    }

                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    print("\(error)")
                }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    deinit
    {
        print("DEINIT COLLECTION_TABLE_VIEW_CONTOLLER")
    
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self._list_collections != nil
        {
            return self._list_collections!.count
        }
        else
        {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CollectionTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as? CollectionTableViewCell
        
        if cell == nil
        {
            cell = CollectionTableViewCell()
        }
        
        // Configure the cell...
        let collection:RLMCollection = self._list_collections![indexPath.row]
        
        cell!.label_collection_id!.text = collection._id
        
        if collection._status_id != nil
        {
            cell!.label_status.isHidden = false
            
            let collectionStatus:RLMCollectionStatus? = RealmUtils.sharedInstance.getRealmPersistentParallel()!.object(ofType: RLMCollectionStatus.self, forPrimaryKey: collection._status_id)
            
            if collectionStatus != nil
            {
                cell!.label_status.text = collectionStatus!._label
            }
            else
            {
                cell!.label_status.isHidden = true
            }
        }
        else
        {
            cell!.label_status.isHidden = true
        }

        let predicate:NSPredicate = NSPredicate(format: "\(Constants.PREDICATE_COLLECTION_ID) = %@", argumentArray: [collection._id])
        let numProduct:Int = RealmUtils.sharedInstance.getRealmPersistentParallel()!.objects(RLMCollectionProduct.self).filter(predicate).count
        
        var numProductStr:String = NSLocalizedString("collection_num_product", comment: "")
        numProductStr = numProductStr.replacingOccurrences(of: "NUM", with: "\(numProduct)")
        
        cell!.label_num_products.text = numProductStr
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.tryLock()
        {
            self._selected_index = indexPath
            
            self.fetchProducts()
        }
    }

    @IBAction func clickedRefresh(sender:UIBarButtonItem) -> Void
    {
        if self.tryLock()
        {
            SVProgressHUD.show(withStatus: NSLocalizedString("alert_refreshing", comment: ""))

            let completion:(Constants.CompletionStatus) -> Void = {
                
                [weak self] (status:Constants.CompletionStatus) -> Void in
                
                self?.releaseLockWDelay()
                
                SVProgressHUD.dismiss()
            }
            
            CollectionApi.fetchAll(completion: completion)
        }
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let viewController:CollectionProductsTableViewController? = segue.destination as? CollectionProductsTableViewController
        if viewController != nil
        {
            if self._selected_index != nil
            {
                let collection:RLMCollection = self._list_collections![self._selected_index!.row]
                viewController?._collection_id = collection._id
            }
        }
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
    
    private func fetchProducts() -> Void
    {
        SVProgressHUD.show(withStatus: NSLocalizedString("alert_loading", comment: ""))
        
        let completion:(Constants.CompletionStatus) -> Void = {
            
            [weak self] (status:Constants.CompletionStatus) -> Void in
            
            if status == Constants.CompletionStatus.Success
            {
                self?.performSegue(withIdentifier: CollectionTableViewController.SEGUE_LIST_PRODUCTS, sender: nil)
            }
            else
            {
                self?.showSimpleAlert(message: NSLocalizedString("collection_no_product_fetched", comment: ""))
            }
            
            self?.releaseLockWDelay()
            
            SVProgressHUD.dismiss()
        }
        
        let collection:RLMCollection = self._list_collections![self._selected_index!.row]
        
        CollectionApi.fetchProducts(collectionId: collection._id, completion: completion)
    }
}
