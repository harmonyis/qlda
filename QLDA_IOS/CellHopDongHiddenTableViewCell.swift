//
//  CellHopDongHiddenTableViewCell.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/17/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CellHopDongHiddenTableViewCell: UITableViewCell {

    @IBOutlet weak var viewTopRight: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewTopLeft: UIView!
    @IBOutlet weak var lblTenHD: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
