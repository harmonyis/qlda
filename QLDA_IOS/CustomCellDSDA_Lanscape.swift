//
//  CustomCellDSDA_Lanscape.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 13/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CustomCellDSDA_Lanscape: UITableViewCell {
    @IBOutlet weak var uiViewGroup: UIView!
    
    @IBOutlet weak var imgGroup: UIImageView!
    
    
    @IBOutlet weak var constraintHeightDA: NSLayoutConstraint!
    @IBOutlet weak var lblGTGN: UILabel!
    @IBOutlet weak var uiViewGTGN: UIView!
    @IBOutlet weak var lblTMDT: UILabel!
    @IBOutlet weak var uiViewTMDT: UIView!
    @IBOutlet weak var lblTGTH: UILabel!
    @IBOutlet weak var uiViewTGTH: UIView!
    @IBOutlet weak var lblGiaiDoan: UILabel!
    @IBOutlet weak var uiViewGiaiDoan: UIView!
    @IBOutlet weak var lblNhomDA: UILabel!
    @IBOutlet weak var uiViewNhomDA: UIView!
    @IBOutlet weak var lblTenDA: UILabel!
    @IBOutlet weak var uiViewTenDA: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
