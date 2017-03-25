//
//  UIScrollView.swift
//  QLDA_IOS
//
//  Created by datlh on 3/24/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
extension UIScrollView {
    
    // Bonus: Scroll to top
    func scrollToTop(_ animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect.init(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }
}
