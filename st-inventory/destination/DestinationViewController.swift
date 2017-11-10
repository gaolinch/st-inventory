//
//  DestinationViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/08.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class DestinationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Constants
    let CELL_IDENTIFIER:String = "DestinationTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var table_view:UITableView!

    // MARK: - Class attributes
    var _destinations:Results<RLMDestination>?
    
    var _destination_id:Int?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
        self._destinations = realmMemory.objects(RLMDestination.self)
    }

    @IBAction func clickedUnwindToDestination(_ segue: UIStoryboardSegue)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickedBack(sender:UIBarButtonItem) -> Void
    {
        if self.tryLock()
        {
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if self.tryLock()
        {
            self.releaseLockWDelay()

            if self._destination_id == nil
            {
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
            self.releaseLockWDelay()

            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC:RackViewController? = segue.destination as? RackViewController
        if destinationVC != nil
        {
            destinationVC?._destination_id = self._destination_id!
        }
        else
        {
            let locationVC:LocationViewController? = segue.destination as? LocationViewController
            if locationVC != nil
            {
                locationVC?._destination_id = self._destination_id!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self._destinations!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:DestinationTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as? DestinationTableViewCell
        
        if cell == nil
        {
            cell = DestinationTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_IDENTIFIER)
        }
        
        let destination:RLMDestination = self._destinations![indexPath.row]
        
        print(destination)
        
        cell!.label_name!.text = destination._type_name
        cell!.label_type!.text = destination._code
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let destination:RLMDestination = self._destinations![indexPath.row]
        
        self._destination_id = destination._destination_id
        
        return indexPath
    }
}
