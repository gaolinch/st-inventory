//
//  LocationTableViewCell.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/08.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell
{
    // MARK: - Outlet
    @IBOutlet weak var label_title_name:UILabel!
    @IBOutlet weak var label_title_code:UILabel!
    
    @IBOutlet weak var label_name:UILabel!
    @IBOutlet weak var label_code:UILabel!
    
    @IBOutlet weak var view_container:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if selected
        {
            self.view_container.backgroundColor = UIColor(red: 48.0 / 255.0, green: 162.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)

            self.label_title_name.textColor = UIColor.white
            self.label_title_code.textColor = UIColor.white
            
            self.label_name.textColor = UIColor.white
            self.label_code.textColor = UIColor.white
        }
        else
        {
            self.view_container.backgroundColor = UIColor.white

            self.label_title_name.textColor = UIColor.black
            self.label_title_code.textColor = UIColor.black
            
            self.label_name.textColor = UIColor.darkGray
            self.label_code.textColor = UIColor.darkGray
        }
    }

}
