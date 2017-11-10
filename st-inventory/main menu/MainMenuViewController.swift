//
//  MainMenuViewController.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/10/31.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

class MainMenuViewController: BaseViewController
{
    // MARK: - Constants
    let SEGUE_TO_SEND:String = "SegueToSend"

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
    
    @IBAction func clickedUnwindToMainMenu(_ segue: UIStoryboardSegue)
    {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        return self.tryLock()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.releaseLockWDelay()
    }
}
