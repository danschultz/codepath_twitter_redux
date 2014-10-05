//
//  MenuItemTableViewCell.swift
//  twitter
//
//  Created by Dan Schultz on 10/4/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
