//
//  ScannerViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/10/31.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

import RealmSwift

import SnapKit

import SVProgressHUD

class ScannerViewController: BaseScanViewController
{
    // MARK: - Constants
    let SEGUE_PRODUCT_LIST:String = "SegueProductList"
    let SEGUE_TO_DESTINATION:String = "SegueToDestination"

    // MARK: - Outlets
    @IBOutlet weak var table_view:UITableView!
    
    @IBOutlet weak var label_no_product_yet:UILabel!
    
    // MARK: - Class Attributes
    var _opened_url:Bool = false
    
    var _products:Results<RLMProduct>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!

        self._products = realm.objects(RLMProduct.self).filter(NSPredicate(format: "_sent = false")).sorted(byKeyPath: "_date_added")
        
        if self._products!.count > 0
        {
            self.label_no_product_yet.alpha = 0.0
        }
        else
        {
            self.table_view.alpha = 0.0
        }

        NotificationCenter.default.addObserver(self, selector: #selector(ScannerViewController.notificationEnterForeground(notification:)), name:.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ScannerViewController.notificationUpdateList), name: Constants.NOTIFICATION_UPDATE_PRODUCT_LIST, object: nil)
    }

    @IBAction func clickedUnwindToScanner(_ segue: UIStoryboardSegue)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func notificationEnterForeground(notification:Notification) -> Void
    {
        if self._opened_url
        {
            self.releaseLock()
        }
    }
    
    @objc func notificationUpdateList(notification:Notification) -> Void
    {
        let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
        
        self._products = realm.objects(RLMProduct.self).filter(NSPredicate(format: "_sent = false")).sorted(byKeyPath: "_date_added")
        
        self.table_view.reloadData()
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
            if identifier == SEGUE_PRODUCT_LIST
            {
                let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
                
                let productCount:Int = realm.objects(RLMProduct.self).filter(NSPredicate(format: "_sent = false")).count
                if productCount > 0
                {
                    self.releaseLock()
                    
                    return true
                }
                else
                {
                    let viewsLoaded:[Any]? = Bundle.main.loadNibNamed("ToastTopView", owner: nil, options: nil)
                    if viewsLoaded != nil
                    {
                        let topToastView:ToastTopView? = viewsLoaded?.first as? ToastTopView
                        if topToastView != nil
                        {
                            topToastView?.label_message.text = NSLocalizedString("error_no_products", comment: "")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute:
                                {
                                    let config:AlertConfig = AlertConfig()
                                    config._position = .top
                                    config._timing = .short
                                    AlertMessage.show(view: topToastView!, config:config)
                            })
                        }
                    }
                    
                    self.releaseLock()
                    
                    return false
                }
            }
            else
            {
                self.releaseLock()
                
                return true
            }
        }
        else
        {
            self.releaseLock()
            
            return false
        }
    }
    
    override func captureSessionMedataFound(data:String) -> Void
    {
        if self.addProduct(sku: data)
        {
            self.button_scan.isHidden = false
            
            if self._capture_session != nil
            {
                self._capture_session?.stopRunning()
            }
        }
    }
    
    override func enteredTextfieldData(data:String) -> Void
    {
        print(self.addProduct(sku: data))
    }

    // MARK: - Helpers
    func addProduct(sku:String) -> Bool
    {
        let realm:Realm = RealmUtils.sharedInstance.getRealmPersistentParallel()!
        
        if realm.objects(RLMProduct.self).filter(NSPredicate(format: "_sku = %@", argumentArray: [sku])).count > 0
        {
            let viewsLoaded:[Any]? = Bundle.main.loadNibNamed("AlertWarningView", owner: nil, options: nil)
            if viewsLoaded != nil
            {
                let warningView:AlertWarningView? = viewsLoaded?.first as? AlertWarningView
                if warningView != nil
                {
                    warningView?.label_message.text = NSLocalizedString("error_product_exist", comment: "")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute:
                        {
                            let config:AlertConfig = AlertConfig()
                            config._position = .top
                            config._timing = .short
                            AlertMessage.show(view: warningView!, config:config)
                    })
                }
            }
            
            self.releaseLockWDelay()
            
            return false
        }
        else
        {
            realm.beginWrite()
            
            let product:RLMProduct = RLMProduct()
            product._sku = sku
            
            realm.add(product)
            
            try! realm.commitWrite()
            
            self._products = realm.objects(RLMProduct.self).filter(NSPredicate(format: "_sent = false")).sorted(byKeyPath: "_date_added", ascending: false)
            
            if self.table_view.alpha == 0.0
            {
                UIView.animate(withDuration: 0.3, animations: {
                    [weak self] in
                    self?.table_view.alpha = 1.0
                    self?.label_no_product_yet.alpha = 0.0
                })
            }
            self.table_view.reloadData()
            
            self.showAlertProductAdded(sku: sku)
            
            self.releaseLockWDelay()
            
            return true
        }
    }
    
    private func showAlertProductAdded(sku:String) -> Void
    {
        let viewsLoaded:[Any]? = Bundle.main.loadNibNamed("AlertSuccessView", owner: nil, options: nil)
        if viewsLoaded != nil
        {
            let successView:AlertSuccessView? = viewsLoaded?.first as? AlertSuccessView
            if successView != nil
            {
                let message:String = NSLocalizedString("label_product_added", comment: "")
                
                successView?.label_message.text = message.replacingOccurrences(of: "SKU", with: sku)
                
                DispatchQueue.main.asyncAfter(deadline: .now(), execute:
                    {
                        let config:AlertConfig = AlertConfig()
                        config._position = .top
                        config._timing = .short
                        AlertMessage.show(view: successView!, config:config)
                })
            }
        }
    }
    
    @IBAction func clickedSubmit(sender:UIButton) -> Void
    {
        if self.tryLock()
        {
            if (self._products!.count > 0)
            {
                self.performSegue(withIdentifier: self.SEGUE_TO_DESTINATION, sender: nil)
            }
            else
            {
                let viewsLoaded:[Any]? = Bundle.main.loadNibNamed("ToastTopView", owner: nil, options: nil)
                if viewsLoaded != nil
                {
                    let topToastView:ToastTopView? = viewsLoaded?.first as? ToastTopView
                    if topToastView != nil
                    {
                        topToastView?.label_message.text = NSLocalizedString("error_no_products", comment: "")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute:
                            {
                                let config:AlertConfig = AlertConfig()
                                config._position = .bottom
                                config._timing = .short
                                AlertMessage.show(view: topToastView!, config:config)
                        })
                    }
                }
            }
        }
    }
}

extension ScannerViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self._products != nil
        {
            let productCount:Int = self._products!.count
            return productCount > 2 ? 2 : productCount
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
        
        print(product)

        cell!.textLabel!.text = product._sku!
        
        return cell!
    }
}
