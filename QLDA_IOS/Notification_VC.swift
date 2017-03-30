//
//  Notification_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/16/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import SwiftR

class Notification_VC: Base_VC, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tbNotification: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btAllRead: UIButton!
    
    let _nSizePage = 14
    var _currentPage = 1
    var _notificationItems : [NotificationItem]? = nil
    var firstRun : Bool? = true
    let myColorDefault : UIColor = UIColor(netHex: 0x000000)
    let myColorUnRead : UIColor = UIColor(netHex: 0x0e83d5)
    let mycolorSelected : UIColor = UIColor.red
    var m_canceSwipe = false

    override func viewDidLoad() {
        super.viewDidLoad()
        _currentPage = 1
        firstRun = true
        _notificationItems = []
        self.getNotifications()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.tbNotification.isHidden = true
        
        self.tbNotification.rowHeight = UITableViewAutomaticDimension
        self.tbNotification.estimatedRowHeight = 30
        
        btAllRead.layer.borderWidth = 1
        btAllRead.layer.borderColor = UIColor.white.cgColor
        
        LoadNotificationNew()
    }
    
    func getNotifications(){
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getRecentNotifications"
        let params : String = "{\"nUserID\" : \(Config.userID), \"nCurrentPage\": \(_currentPage), \"nPageSize\":\(_nSizePage)}"
        
        ApiService.Post(url: apiUrl, params: params, callback: callbackGetMsg, errorCallBack: errorGetMsg)
        
    }
    func getNotificationReloads(){
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getRecentNotifications"
        let params : String = "{\"nUserID\" : \(Config.userID), \"nCurrentPage\": \(_currentPage), \"nPageSize\":\(_nSizePage)}"
        
        ApiService.Post(url: apiUrl, params: params, callback: callbackGetMsgReload, errorCallBack: errorGetMsg)
        
    }
    func callbackGetMsg(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dics = json as? [String:Any] {
            if let dic = dics["getRecentNotificationsResult"] as? [[String:Any]] {
                self._notificationItems = [NotificationItem]()
                for item in dic{
                    let notificationItem = NotificationItem()
                    
                    let notificationID = item["NotificationID"] as? Int
                    let notificationTitle = item["NotificationTitle"] as? String
                    let notificationisRead = item["NotificationisRead"] as? Bool
                    let notificationCreated = Date.init(jsonDate: (item["NotificationCreated"] as? String)!)
                    let notificationProID = item["NotificationProID"] as? Int
                    
                    notificationItem.NotificationID = notificationID
                    notificationItem.NotificationProID = notificationProID
                    notificationItem.NotificationTitle = notificationTitle
                    notificationItem.NotificationCreated = notificationCreated
                    notificationItem.NotificationisRead = notificationisRead
                    
                    _notificationItems?.append(notificationItem)
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.LoadTableView()
                self.activityIndicator.stopAnimating()
                self.tbNotification.isHidden = false
            }
        }
    }
    func callbackGetMsgReload(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dics = json as? [String:Any] {
            if let dic = dics["getRecentNotificationsResult"] as? [[String:Any]] {
                for item in dic{
                    let notificationItem = NotificationItem()
                    
                    let notificationID = item["NotificationID"] as? Int
                    let notificationTitle = item["NotificationTitle"] as? String
                    let notificationisRead = item["NotificationisRead"] as? Bool
                    let notificationCreated = Date.init(jsonDate: (item["NotificationCreated"] as? String)!)
                    let notificationProID = item["NotificationProID"] as? Int
                    
                    notificationItem.NotificationID = notificationID
                    notificationItem.NotificationProID = notificationProID
                    notificationItem.NotificationTitle = notificationTitle
                    notificationItem.NotificationCreated = notificationCreated
                    notificationItem.NotificationisRead = notificationisRead
                    
                    _notificationItems?.append(notificationItem)
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.LoadTableView()
            }
        }
        loadingData = false
    }
    
    
    func errorGetMsg(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func LoadTableView(){
        self.tbNotification.dataSource = self
        self.tbNotification.delegate = self
        self.tbNotification.reloadData()
        
    }
    // load khi co tin nhan moi
    func LoadNotificationNew(){
        ChatHub.addChatHub(hub: ChatHub.chatHub)
        ChatHub.chatHub.on("notification") { args in
            let notificationItemNew = NotificationItem()
            
            let item = args?[0] as? [Any]
            notificationItemNew.NotificationID = item?[2] as? Int
            notificationItemNew.NotificationProID = item?[3] as? Int
            notificationItemNew.NotificationTitle = item?[0] as? String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
            let dateString = dateFormatter.date(from: (item?[4] as? String)!)
            notificationItemNew.NotificationCreated = dateString
            
            notificationItemNew.NotificationisRead = false
            self._notificationItems?.insert( notificationItemNew, at: 0)
            
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.LoadTableView()
                }
            }
            
        }
    }
    
    // su kien nut button da doc het
    @IBAction func btAllReadAction(_ sender: Any) {
        // update gia tri mang thong bao da doc het
        for item in self._notificationItems!{
            item.NotificationisRead = true
        }
        
        // update lai co so du lieu
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/setAllNotificationsIsRead"
        let params : String = "{\"nUserID\" : \(Config.userID)}"
        ApiService.Post(url: apiUrl, params: params, callback: callbackAllRead, errorCallBack: errorAllRead)
        
        //update so tren menu
        do{
            try ChatHub.chatHub.invoke("MakeReadAllNotification", arguments: [Config.userID])
        }
        catch {}
    }
    
    func callbackAllRead(data : Data) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.LoadTableView()
            }
        }
    }
    
    func errorAllRead(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //-------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self._notificationItems!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemNotification :NotificationItem = self._notificationItems![indexPath.row]
        
        let idDuAn = itemNotification.NotificationProID
        _idDuAnClick = idDuAn
        let idNotification = itemNotification.NotificationID
        
        self.tbNotification?.reloadData()
        // lay ten du an
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getTenDuAnByID"
        let params : String = "{\"nDuAnID\" : \(idDuAn!), \"szUsername\": \""+variableConfig.m_szUserName+"\", \"szPassword\":\""+variableConfig.m_szPassWord+"\"}"
        print(params)
        ApiService.Post(url: apiUrl, params: params, callback: callbackGetNameDuAn, errorCallBack: errorGetNameDuAn)
        
        //await _chatHubProxy.Invoke("MakeReadNotification", _nCurrentUserID, nNotificationID);
        //update trong co so du lieu
        do{
            try ChatHub.chatHub.invoke("MakeReadNotification", arguments: [Config.userID, idNotification!])
        }
        catch {}
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if m_canceSwipe == false && scrollView.contentOffset.y < -50 { //change 100 to whatever you want
            
            
            m_canceSwipe = true
            self.viewDidLoad()
            
        }
        else if scrollView.contentOffset.y >= 0 {
            
            m_canceSwipe = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbNotification?.dequeueReusableCell(withIdentifier: "idCustomCell", for: indexPath) as! CustomTableNotificationCell
        let itemNotification :NotificationItem = self._notificationItems![indexPath.row]
        // Kiem tra xem thong bao da doc chua
        var myColorTemp : UIColor? = nil
        var myBackgroundColorCell : UIColor? = nil
        if(itemNotification.NotificationisRead == false){
            myColorTemp = myColorUnRead
            myBackgroundColorCell = UIColor(netHex: 0xFFFFFF)
        }
        else{
            myColorTemp = myColorDefault
            myBackgroundColorCell = UIColor(netHex: 0xDDDDDD)
        }
        // label thong bao
        cell.lblTitle.text = itemNotification.NotificationTitle
        cell.lblTitle.font = UIFont.systemFont(ofSize: 13)
        cell.lblTitle.textAlignment = NSTextAlignment.left
        cell.lblTitle.textColor = myColorTemp
        cell.lblTitle.backgroundColor = myBackgroundColorCell
        cell.viewTitle.backgroundColor = myBackgroundColorCell
        
        //let eventClick = UITapGestureRecognizer()
        // label ngay tao
        if(itemNotification.NotificationCreated != nil){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
            dateFormatter.timeZone = TimeZone(secondsFromGMT : 7)
            let dateString = dateFormatter.string(from: itemNotification.NotificationCreated!)
            
            cell.lblDate.text = dateString
            cell.lblDate.font = UIFont.systemFont(ofSize: 13)
            cell.lblDate.textAlignment = NSTextAlignment.right
            cell.lblDate.textColor = myColorTemp
            cell.lblDate.backgroundColor = myBackgroundColorCell
            cell.viewDate.backgroundColor = myBackgroundColorCell
        }
        
        //-------------------------
        return cell
    }
    
    // khi keo table xuong cuoi cung thi se load them data
    var loadingData = false
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = (_notificationItems?.count)! - 1
        if(!loadingData && indexPath.row == lastElement){
            _currentPage += 1
            getNotificationReloads()
            loadingData = true
        }
    }
    //-----------------------------------------------------
    // su kien nhan vao title notification
    var _idDuAnClick :Int? = 0
    
    func ClickCell(sender: UITapGestureRecognizer)
    {
        let idDuAn = (sender.view?.tag)!
        _idDuAnClick = idDuAn
        //var value : String = (sender.view?.accessibilityLabel)!
        let ulLabel = sender.view as? UILabel
        let idNotification = ulLabel?.GetNotification()
        
        self.tbNotification?.reloadData()
        // lay ten du an
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getTenDuAnByID"
        let params : String = "{\"nDuAnID\" : \(idDuAn), \"szUsername\": \""+variableConfig.m_szUserName+"\", \"szPassword\":\""+variableConfig.m_szPassWord+"\"}"
        
        ApiService.Post(url: apiUrl, params: params, callback: callbackGetNameDuAn, errorCallBack: errorGetNameDuAn)
        
        //await _chatHubProxy.Invoke("MakeReadNotification", _nCurrentUserID, nNotificationID);
        //update trong co so du lieu
        do{
            try ChatHub.chatHub.invoke("MakeReadNotification", arguments: [Config.userID, Int(idNotification!)])
        }
        catch {}
        
    }
    func callbackGetNameDuAn(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dics = json as? [String:Any] {
            let szTenDuAn = (dics["getTenDuAnByIDResult"] as? String)!
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // chuyen qua tab du an
                    variableConfig.m_szIdDuAn = self._idDuAnClick!
                    variableConfig.m_szTenDuAn = szTenDuAn
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tab_") as! Tab_
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func errorGetNameDuAn(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
    }
}
