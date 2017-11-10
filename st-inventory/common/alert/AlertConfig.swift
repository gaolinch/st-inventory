//
//  AlertConfig.swift
//  comedy_speed_dating
//
//  Created by Christophe Danguien on 2017/08/20.
//  Copyright © 2017 Comedy Speed Dating. All rights reserved.
//

import UIKit

class AlertConfig: NSObject
{
    // Class attributes
    var _message_view:UIView?

    var _position:AlertMessage.Position = AlertMessage.Position.top
    
    var _timing:AlertMessage.Timing = AlertMessage.Timing.short
}
