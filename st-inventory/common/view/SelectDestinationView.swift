//
//  SelectReasonView.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/01.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class SelectDestinationView: UIView, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Constants
    let CELL_IDENTIFIER:String = "SelectDestLocTableViewCell"

    // MARK: - Outlets
    @IBOutlet weak var table_view:UITableView!
    
    @IBOutlet weak var button_cancel:UIButton!
    @IBOutlet weak var button_select:UIButton!
    
    // MARK: - Class attributes
    var _destinations:Results<RLMDestination>?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func willMove(toSuperview newSuperview: UIView?)
    {
        super.willMove(toSuperview: newSuperview)
        
        let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
        
        self._destinations = realmMemory.objects(RLMDestination.self)
        
        let nib:UINib = UINib(nibName: CELL_IDENTIFIER, bundle: nil)
        self.table_view.register(nib, forCellReuseIdentifier: CELL_IDENTIFIER)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self._destinations!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:SelectDestLocTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as? SelectDestLocTableViewCell
        
        if cell == nil
        {
            cell = SelectDestLocTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_IDENTIFIER)
        }
        
        let destination:RLMDestination = self._destinations![indexPath.row]
        
        cell!.label_name!.text = destination._type_name
        cell!.label_type!.text = destination._code
        
        return cell!
    }
    
    func getDestinationSelected() -> Int?
    {
        let indexPath:IndexPath? = self.table_view.indexPathForSelectedRow
        if indexPath != nil
        {
            let destination:RLMDestination = self._destinations![indexPath!.row]
            
            return destination._destination_id
        }
        else
        {
            return nil
        }
    }
}
