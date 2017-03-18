//
//  Cell_KHLCNT_R2.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 08/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class Cell_KHLCNT_R2: UITableViewCell {
    @IBOutlet weak var constraintLeftTongGiaTri: NSLayoutConstraint!
    @IBOutlet weak var constraintLeftTenGoiThau: NSLayoutConstraint!

    @IBOutlet weak var stkView_R2: UIStackView!
   
    @IBOutlet weak var uiView_R2: UIView!
    @IBOutlet weak var uiView_R2_Detail: UIView!
    @IBOutlet weak var uiView_R2_GiaGoiThau: UIView!
    @IBOutlet weak var uiView_R2_TenGT: UIView!
    @IBOutlet weak var uiView_R2_STT: UIView!
    @IBOutlet weak var uiViewTongGT_C2: UIView!
    @IBOutlet weak var uiViewTongGT_C1: UIView!
    @IBOutlet weak var uiViewTongGT: UIView!
    @IBOutlet weak var lblcountDSGT: UILabel!
    @IBOutlet weak var lblGiaTri: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
