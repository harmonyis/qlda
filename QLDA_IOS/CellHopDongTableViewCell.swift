//
//  CellHopDongTableViewCell.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/14/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CellHopDongTableViewCell: UITableViewCell {

    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewTopRight: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewTopLeft: UIView!
    @IBOutlet weak var lblTenHD: UILabel!
    @IBOutlet weak var lblNgayBD: UILabel!
    @IBOutlet weak var lblTGTH: UILabel!
    @IBOutlet weak var lblSoNgayCham: UILabel!
    @IBOutlet weak var lblNgayKT: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
