//
//  CustomCell_KHGN_Header_Landscape.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 18/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CustomCell_KHGN_Header_Landscape: UITableViewCell {

    @IBOutlet weak var imgGroup: UIImageView!
    @IBOutlet weak var lblLKGTTT: UILabel!
    @IBOutlet weak var lblGTHD: UILabel!
    @IBOutlet weak var lblLoaiHD: UILabel!
    @IBOutlet weak var uiHeader_LKGTTT: UIView!
    @IBOutlet weak var uiHeader_GTHD: UIView!
    @IBOutlet weak var uiHeader_SNK: UIView!
    @IBOutlet weak var uiHeader_TGTH: UIView!
    @IBOutlet weak var uiHeader_DVTH: UIView!
    @IBOutlet weak var uiHeader_TenHD: UIView!
    @IBOutlet weak var uiHeaderGroup: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
