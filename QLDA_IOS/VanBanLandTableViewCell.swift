//
//  VanBanLandTableViewCell.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/20/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class VanBanLandTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var lbl5: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
        self.view1.layer.borderColor = myColorBoder.cgColor
        self.view1.layer.borderWidth = 0.5
        self.view2.layer.borderColor = myColorBoder.cgColor
        self.view2.layer.borderWidth = 0.5
        self.view3.layer.borderColor = myColorBoder.cgColor
        self.view3.layer.borderWidth = 0.5
        self.view4.layer.borderColor = myColorBoder.cgColor
        self.view4.layer.borderWidth = 0.5
        self.view5.layer.borderColor = myColorBoder.cgColor
        self.view5.layer.borderWidth = 0.5
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}
