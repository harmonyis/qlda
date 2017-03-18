//
//  CBChamQTTableViewCell.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/16/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CBChamQTTableViewCell: UITableViewCell {

    @IBOutlet weak var viewTopRight: UIView!
    @IBOutlet weak var viewTopLeft: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var lblNgayNhan: UILabel!
    @IBOutlet weak var lblGhiChu: UILabel!
    @IBOutlet weak var lblThoiGianQD: UILabel!
    @IBOutlet weak var lblSoNgayCham: UILabel!
    @IBOutlet weak var lblNgayDuKien: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
