//
//  UIViewController.swift
//  QLDA_IOS
//
//  Created by datlh on 3/16/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
// Put this piece of code anywhere you like
extension UIViewController {
    /*
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    */
    func dismissKeyboard() {
        view.endEditing(true)
    }
 
}
