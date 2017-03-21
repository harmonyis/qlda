//
//  Cell_KHGN_R2.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 16/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class Cell_KHGN_R2: UITableViewCell {
    
    @IBOutlet weak var constraintRightNoiDung: NSLayoutConstraint!
    @IBOutlet weak var constraintRightGTHD: NSLayoutConstraint!

    @IBOutlet weak var imgGroup: UIImageView!
    @IBOutlet weak var constraintHeight_R2_LoaiGT: NSLayoutConstraint!
    @IBOutlet weak var lblLKGTTT: UILabel!
    @IBOutlet weak var lblGTHD: UILabel!
    @IBOutlet weak var lblTenGoiThau: UILabel!
    @IBOutlet weak var uiViewLoaiGoiThau_detail: UIView!
    @IBOutlet weak var uiViewLoaiGoiThau_LKGTTT: UIView!
    @IBOutlet weak var uiViewLoaiGoiThau_GTHD: UIView!
    @IBOutlet weak var uiViewLoaiGoiThau_TenGT: UIView!
    @IBOutlet weak var uiViewLoaiGoiThau_group: UIView!
    @IBOutlet weak var uiViewLoaiGoiThau: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
