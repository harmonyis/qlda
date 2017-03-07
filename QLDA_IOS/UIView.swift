//
//  UIView.swift
//  QLDA_IOS
//
//  Created by datlh on 3/2/17.
//  Copyright © 2017 datlh. All rights reserved.
//
import UIKit

extension UIView{
    func setBadge(tag : Int, number : Int, frame : CGRect){
        var containBadge = false
        //self.viewWithTag(tag)?.isHidden = true
        for v in self.subviews{
            
            if(v.tag == tag){                
                let label = v as! UILabel
                label.isHidden = true
                if(number > 0){
                    label.text = String(number)
                    label.isHidden = false
                }
                else{
                    label.text = ""
                    label.isHidden = true
                }
                containBadge = true
            }
        }
        if !containBadge{
            let label = UILabel(frame: frame)
            label.layer.borderColor = UIColor.clear.cgColor
            label.layer.borderWidth = 2
            label.layer.cornerRadius = label.bounds.size.height / 2
            label.textAlignment = .center
            label.layer.masksToBounds = true
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .white
            label.backgroundColor = .red
            label.tag = tag
            label.isHidden = true
            if(number > 0){
                label.text = String(number)
                label.isHidden = false
            }
            else{
                label.text = ""
                label.isHidden = true
            }
            self.addSubview(label)
        }
    }
}
