//
//  CellChamQTLandTableViewCell.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/18/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class CellChamQTLandTableViewCell: UITableViewCell {

    @IBOutlet weak var viewR1: UIView!
    @IBOutlet weak var lbl1R1: UILabel!
    
    @IBOutlet weak var viewR2: UIView!
    
    @IBOutlet weak var view2R2: UIView!
    @IBOutlet weak var lbl2R2: UILabel!
    
    
    @IBOutlet weak var view3R2: UIView!
    @IBOutlet weak var lbl3R2: UILabel!
    
    @IBOutlet weak var view4R2: UIView!
    @IBOutlet weak var lbl4R2: UILabel!
    
    @IBOutlet weak var view5R2: UIView!
    @IBOutlet weak var lbl5R2: UILabel!
    
    @IBOutlet weak var view6R2: UIView!
    @IBOutlet weak var lbl6R2: UILabel!
    
    
    @IBOutlet weak var viewR3: UIView!
    //@IBOutlet weak var lbl1R3: UILabel!
    
    @IBOutlet weak var view2R3: UIView!
    @IBOutlet weak var lbl2R3: UILabel!
    
    @IBOutlet weak var view3R3: UIView!
    @IBOutlet weak var lbl3R3: UILabel!
    
    @IBOutlet weak var view4R3: UIView!
    @IBOutlet weak var lbl4R3: UILabel!
    
    @IBOutlet weak var view5R3: UIView!
    @IBOutlet weak var lbl5R3: UILabel!
    
    @IBOutlet weak var view6R3: UIView!
    @IBOutlet weak var lbl6R3: UILabel!
    
     let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewR1.viewWithTag(1)!.layer.borderWidth = 0.5
        self.viewR1.viewWithTag(1)!.layer.borderColor = myColorBoder.cgColor
        
        self.viewR2.layer.borderWidth = 0.5
        self.viewR2.layer.borderColor = myColorBoder.cgColor
        
        self.viewR3.layer.borderWidth = 0.5
        self.viewR3.layer.borderColor = myColorBoder.cgColor
        
        self.view2R2.layer.borderWidth = 0.5
        self.view2R2.layer.borderColor = myColorBoder.cgColor
        
        self.view3R2.layer.borderWidth = 0.5
        self.view3R2.layer.borderColor = myColorBoder.cgColor
        
        self.view3R2.layer.borderWidth = 0.5
        self.view3R2.layer.borderColor = myColorBoder.cgColor
        
        self.view4R2.layer.borderWidth = 0.5
        self.view4R2.layer.borderColor = myColorBoder.cgColor
        
        self.view5R2.layer.borderWidth = 0.5
        self.view5R2.layer.borderColor = myColorBoder.cgColor
        
        self.view6R2.layer.borderWidth = 0.5
        self.view6R2.layer.borderColor = myColorBoder.cgColor
        
        self.view2R3.layer.borderWidth = 0.5
        self.view2R3.layer.borderColor = myColorBoder.cgColor
        
        self.view3R3.layer.borderWidth = 0.5
        self.view3R3.layer.borderColor = myColorBoder.cgColor
        
        self.view3R3.layer.borderWidth = 0.5
        self.view3R3.layer.borderColor = myColorBoder.cgColor
        
        self.view4R3.layer.borderWidth = 0.5
        self.view4R3.layer.borderColor = myColorBoder.cgColor

        self.view5R3.layer.borderWidth = 0.5
        self.view5R3.layer.borderColor = myColorBoder.cgColor
        
        self.view6R3.layer.borderWidth = 0.5
        self.view6R3.layer.borderColor = myColorBoder.cgColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
