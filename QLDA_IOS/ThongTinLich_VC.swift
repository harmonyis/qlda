//
//  ThongTinLich_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/22/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ThongTinLich_VC: Base, UITextFieldDelegate, UITextViewDelegate{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var dtpStart: UIDatePicker!
    @IBOutlet weak var dtpEnd: UIDatePicker!
    @IBOutlet weak var txtContent: UITextView!
    
    @IBOutlet weak var viewAll: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintHeightScrollView: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeaderToBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var constraintBottomViewAll: NSLayoutConstraint!
    var calendarItem : CalendarItem!
    var isEdit = false
    
    var selectDate : Date!
    let calendar = Calendar.current
    
    var hView : CGFloat = 0
    var wView : CGFloat = 0
    
    var selectText : Int = 1
    
    func setConstraintView(){
        constraintHeightScrollView.constant = hView - 44
        //constraintHeaderToBottom.constant = 300
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        hView = size.height
        wView = size.width
        setConstraintView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hView = view.frame.height
        wView = view.frame.width
        setConstraintView()
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
        txtContent.layer.borderWidth = 0.5
        txtContent.layer.borderColor = UIColor(netHex: 0xCDCDCD).cgColor
        txtContent.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            //print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            self.setConstraintView()
            if isKeyboardShowing{
                self.constraintBottomViewAll.constant = keyboardFrame!.height
                self.constraintHeightScrollView.constant = self.constraintHeightScrollView.constant  - keyboardFrame!.height
            }
            else{
                self.constraintBottomViewAll.constant = 0
            }
            //self.constraintBottomViewAll.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                if isKeyboardShowing {
                    switch self.selectText{
                    case 2:
                        self.scrollView.scrollToView(view: self.txtContent, animated: true)
                    default:
                        self.scrollView.scrollToView(view: self.txtTitle, animated: true)
                    }
                }
                
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtTitle{
            selectText = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtContent{
            selectText = 2
        }
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
        ApiService.PostAsyncAc(url: apiUrl, params: params, callback: { (data) in
            let response = data.response as! HTTPURLResponse
            if response.statusCode != 200 {
                self.serverError(success: data)
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
            if let dic = json as? [String:Any] {
                if let id = dic["insertCalendarScheduleIOSResult"] as? Int {
                    print("\(id)")
                    DispatchQueue.main.async(execute: { () -> Void in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                }
            }

        }, errorCallBack: alertAction)
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
        ApiService.PostAsyncAc(url: apiUrl, params: params, callback: { (data) in
            let response = data.response as! HTTPURLResponse
            if response.statusCode != 200 {
                self.serverError(success: data)
                return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }, errorCallBack: alertAction)
    }
}
