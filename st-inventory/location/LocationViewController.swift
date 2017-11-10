//
//  LocationViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/08.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

import SVProgressHUD

class LocationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Constants
    let CELL_IDENTIFIER:String = "LocationTableViewCell"
    
    let SEGUE_SKIP:String = "SegueSkipToValidation"

    // MARK: - Outlets
    @IBOutlet weak var table_view:UITableView!
    
    @IBOutlet weak var view_fetching:UIView!
    
    // MARK: - Class attributes
    var _locations:Results<RLMLocation>?
    
    var _destination_id:Int?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.fetchLocations()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchLocations() -> Void
    {
        let completion:(Constants.CompletionStatus) -> Void = {
            
            [weak self] (status:Constants.CompletionStatus) -> Void in
            
            self?.releaseLock()
            
            self?.view_fetching.isHidden = true
            
            if status == Constants.CompletionStatus.Success
            {
                let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
                
                let predicate:NSPredicate = NSPredicate(format: "_destination_id = %i", argumentArray: [self?._destination_id as Any])
                
                self?._locations = realmMemory.objects(RLMLocation.self).filter(predicate)
                
                let count:Int = (self?._locations!.count)!

                if count > 0
                {
                    self?.table_view.reloadData()
                }
                else
                {
                    self?.performSegue(withIdentifier: (self?.SEGUE_SKIP)!, sender: nil)
                }
            }
            else
            {
                self?.performSegue(withIdentifier: (self?.SEGUE_SKIP)!, sender: nil)
            }
        }
        
        LocationApi.fetchAll(destinationId: self._destination_id!, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        return self.tryLock()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC:ValidationViewController? = segue.destination as? ValidationViewController
        if destinationVC != nil
        {
            destinationVC?._destination_id = self._destination_id!
            
            let indexPath:IndexPath? = self.table_view.indexPathForSelectedRow
            if indexPath != nil && segue.identifier != self.SEGUE_SKIP
            {
                let location:RLMLocation = self._locations![indexPath!.row]
                
                destinationVC?._location_code = location._code
            }
            
            if segue.identifier == self.SEGUE_SKIP && indexPath != nil
            {
                self.table_view.deselectRow(at: indexPath!, animated: true)
            }
        }
        
        self.releaseLockWDelay()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self._locations != nil
        {
            return self._locations!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:LocationTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as? LocationTableViewCell
        
        if cell == nil
        {
            cell = LocationTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_IDENTIFIER)
        }
        
        let location:RLMLocation = self._locations![indexPath.row]
        
        cell!.label_name!.text = location._name
        cell!.label_code!.text = location._code
        
        return cell!
    }
}
