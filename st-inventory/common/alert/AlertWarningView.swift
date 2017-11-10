//
//  AlertWarningView.swift
//  comedy_speed_dating
//
//  Created by Christophe Danguien on 2017/08/29.
//  Copyright © 2017 Comedy Speed Dating. All rights reserved.
//

import UIKit

class AlertWarningView: UIView
{
    // MARK: - Outlet
    @IBOutlet var label_message:UILabel!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    deinit {
        print("DEINIT AlertWarningView")
    }
}
