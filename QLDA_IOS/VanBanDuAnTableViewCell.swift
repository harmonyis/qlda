//
//  VanBanDuAnTableViewCell.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class VanBanDuAnTableViewCell: UITableViewCell {
    @IBOutlet weak var stkContentCell: UIStackView!
    @IBOutlet weak var lblSoTT: UILabel!

    @IBOutlet weak var icChiTiet: UIImageView!
    @IBOutlet weak var viewTieuDeChiTiet: UIView!
    @IBOutlet weak var viewTieuDeTenVanBan: UIView!
    @IBOutlet weak var viewTieuDeSTT: UIView!
    @IBOutlet weak var lblTenVanban: UILabel!
    @IBOutlet weak var lblCoQuanBanHanh: UILabel!
    @IBOutlet weak var lblNgayBanHanh: UILabel!
    @IBOutlet weak var lblSoVanBan: UILabel!
    @IBOutlet weak var lblTenVanBanTop: NSLayoutConstraint!
    @IBOutlet weak var viewChiTietHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTenVanBanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewChiTietNoiDung: UIView!
    @IBOutlet weak var viewChiTiet: UIView!
    @IBOutlet weak var viewTieuDe: UIView!
    
    @IBOutlet weak var stkContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stkHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTieuDeHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

       
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
        // Configure the view for the selected state
    }

}
