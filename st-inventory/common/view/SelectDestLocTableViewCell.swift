//
//  SelectLocationTableViewCell.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2017/11/06.
//  Copyright © 2017 Philippe Benedetti. All rights reserved.
//

import UIKit

class SelectDestLocTableViewCell: UITableViewCell
{
    // MARK: - Outlet
    @IBOutlet weak var label_name:UILabel!
    @IBOutlet weak var label_type:UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
