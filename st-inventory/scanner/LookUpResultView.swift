//
//  LookUpResultView.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/05.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

class LookUpResultView: UIView, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Constants
    let CELL_IDENTIFIER:String = "LookUpResultTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var label_sku:UILabel!
    
    @IBOutlet weak var table_view:UITableView!
    
    // MARK: - Class attributes
    var _products_found:Results<RLMProductLookUp>?
    
    var _sku:String?

    override func willMove(toSuperview newSuperview: UIView?)
    {
        super.willMove(toSuperview: newSuperview)
        
        let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
        
        self._products_found = realmMemory.objects(RLMProductLookUp.self)
        
        self.label_sku.text = self._sku
        
        let nib:UINib = UINib(nibName: CELL_IDENTIFIER, bundle: nil)
        self.table_view.register(nib, forCellReuseIdentifier: CELL_IDENTIFIER)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self._products_found!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:LookUpResultTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as? LookUpResultTableViewCell
        
        if cell == nil
        {
            cell = LookUpResultTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CELL_IDENTIFIER)
        }
        
        let product:RLMProductLookUp = self._products_found![indexPath.row]
        
        cell!.label_destination_code.text = product._destination_code
        cell!.label_destination_code.text = product._destination_code
        
        cell!.label_destination_code.text = product._destination_code
        cell!.label_destination_code.text = product._destination_code
        
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        cell!.label_date_creation.text = dateFormatter.string(from: product._created_date!)
        
        return cell!
    }
    
    @IBAction func clickedOk(sender:UIButton!) -> Void
    {
        AlertMessage.close()
    }
}
