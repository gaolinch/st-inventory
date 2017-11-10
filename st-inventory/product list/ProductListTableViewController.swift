//
//  ProductListTableViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/10/31.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class ProductListTableViewController: BaseTableTableViewController
{
    // Class Attributes
    var _products:Results<RLMProduct>?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!

        self._products = realm.objects(RLMProduct.self).filter(NSPredicate(format: "_sent = false")).sorted(byKeyPath: "_date_added")

        print(self._products as Any)
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
        // #warning Incomplete implementation, return the number of rows
        return self._products!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCell")
        }
        
        let product:RLMProduct = self._products![indexPath.row]
        
        cell!.textLabel!.text = product._sku!
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Update the profile from the restaurant
        let alertController:UIAlertController = UIAlertController(title: "Product", message: "Do you want to delete this product from your list?", preferredStyle: UIAlertControllerStyle.alert)
        
        let actionCancel:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {
            (alert: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(actionCancel)
        
        let actionConfirm:UIAlertAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {
            [weak self] (alert: UIAlertAction!) in
            
            let product:RLMProduct = (self?._products![indexPath.row])!

            let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
            
            realm.beginWrite()
            realm.delete(product)
            try! realm.commitWrite()
            
            self?._products = realm.objects(RLMProduct.self).filter(NSPredicate(format: "_sent = false")).sorted(byKeyPath: "_date_added")
            
            self?.tableView.reloadData()
            
            NotificationCenter.default.post(name: Constants.NOTIFICATION_UPDATE_PRODUCT_LIST, object: nil)
            
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(actionConfirm)
        
        self.present(alertController, animated: true, completion: {
            [weak self] in
            
            tableView.deselectRow(at: indexPath, animated: true)

            self?.releaseLock()
        })
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!

            let product:RLMProduct = self._products![indexPath.row]
            
            realm.beginWrite()
            realm.delete(product)
            try! realm.commitWrite()

            self._products = realm.objects(RLMProduct.self).sorted(byKeyPath: "_date_added")
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
            
            NotificationCenter.default.post(name: Constants.NOTIFICATION_UPDATE_PRODUCT_LIST, object: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
