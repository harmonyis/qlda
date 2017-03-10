//
//  CustomCellKHGN.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 07/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class CustomCellKHGN: UITableViewCell {
    
    
    @IBOutlet weak var UiViewTieuDe: UIView!
    
    @IBOutlet weak var UiViewSTT: UIView!
    
    @IBOutlet weak var UiViewDetail: UIView!
    @IBOutlet weak var UiViewTenHD: UIView!
    
    @IBOutlet weak var lblSoNgayKy: UILabel!
    @IBOutlet weak var lblThoiGianThucHien: UILabel!
    @IBOutlet weak var lblDonVi: UILabel!
    @IBOutlet weak var UiViewBDThongTinCT: UIView!
    @IBOutlet weak var UiViewThongTinCT: UIView!{
        didSet {
            UiViewThongTinCT.isHidden = false
        }
    }

    @IBOutlet weak var UiViewGTTT: UIView!
    @IBOutlet weak var UiViewGTHD: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

