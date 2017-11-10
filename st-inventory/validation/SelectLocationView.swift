//
//  SelectLocationView.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/04.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class SelectLocationView: UIView, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Constants
    let CELL_IDENTIFIER:String = "SelectDestLocTableViewCell"

    // MARK: - Outlets
    @IBOutlet weak var table_view:UITableView!
    
    @IBOutlet weak var button_cancel:UIButton!
    @IBOutlet weak var button_select:UIButton!
    
    // MARK: - Class attributes
    var _locations:Results<RLMLocation>?
    
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
        
        self._locations = realmMemory.objects(RLMLocation.self)
        
        let nib:UINib = UINib(nibName: CELL_IDENTIFIER, bundle: nil)
        self.table_view.register(nib, forCellReuseIdentifier: CELL_IDENTIFIER)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self._locations!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:SelectDestLocTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as? SelectDestLocTableViewCell
        
        if cell == nil
        {
            cell = SelectDestLocTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_IDENTIFIER)
        }
        
        let location:RLMLocation = self._locations![indexPath.row]
        
        cell!.label_name!.text = location._name
        cell!.label_type!.text = location._type
        
        return cell!
    }
    
    func getLocationSelected() -> String?
    {
        let indexPath:IndexPath? = self.table_view.indexPathForSelectedRow
        if indexPath != nil
        {
            let location:RLMLocation = self._locations![indexPath!.row]
            
            return location._code
        }
        else
        {
            return nil
        }
    }
}
