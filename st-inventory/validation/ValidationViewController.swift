//
//  ValidationViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/01.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

import SVProgressHUD

import Alamofire

class ValidationViewController: BaseViewController
{
    // MARK: - Constants
    let CELL_HEIGHT:CGFloat = 44.0
    let MARGIN:CGFloat = 8.0

    // MARK: - Outlets
    @IBOutlet weak var label_destination:UILabel!
    
    @IBOutlet weak var label_location:UILabel!
    
    @IBOutlet weak var constraint_height_view_location:NSLayoutConstraint!
    @IBOutlet weak var constraint_top_view_location:NSLayoutConstraint!
    
    @IBOutlet weak var constraint_height_view_destination:NSLayoutConstraint!
    @IBOutlet weak var constraint_top_view_destination:NSLayoutConstraint!
    
    @IBOutlet weak var constraint_table_view_left:NSLayoutConstraint!
    @IBOutlet weak var constraint_table_view_right:NSLayoutConstraint!
    
    @IBOutlet weak var constraint_table_view_width:NSLayoutConstraint!
    
    @IBOutlet weak var constraint_view_products_title_height:NSLayoutConstraint!
    @IBOutlet weak var constraint_view_products_height:NSLayoutConstraint!

    // MARK: - Class Attributes
    var _destination_id:Int?
    
    var _location_code:String?
    
    var _products:Results<RLMProduct>?
    
    var _constraint_height_view_location_original:CGFloat = 0.0
    var _constraint_top_view_location_original:CGFloat = 0.0

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
        
        self._products = realm.objects(RLMProduct.self).filter(NSPredicate(format: "_sent = false")).sorted(byKeyPath: "_date_added")
        print(self._products as Any)
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        
        self.constraint_table_view_width.constant = screenSize.width - self.constraint_table_view_left.constant - self.constraint_table_view_right.constant
    
        self._constraint_height_view_location_original = self.constraint_height_view_location.constant
        self._constraint_top_view_location_original = self.constraint_top_view_location.constant

        // Set location block if exists
        if self._location_code != nil
        {
            let realm:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
            let location:RLMLocation = realm.object(ofType: RLMLocation.self, forPrimaryKey: self._location_code!)!
            
            self.label_location.text = location._name
            
            if self.constraint_height_view_location.constant <= 0.0
            {
                self.constraint_height_view_location.constant = self._constraint_height_view_location_original
                self.constraint_top_view_location.constant = self._constraint_top_view_location_original
            }
        }
        else
        {
            self.constraint_height_view_location.constant = 0.0
            self.constraint_top_view_location.constant = 0.0
        }
        
        // Set destination block if exists
        if self._destination_id != nil
        {
            let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
            let destination:RLMDestination = realmMemory.object(ofType: RLMDestination.self, forPrimaryKey: self._destination_id)!
            
            self.label_destination.text = destination._type_name
        }
        else
        {
            self.constraint_height_view_destination.constant = 0.0
            self.constraint_top_view_destination.constant = 0.0
        }
        
        self.constraint_view_products_height.constant = self.constraint_view_products_title_height.constant + (3 * MARGIN) + ((CGFloat)(self._products!.count) * self.CELL_HEIGHT)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("DEALLOC ValidationViewController")
    }
    
    @IBAction func clickedReset(sender:UIBarButtonItem) -> Void
    {
        if self.tryLock()
        {
            let alertController:UIAlertController = UIAlertController(title: NSLocalizedString("reset_alert_title", comment: ""), message: NSLocalizedString("reset_check_confirm", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOk:UIAlertAction = UIAlertAction(title: NSLocalizedString("alert_ok", comment: ""), style: UIAlertActionStyle.default, handler:
            {
                [weak self] (alert: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
                
                let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
                
                realm.beginWrite()
                realm.delete((self?._products)!)
                try! realm.commitWrite()
                
                NotificationCenter.default.post(name: Constants.NOTIFICATION_UPDATE_PRODUCT_LIST, object: nil)
                
                if self != nil
                {
                    self?.releaseLock()
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            })
            
            alertController.addAction(actionOk)
            
            let actionCancel:UIAlertAction = UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""), style: UIAlertActionStyle.destructive, handler:
            {
                [weak self] (alert: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
                
                if self != nil
                {
                    self?.releaseLock()
                }
            })
            
            alertController.addAction(actionCancel)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func clickedBack(sender:UIBarButtonItem)
    {
        if self.tryLock()
        {
            if self._location_code != nil
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                let realmMemory:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
                
                let predicate:NSPredicate = NSPredicate(format: "_destination_id = %i", argumentArray: [self._destination_id as Any])
                
                let count:Int = realmMemory.objects(RLMLocation.self).filter(predicate).count
                
                if count > 0
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    let viewControllers:[UIViewController] = (self.navigationController?.viewControllers)!
                    for viewController in viewControllers
                    {
                        if viewController.isKind(of: DestinationViewController.self)
                        {
                            self.navigationController?.popToViewController(viewController, animated: true)
                            
                            break
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func clickedSubmit(sender:UIButton) -> Void
    {
        if self.tryLock()
        {
            if self._location_code != nil
            {
                SVProgressHUD.show(withStatus: NSLocalizedString("label_sending_products", comment: ""))
                
                let completion:(Constants.CompletionStatus) -> Void = {
                    
                    [weak self] (status:Constants.CompletionStatus) -> Void in
                    
                    self?.releaseLock()
                    
                    if status == Constants.CompletionStatus.Success
                    {
                        let realmPersistent:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
                        
                        realmPersistent.beginWrite()
                        for product in (self?._products!)!
                        {
                            product._sent = true
                        }
                        try! realmPersistent.commitWrite()
                        
                        self?.showSimpleAlert(message: NSLocalizedString("success_sending_products", comment: ""))
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    else
                    {
                        self?.showSimpleAlert(message: NSLocalizedString("error_sending_products", comment: ""))
                    }
                    
                    SVProgressHUD.dismiss()
                }
                
                var location:RLMLocation?
                
                if self._location_code != nil
                {
                    let realm:Realm = RealmUtils.sharedInstance.getRealmInMemory()!
                    location = realm.object(ofType: RLMLocation.self, forPrimaryKey: self._location_code!)!
                }
                
                var parameters:Parameters = Parameters()
                parameters[Constants.KEY_TYPE] = Constants.VALUE_TYPE
                parameters[Constants.KEY_METHOD] = Constants.VALUE_METHOD
                
                var parametersContent:[Any] = []
                
                // Set the final values on the products
                let realmPersistent:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
                
                realmPersistent.beginWrite()
                for product in self._products!
                {
                    if self._destination_id != nil
                    {
                        product._destination_id = self._destination_id!
                    }

                    product._location_code = self._location_code
                }
                try! realmPersistent.commitWrite()
                
                for product in self._products!
                {
                    var dictionary:[String: Any] = product.getAsDictionary()
                    if location != nil
                    {
                        dictionary[Constants.KEY_LOCATION_CODE] = location!._code
                    }
                    
                    parametersContent.append(dictionary)
                }
                
                parameters[Constants.KEY_CONTENT] = parametersContent
                
                ProductApi.submit(parameters: parameters, completion: completion)
            }
            else
            {
                self.showSimpleAlert(message: NSLocalizedString("error_no_location_selected", comment: ""))
                
                self.releaseLockWDelay()
            }
        }
    }
}

extension ValidationViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self._products != nil
        {
            return self._products!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
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
            
            tableView.reloadData()
            
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
}
