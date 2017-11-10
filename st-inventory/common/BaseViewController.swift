//
//  BaseViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/10/31.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController
{
    var _screen_lock:Bool = false
    
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
}
