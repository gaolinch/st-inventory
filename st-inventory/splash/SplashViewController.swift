//
//  LaunchViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/03.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchDestinations()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchDestinations() -> Void
    {
        let completion:(Constants.CompletionStatus) -> Void = {
            
            [weak self] (status:Constants.CompletionStatus) -> Void in
            
            if status == Constants.CompletionStatus.Success
            {
                self?.moveToMainMenu()
            }
            else
            {
                self?.showCannotLoadDestinations()
            }
        }
        
        DestinationApi.fetchAll(completion: completion)
        CollectionApi.fetchAll(completion: nil)
        CollectionApi.fetchStatuses()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func moveToMainMenu() -> Void
    {
        // Init Root controller
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController:UINavigationController = storyboard.instantiateViewController(withIdentifier: "Root") as! UINavigationController
        
        // Below is if you completely remplaced the root, which we want some times
        let window:UIWindow = UIApplication.shared.delegate!.window!!
        window.rootViewController = rootViewController
        
        DispatchQueue.main.async
            {
                UIView.transition(with: window, duration:0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    private func showCannotLoadDestinations() -> Void
    {
        let alertController:UIAlertController = UIAlertController(title: NSLocalizedString("error_label", comment: ""), message: NSLocalizedString("error_fetching_destinations", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        
        let actionRetry:UIAlertAction = UIAlertAction(title: NSLocalizedString("alert_retry", comment: ""), style: UIAlertActionStyle.default, handler:
        {
            [weak self] (alert: UIAlertAction!) in

            alertController.dismiss(animated: true, completion: nil)
            
            self?.fetchDestinations()
        })
        alertController.addAction(actionRetry)

        self.present(alertController, animated: true, completion: nil)
    }
}
