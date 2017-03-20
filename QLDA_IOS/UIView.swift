//
//  UIView.swift
//  QLDA_IOS
//
//  Created by datlh on 3/2/17.
//  Copyright © 2017 datlh. All rights reserved.
//
import UIKit

extension UIView{
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    /*
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
 */
}
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}
