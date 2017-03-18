//
//  Cell_KHGN_R4.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 17/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class Cell_KHGN_R4: UITableViewCell {

   
    @IBOutlet weak var lblGTHD: UILabel!
    @IBOutlet weak var lblTenHD: UILabel!
    @IBOutlet weak var lblSTT: UILabel!
    @IBOutlet weak var uiView_R4_GTHD: UIView!
    @IBOutlet weak var lblLKGTTT: UILabel!
    
    @IBOutlet weak var uiView_R4_detail: UIView!
    @IBOutlet weak var uiView_R4_LKGTTT: UIView!
    @IBOutlet weak var uiView_R4_TenHD: UIView!
    @IBOutlet weak var uiView_R4_STT: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
