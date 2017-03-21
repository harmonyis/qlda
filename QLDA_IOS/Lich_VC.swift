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

    @IBOutlet weak var fsCalendar: FSCalendar!
    var listEventCurrentMonth : [Int] = [Int]()
    var listEventPreMonth : [Int] = [Int]()
    var listEventNextMonth : [Int] = [Int]()
    
    let currentDate = Date()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCalendarByUserAndDate(currentDate)
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
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let day = self.calendar.component(.day, from: date)
        let filler = self.listEventCurrentMonth.filter(){$0 == day}
        if filler.count != 0{
            return 1
        }
        return 0
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let month =  self.calendar.component(.month, from: calendar.currentPage)
        print("\(month)")
    }
    
    func getCalendarByUserAndDate(_ date : Date){
        let month = self.calendar.component(.month, from: date)
        let year = self.calendar.component(.year, from: date)
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
                        self.fsCalendar.reloadData()
                        self.reloadCalendar()
                    }
                }
            }
            
        }, errorCallBack: { (error) in
            print("error")
            print(error.localizedDescription)
        })
    }
    
    func reloadCalendar(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.fsCalendar.reloadData()
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
}








