//
//  Cell_KHLCNT_R3.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 08/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class Cell_KHLCNT_R3: UITableViewCell {

    @IBOutlet weak var constraintLeftTenGoiThau: NSLayoutConstraint!
 
    @IBOutlet weak var uiViewGoiThau: UIStackView!
    @IBOutlet weak var uiViewTieuDe: UIView!
    @IBOutlet weak var lblTenGoiThau: UILabel!
    @IBOutlet weak var uiViewSTT: UIView!
    @IBOutlet weak var lblSTT: UILabel!
    @IBOutlet weak var uiViewTenGoiThau: UIView!
    @IBOutlet weak var lblGiaTriTT: UILabel!
  
    @IBOutlet weak var uiViewDetail: UIView!
    @IBOutlet weak var uiViewGiaTriTT: UIView!
    @IBOutlet weak var uiViewThongTinCT: UIView!{
        didSet {
            uiViewThongTinCT.isHidden = false
        }
    }

  
    @IBOutlet weak var uiViewRightTTCT: UIView!
    @IBOutlet weak var UiViewBDLeftTTCT: UIView!
    @IBOutlet weak var uiViewHinhThucHD: UIView!
    @IBOutlet weak var uiViewPhuongThucHD: UIView!
    @IBOutlet weak var uiViewLoaiHD: UIView!
    @IBOutlet weak var lblLoaiHD: UILabel!
    @IBOutlet weak var lblPhuongThucLCNT: UILabel!
    @IBOutlet weak var lblHinhThucLCNT: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
