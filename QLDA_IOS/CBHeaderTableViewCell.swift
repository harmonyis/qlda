//
//  CBHeaderTableViewCell.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/16/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CBHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewExpand: UIView!
    @IBOutlet weak var imgIcon: UIView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
