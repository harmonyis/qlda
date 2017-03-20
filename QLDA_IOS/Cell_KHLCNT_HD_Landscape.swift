//
//  Cell_KHLCNT_HD_Landscape.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 20/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class Cell_KHLCNT_HD_Landscape: UITableViewCell {

    
    @IBOutlet weak var lblLoaiHD: UILabel!
    @IBOutlet weak var uiViewLoaiHD: UIView!
    @IBOutlet weak var lblPHLCNT: UILabel!
    @IBOutlet weak var uiViewPTLCNT: UIView!
    @IBOutlet weak var lblHTLCNT: UILabel!
    @IBOutlet weak var uiViewHTLCNT: UIView!
    @IBOutlet weak var lblGiaGT: UILabel!
    @IBOutlet weak var uiViewGiaGT: UIView!
    @IBOutlet weak var lblTenGT: UILabel!
    @IBOutlet weak var uiViewTenGT: UIView!
    @IBOutlet weak var lblSTT: UILabel!
    @IBOutlet weak var uiViewSTT: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
