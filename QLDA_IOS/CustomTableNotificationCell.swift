//
//  CustomTableNotificationCell.swift
//  QLDA_IOS
//
//  Created by namos on 3/17/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CustomTableNotificationCell: UITableViewCell {
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewTitle: UIView!

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
