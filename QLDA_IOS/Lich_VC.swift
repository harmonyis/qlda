//
//  Lich_.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import FSCalendar

class Lich_Cell : UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
}

class Lich_VC: Base_VC, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnAddEvent: UIButton!
    
    @IBOutlet weak var tblCalendar: UITableView!
    @IBOutlet weak var fsCalendar: FSCalendar!
    var listCalendarItem : [CalendarItem] = [CalendarItem]()
    var currentMonth : Int = 0
    var listEventCurrentMonth : [Int] = [Int]()
    var listEventPreMonth : [Int] = [Int]()
    var listEventNextMonth : [Int] = [Int]()
    
    let currentDate = Date()
    let calendar = Calendar.current
    
    var selectCalendarItem : CalendarItem!
    var passIsEdit = false
    var passSelectDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEventOfMonth(currentDate)
        getCalendarByUserAndDate(Date())
        
        btnAddEvent.layer.cornerRadius = 25
        btnAddEvent.setImage(#imageLiteral(resourceName: "ic_addevent"), for: UIControlState.normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : Lich_Cell = tableView.dequeueReusableCell(withIdentifier: "cellLich") as! Lich_Cell
        let lich = listCalendarItem[indexPath.row]
        
        cell.lblTitle.text = lich.title
        
        cell.lblTime.text = lich.time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCalendarItem = listCalendarItem[indexPath.row]
        passIsEdit = true
        performSegue(withIdentifier: "GoToThongTinLich", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToThongTinLich") {
            if let vc = segue.destination as? ThongTinLich_VC{
                vc.calendarItem = selectCalendarItem
                vc.isEdit = passIsEdit
                vc.selectDate = passSelectDate
            }
        }
    }
    
    @IBAction func btnAddEnvetnTouch(_ sender: UIButton) {
        passIsEdit = false
        performSegue(withIdentifier: "GoToThongTinLich", sender: self)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCalendarItem.count
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date, monthPosition.rawValue)

        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        passSelectDate = date
        getCalendarByUserAndDate(date)        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let day = self.calendar.component(.day, from: date)
        let month = self.calendar.component(.month, from: date)
        let filler = self.listEventCurrentMonth.filter(){$0 == day && month == currentMonth}
        if filler.count != 0{
            return 1
        }
        return 0
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        fsCalendar.isUserInteractionEnabled = false
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.getEventOfMonth(calendar.currentPage)
            }
        }
    }
    
    func getCalendarByUserAndDate(_ date : Date){
        self.listCalendarItem = [CalendarItem]()
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getCalendarByUserAndDateIOS"
        let month = self.calendar.component(.month, from: date)
        let year = self.calendar.component(.year, from: date)
        let day = self.calendar.component(.day, from: date)

        let params : String = "{\"nUserID\" : \(Config.userID), \"nYear\": \(year), \"nMonth\": \(month), \"nDay\":\(day)}"
        print(params)
        ApiService.Post(url: apiUrl, params: params, callback: { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone(secondsFromGMT : 7)
            
            if let methodResult = json as? [String:Any] {
                if let items = methodResult["getCalendarByUserAndDateIOSResult"] as? [[String:Any]] {
                    for item in items{
                        print(item)
                        let calendarItem : CalendarItem = CalendarItem()
                        let dateSchedule = item["DateSchedule"] as! String
                        calendarItem.dateSchedule = Date(jsonDate: dateSchedule)
                        calendarItem.calendarScheduleID = item["CalendarScheduleID"] as? Int
                        let timeEnd = item["TimeEnd"] as! String
                        calendarItem.timeEnd = Date(jsonDate: timeEnd)
                        let timeStart = item["TimeStart"] as! String
                        calendarItem.timeStart = Date(jsonDate: timeStart)
                        calendarItem.UserID = item["UserID"] as? Int
                        calendarItem.title = item["Title"] as? String
                        calendarItem.note = item["Note"] as? String
                        
                        calendarItem.time = dateFormatter.string(from: calendarItem.timeStart!) + " - " + dateFormatter.string(from: calendarItem.timeEnd!)
                        
                        self.listCalendarItem.append(calendarItem)
                        
                    }
                }
            }
            
            self.reloadTable()
        }, errorCallBack: { (error) in
            self.reloadTable()
            print("error")
            print(error.localizedDescription)
        })
    }
    
    func getEventOfMonth(_ date : Date){
        listEventCurrentMonth = [Int]()
        let month = self.calendar.component(.month, from: date)
        let year = self.calendar.component(.year, from: date)
        currentMonth = month
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getEventOfMonth"
        
        let params : String = "{\"nUserID\" : \(Config.userID), \"nMonth\": \(month), \"nYear\":\(year)}"
        print(params)
        ApiService.Post(url: apiUrl, params: params, callback: { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let methodResult = json as? [String:Any] {
                if let items = methodResult["getEventOfMonthResult"] as? [String] {
                    for item in items{
                        let time = Date(jsonDate: item)
                        let day = self.calendar.component(.day, from: time!)
                        self.listEventCurrentMonth.append(day)
                        
                    }
                }
            }
            self.reloadCalendar()
        }, errorCallBack: { (error) in
            self.reloadCalendar()
            print("error")
            print(error.localizedDescription)
        })
    }
    
  
    
    func reloadCalendar(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.fsCalendar.reloadData()
                self.fsCalendar.isUserInteractionEnabled = true
            }
        }
    }
    
    func reloadTable(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tblCalendar.reloadData()
            }
        }
    }
}

class CalendarYear{
    init() {
        months = [CalendarMonth]()
    }
    var year : Int?
    var months : [CalendarMonth]
}
class CalendarMonth{
    init() {
        days = [CalendarDay]()
    }
    var month : Int?
    var days : [CalendarDay]
}
class CalendarDay{
    init() {
        items = [CalendarItem]()
    }
    var day : Int?
    var items : [CalendarItem]?
}
class CalendarItem{
    var calendarScheduleID : Int?
    
    var title : String?
    
    var note : String?
    
    var UserID : Int?
    
    var dateSchedule : Date?
    
    var timeStart : Date?
    
    var timeEnd : Date?
    
    var time : String?
}








