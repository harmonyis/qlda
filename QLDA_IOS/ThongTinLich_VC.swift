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
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if isEdit{

            lblHeader.text = "Sửa sự kiện ngày: " + dateFormatter.string(from: calendarItem.dateSchedule!)
            txtTitle.text = calendarItem.title
            txtContent.text = calendarItem.note
            dtpStart.setDate(calendarItem.timeStart!, animated: false)
            dtpEnd.setDate(calendarItem.timeEnd!, animated: false)
        }
        else{           

            lblHeader.text = "Thêm sự kiện cho ngày: " + dateFormatter.string(from: selectDate)
        }
        dtpEnd.minimumDate = dtpStart.date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancleTouch(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOKTouch(_ sender: UIButton) {
        if isEdit{
            editCalendar(id : calendarItem.calendarScheduleID! ,date: selectDate, start: dtpStart.date, end: dtpEnd.date, title: txtTitle.text!, note: txtContent.text!)
        }
        else{
            insertCalendar(date: selectDate, start: dtpStart.date, end: dtpEnd.date, title: txtTitle.text!, note: txtContent.text!)
        }
        
    }
    
    @IBAction func dtpStartChageValue(_ sender: UIDatePicker) {
        dtpEnd.minimumDate = sender.date
    }
    
    func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
    
    func insertCalendar(date : Date, start : Date, end : Date, title : String, note : String){
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/insertCalendarScheduleIOS"
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        let hourStart = Calendar.current.component(.hour, from: start)
        let minuteStart = Calendar.current.component(.minute, from: start)
        let hourEnd = Calendar.current.component(.hour, from: end)
        let minuteEnd = Calendar.current.component(.minute, from: end)

        
        let params : String = "{\"nUserID\" : \(Config.userID), \"nYearSchedule\": \(year), \"nMonthSchedule\": \(month), \"nDaySchedule\": \(day), \"sTitle\": \"\(title)\", \"nHourStart\": \(hourStart), \"nMinuteStart\": \(minuteStart), \"nHourEnd\": \(hourEnd), \"nMinuteEnd\": \(minuteEnd), \"sNote\": \"\(note)\"}"
        print(params)
        ApiService.Post(url: apiUrl, params: params, callback: { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dic = json as? [String:Any] {
                if let id = dic["insertCalendarScheduleIOSResult"] as? Int {
                    print("\(id)")
                    DispatchQueue.main.async(execute: { () -> Void in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                }
            }

        }, errorCallBack: { (error) in
            print("error")
            print(error.localizedDescription)
        })
    }
    
    func editCalendar(id : Int, date : Date, start : Date, end : Date, title : String, note : String){
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/editCalendarScheduleIOS"
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        let hourStart = Calendar.current.component(.hour, from: start)
        let minuteStart = Calendar.current.component(.minute, from: start)
        let hourEnd = Calendar.current.component(.hour, from: end)
        let minuteEnd = Calendar.current.component(.minute, from: end)

        let params : String = "{\"nCalendarScheduleID\" : \(id), \"nYearSchedule\": \(year), \"nMonthSchedule\": \(month), \"nDaySchedule\": \(day), \"sTitle\": \"\(title)\", \"nHourStart\": \(hourStart), \"nMinuteStart\": \(minuteStart), \"nHourEnd\": \(hourEnd), \"nMinuteEnd\": \(minuteEnd), \"sNote\": \"\(note)\"}"
        print(params)
        ApiService.Post(url: apiUrl, params: params, callback: { (data) in
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }, errorCallBack: { (error) in
            print("error")
            print(error.localizedDescription)
        })
    }
}
