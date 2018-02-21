//
//  CollectionTableViewCell.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/21.
//  Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell
{
    // MARK: - Class attributes
    @IBOutlet weak var label_barcode:UILabel!
    @IBOutlet weak var label_status:UILabel!
    @IBOutlet weak var label_num_products:UILabel!

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
