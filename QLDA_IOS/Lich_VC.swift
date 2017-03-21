//
//  Lich_.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import FSCalendar

class Lich_VC: Base_VC, FSCalendarDelegate, FSCalendarDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date, monthPosition.rawValue)

        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                let img : UIImageView = UIImageView()
                img.image = #imageLiteral(resourceName: "ic_online")
                //img.frame = CGRect(x: cell.frame.width/2 - 3, y: cell.frame.height - 15 , width: 6, height: 6)
                img.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(img)
                
                let horizontalConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
                let verticalConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 8)
                let widthConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 5)
                let heightConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 5)
                cell.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            }
        }
        
    }
    
    func getCalendarByUserAndDate(){
        
    }
    
}

