//
//  HeaderableViewCell.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/20/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
        self.view1.layer.borderColor = myColorBoder.cgColor
        self.view1.layer.borderWidth = 1
        self.view2.layer.borderColor = myColorBoder.cgColor
        self.view2.layer.borderWidth = 1
        self.view3.layer.borderColor = myColorBoder.cgColor
        self.view3.layer.borderWidth = 1

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
