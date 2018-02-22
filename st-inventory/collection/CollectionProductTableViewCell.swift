//
//  CollectionProductTableViewCell.swift
//  st-inventory
//
//  Created by Christophe Danguien on 2018/02/22.
//  Copyright © 2018 Philippe Benedetti. All rights reserved.
//

import UIKit

class CollectionProductTableViewCell: UITableViewCell
{
    // MARK: - Outlets
    @IBOutlet weak var label_sku:UILabel!

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
