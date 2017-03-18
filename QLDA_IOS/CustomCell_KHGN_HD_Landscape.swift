//
//  CustomCell_HD_Landscape.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 18/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CustomCell_KHGN_HD_Landscape: UITableViewCell {

    @IBOutlet weak var lblSoNK: UILabel!
   
    @IBOutlet weak var lblDVTH: UILabel!
    @IBOutlet weak var lblLKGTTT: UILabel!
    @IBOutlet weak var uiHD_LKGTTT: UIView!
    @IBOutlet weak var lblGTHD: UILabel!
    @IBOutlet weak var uiHD_GTHD: UIView!
    @IBOutlet weak var uiHD_SoNK: UIView!
    @IBOutlet weak var lblTGTH: UILabel!
    @IBOutlet weak var uiHD_TGTH: UIView!
    @IBOutlet weak var uiHD_DVTH: UIView!
    @IBOutlet weak var lblTenHD: UILabel!
    @IBOutlet weak var uiHD_TenHD: UIView!
    @IBOutlet weak var lblSTT: UILabel!
    @IBOutlet weak var uiHD_STT: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
