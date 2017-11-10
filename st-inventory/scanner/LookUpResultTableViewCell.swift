//
//  LookUpResultTableViewCell.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/06.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

class LookUpResultTableViewCell: UITableViewCell
{
    // MARK: - Outlets
    @IBOutlet weak var label_location_code:UILabel!
    @IBOutlet weak var label_location_name:UILabel!
    
    @IBOutlet weak var label_destination_code:UILabel!
    @IBOutlet weak var label_destination_name:UILabel!
    
    @IBOutlet weak var label_date_creation:UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.groupTableViewBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
