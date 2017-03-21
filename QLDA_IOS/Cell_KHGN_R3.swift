//
//  Cell_KHGN_R3.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 16/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class Cell_KHGN_R3: UITableViewCell {
    
    @IBOutlet weak var constraintRightNoiDung: NSLayoutConstraint!
    @IBOutlet weak var constraintRightGTHD: NSLayoutConstraint!

    @IBOutlet weak var lblSoNK: UILabel!
    @IBOutlet weak var lblTGTH: UILabel!
    @IBOutlet weak var lblDVTH: UILabel!
    @IBOutlet weak var uiViewHopDong_TTCT_Right: UIView!
    @IBOutlet weak var uiViewHopDong_TTCT_Left: UIView!
    @IBOutlet weak var uiViewHopDong_TTCT: UIView! {
        didSet {
            uiViewHopDong_TTCT.isHidden = false
        }
    }

    @IBOutlet weak var lblLKGTTT: UILabel!
    @IBOutlet weak var lblGTHD: UILabel!
    @IBOutlet weak var lblTenHD: UILabel!
    @IBOutlet weak var lblSTT: UILabel!
    @IBOutlet weak var uiViewHopDong_TieuDe_detail: UIView!
    @IBOutlet weak var uiViewHopDong_TieuDe_LKGTTT: UIView!
    @IBOutlet weak var uiViewHopDong_TieuDe_GTHD: UIView!
    @IBOutlet weak var uiViewHopDong_TieuDe_TenHD: UIView!
    @IBOutlet weak var uiViewHopDong_TieuDe_STT: UIView!
    @IBOutlet weak var uiViewHopDong_TieuDe: UIView!
    @IBOutlet weak var uiViewHopDong: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
