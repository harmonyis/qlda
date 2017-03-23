//
//  ThongTinLich_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/22/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ThongTinLich_VC: UIViewController{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var dtpStart: UIDatePicker!
    @IBOutlet weak var dtpEnd: UIDatePicker!
    @IBOutlet weak var txtContent: UITextField!
    
    var calendarItem : CalendarItem!
    var isEdit = false
    
    var selectDate : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        
        if isEdit{
            dateFormatter.timeZone = TimeZone(secondsFromGMT : 0)
            
            dtpStart.timeZone = TimeZone(secondsFromGMT : 0)
            dtpEnd.timeZone = TimeZone(secondsFromGMT : 0)
            lblHeader.text = "Sửa sự kiện ngày: " + dateFormatter.string(from: calendarItem.dateSchedule!)
            txtTitle.text = calendarItem.title
            txtContent.text = calendarItem.note
            dtpStart.setDate(calendarItem.timeStart!, animated: false)
            dtpEnd.setDate(calendarItem.timeEnd!, animated: false)
        }
        else{
            dateFormatter.timeZone = TimeZone.current
            lblHeader.text = "Thêm sự kiện cho ngày: " + dateFormatter.string(from: selectDate)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancleTouch(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOKTouch(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
