//
//  ProductViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/08.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

import SVProgressHUD

class ProductViewController: BaseScanViewController
{
    // MARK: - Constants
    let SEGUE_PRODUCT_DETAILS:String = "SegueProductDetails"
    
    // MARK: - CLass attributes
    var _product_sku:String?

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC:ProductDetailsViewController? = segue.destination as? ProductDetailsViewController
        if destinationVC != nil
        {
            destinationVC?._product_sku = self._product_sku
        }
        
        self.releaseLockWDelay()
    }
    
    @IBAction func clickedUnwindToProduct(_ segue: UIStoryboardSegue)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func captureSessionMedataFound(data:String) -> Void
    {
        super.captureSessionMedataFound(data: data)
        
        self.fetchProductInfo(sku: data)
    }
    
    override func enteredTextfieldData(data:String) -> Void
    {
        self.fetchProductInfo(sku: data)
    }

    private func fetchProductInfo(sku:String) -> Void
    {
        SVProgressHUD.show(withStatus: NSLocalizedString("label_searching_sku", comment: ""))
        
        let completion:(Constants.CompletionStatus) -> Void = {
            
            [weak self] (status:Constants.CompletionStatus) -> Void in
            
            if status == Constants.CompletionStatus.Success
            {
                self?._product_sku = sku
                
                self?.performSegue(withIdentifier: (self?.SEGUE_PRODUCT_DETAILS)!, sender: nil)
            }
            else
            {
                self?.showSimpleAlert(message: NSLocalizedString("label_no_product_found", comment: ""))
            }
            
            self?.releaseLock()
            
            SVProgressHUD.dismiss()
        }
        
        ProductApi.findProduct(sku: sku, completion: completion)
    }
}
