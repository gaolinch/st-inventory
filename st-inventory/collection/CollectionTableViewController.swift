//
//  CollectionTableViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/21.
//  Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class CollectionTableViewController: BaseTableTableViewController
{
    
    // MARK: - Constants
    let CELL_IDENTIFIER:String = "CollectionTableViewCell"
    
    // MARK: - Class attributes
    var _list_collections:Results<RLMCollection>?
    
    var _list_collection_change_listener:NotificationToken?
    
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell!.label_collection_id!.text = collection._collection_id!
        cell!.label_status.text = "dsadasdas"
        
        return cell!
    }

    @IBAction func clickedAdd(sender:UIBarButtonItem) -> Void
    {
        if self.tryLock()
        {
            self.releaseLockWDelay()
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
            let indexPath:IndexPath?  = self.tableView.indexPathForSelectedRow
            if indexPath != nil
            {
                let collection:RLMCollection = self._list_collections![indexPath!.row]
                viewController?._collection_id = collection._collection_id
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
}
