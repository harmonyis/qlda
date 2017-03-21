//
//  Cell_KHGN_R1.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 16/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class Cell_KHGN_R1: UITableViewCell {
    
    @IBOutlet weak var constraintRightR1NoiDung: NSLayoutConstraint!
    @IBOutlet weak var constraintRightR1GTHD: NSLayoutConstraint!
    
    @IBOutlet weak var constraintRightR2TongGiaTri: NSLayoutConstraint!
    @IBOutlet weak var constraintRightR2GTHD: NSLayoutConstraint!
    

    @IBOutlet weak var lblLKGTTT: UILabel!
    @IBOutlet weak var lblGTHD: UILabel!
    @IBOutlet weak var uiViewHeader_R2_detail: UIView!
    @IBOutlet weak var uiViewHeader_R2_LKGTTT: UIView!
    @IBOutlet weak var uiViewHeader_R2_GTHD: UIView!
    @IBOutlet weak var uiViewHeader_R2_TongGiaTri: UIView!
    @IBOutlet weak var uiViewHeader_R2_Group: UIView!
    @IBOutlet weak var uiViewHeader_R1_detail: UIView!
    @IBOutlet weak var uiViewHeader_R1_LKGTT: UIView!
    @IBOutlet weak var uiViewHeader_R1_GTHD: UIView!
    @IBOutlet weak var uiViewHeader_R1_NoiDung: UIView!
    @IBOutlet weak var uiViewHeader_R1_Group: UIView!
    @IBOutlet weak var uiViewHeader_R2: UIView!
    @IBOutlet weak var uiViewHeader_R1: UIView!
    @IBOutlet weak var uiViewHeader: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
