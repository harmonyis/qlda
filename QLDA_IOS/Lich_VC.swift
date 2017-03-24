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
    //Constraint
    @IBOutlet weak var constraintHeightCalendar: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthCalendar: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightTable: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthTable: NSLayoutConstraint!
    
    // View 
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
    
    func setConstraint(height : CGFloat, width : CGFloat){
        let w = width
        var h = height
        
        //let hBar = self.navigationController?.navigationBar.frame.height
        h = h - 32
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            
            constraintWidthCalendar.constant = w
            constraintHeightCalendar.constant = 250
            
            constraintHeightTable.constant = h - 250
            constraintWidthTable.constant = w
        }
        else{
            constraintWidthCalendar.constant = w * 6/10 - 0.5
            constraintHeightCalendar.constant = h
            
            constraintHeightTable.constant = h
            constraintWidthTable.constant = w * 4/10
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setConstraint(height: size.height, width: size.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint(height: view.frame.height, width: view.frame.width)
        btnAddEvent.layer.cornerRadius = 25
        btnAddEvent.setImage(#imageLiteral(resourceName: "ic_addevent"), for: UIControlState.normal)
        btnAddEvent.tintColor = UIColor.white
        tblCalendar.tableFooterView = UIView(frame: .zero)
        fsCalendar.select(Date())
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getEventOfMonth(fsCalendar.selectedDate!)
        getCalendarByUserAndDate(fsCalendar.selectedDate!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let alert = UIAlertController(title: "Thông báo", message: "Bạn muốn xóa sự kiện này?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Huỷ", style: UIAlertActionStyle.default, handler: nil))
            
            let action = UIAlertAction(title: "OK", style: .destructive) { action in
                //self.removeUserFromGroup(userID: self.listUser[indexPath.row].ContactID!, groupID: self.groupID!)
                self.deleteCalendarSchedule(self.listCalendarItem[indexPath.row].calendarScheduleID!)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
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
                vc.selectDate = fsCalendar.selectedDate
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
            
            if let methodResult = json as? [String:Any] {
                if let items = methodResult["getCalendarByUserAndDateIOSResult"] as? [[String:Any]] {
                    for item in items{
                        print(item)
                        let calendarItem : CalendarItem = CalendarItem()
                        let dateSchedule = item["DateSchedule"] as! String
                        calendarItem.dateSchedule = Date(jsonDate: dateSchedule)
                        calendarItem.calendarScheduleID = item["CalendarScheduleID"] as? Int
                        let timeEnd = item["TimeEnd"] as! String
                        calendarItem.timeEnd = Date(jsonDateGMT: timeEnd)
                        let timeStart = item["TimeStart"] as! String
                        calendarItem.timeStart = Date(jsonDateGMT: timeStart)
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
                        let time = Date.init(jsonDate: item)
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
    
    func deleteCalendarSchedule(_ id : Int){
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/deleteCalendarSchedule"
        let params : String = "{\"nCalendarScheduleID\" : \(id)}"
        print(params)
        ApiService.Post(url: apiUrl, params: params, callback: { (data) in
            self.getEventOfMonth(self.fsCalendar.selectedDate!)
            self.getCalendarByUserAndDate(self.fsCalendar.selectedDate!)
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
    
    
    func runCode(in timeInterval:TimeInterval, _ code:@escaping ()->(Void))
    {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + timeInterval,
            execute: code)
    }
    
    func runCode(at date:Date, _ code:@escaping ()->(Void))
    {
        let timeInterval = date.timeIntervalSinceNow
        runCode(in: timeInterval, code)
    }
    
    func test()
    {
        runCode(at: Date(timeIntervalSinceNow:2))
        {
            print("Hello")
        }
        
        runCode(in: 3.0)
        {
            print("World)")
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








