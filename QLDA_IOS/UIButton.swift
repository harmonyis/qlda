//
//  UIButton.swift
//  QLDA_IOS
//
//  Created by datlh on 3/16/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
extension UIButton {
    
    public func maskCircle() {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}
