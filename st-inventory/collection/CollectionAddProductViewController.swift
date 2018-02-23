//
//  CollectionAddProductViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/21.
//  Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

import SVProgressHUD

class CollectionAddProductViewController: BaseScanViewController
{
    // MARK: - Class attribute
    var _collection_id:String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func captureSessionMedataFound(data:String) -> Void
    {
        super.captureSessionMedataFound(data: data)
     
        let completion:(Constants.CompletionStatus) -> Void = {
            
            [weak self] (status:Constants.CompletionStatus) -> Void in
            
            if status == Constants.CompletionStatus.Success
            {
                self?.navigationController?.popViewController(animated: true)
            }
            else
            {
                self?.showSimpleAlert(message: NSLocalizedString("collection_product_not_added", comment: ""))
            }
            
            self?.releaseLock()
            
            SVProgressHUD.dismiss()
        }
        
        CollectionApi.addProduct(sku: data, collectionId: self._collection_id!, completion: completion)
    }
    
    override func enteredTextfieldData(data:String) -> Void
    {
        if self.tryLock()
        {
            SVProgressHUD.show(withStatus: NSLocalizedString("alert_updating", comment: ""))
            
            let completion:(Constants.CompletionStatus) -> Void = {
                
                [weak self] (status:Constants.CompletionStatus) -> Void in
                
                if status == Constants.CompletionStatus.Success
                {
                    self?.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self?.showSimpleAlert(message: NSLocalizedString("collection_product_not_added", comment: ""))
                }
                
                self?.releaseLock()
                
                SVProgressHUD.dismiss()
            }
            
            CollectionApi.addProduct(sku: data, collectionId: self._collection_id!, completion: completion)
        }
    }
    
    @IBAction func clickedBack(sender:UIBarButtonItem) -> Void
    {
        if self.tryLock()
        {
            self.navigationController!.popViewController(animated: true)
        }
    }
}
