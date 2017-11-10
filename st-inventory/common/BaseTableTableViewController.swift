//
//  BaseTableTableViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/01.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

class BaseTableTableViewController: UITableViewController
{
    var _screen_lock:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    func tryLock() -> Bool
    {
        if self._screen_lock
        {
            return false
        }
        else
        {
            self._screen_lock = true
            
            return true
        }
    }
    
    @objc func releaseLock() -> Void
    {
        self._screen_lock = false
    }
    
    func releaseLockWDelay() -> Void
    {
        self.perform(#selector(BaseViewController.releaseLock), with: nil, afterDelay: 0.5)
    }
    
    // MARK: - Alert
    func showSimpleAlert(message: String) -> Void
    {
        let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action:UIAlertAction = UIAlertAction(title: NSLocalizedString("alert_ok", comment: ""), style: UIAlertActionStyle.default, handler:
        {
            [weak self] (alert: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            
            if self != nil
            {
                self?.releaseLock()
            }
        })
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showSimpleAlert(message: String, action:UIAlertAction) -> Void
    {
        let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
