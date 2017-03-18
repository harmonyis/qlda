//
//  Notification_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/16/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import SwiftR

class Notification_VC: Base_VC {
    @IBOutlet weak var tbNotification: UITableView!
    
   
    
    @IBOutlet weak var btAllRead: UIButton!
    
    let _nSizePage = 14
    let _currentPage = 1
    var _notificationItems : [NotificationItem]? = nil
    
    var dataSource_Portrait : TableNotifications_Portrait?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNotifications()
        
        self.tbNotification.sectionFooterHeight = 0;
        self.tbNotification.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tbNotification.rowHeight = UITableViewAutomaticDimension
        self.tbNotification.estimatedRowHeight = 30
        self.tbNotification.estimatedSectionHeaderHeight = 30

        LoadNotificationNew()
    }
    
    func getNotifications(){
        
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getRecentNotifications"
        
        let params : String = "{\"nUserID\" : \(Config.userID), \"nCurrentPage\": \(_currentPage), \"nPageSize\":\(_nSizePage)}"
        
        ApiService.Post(url: apiUrl, params: params, callback: callbackGetMsg, errorCallBack: errorGetMsg)
    }
    
    func callbackGetMsg(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dics = json as? [String:Any] {
            if let dic = dics["getRecentNotificationsResult"] as? [[String:Any]] {
                self._notificationItems = [NotificationItem]()
                for item in dic{
                    var notificationItem = NotificationItem()
                    
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
    }
    
    func errorGetMsg(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func LoadTableView(){
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.date(from: ("2017-03-17 15:37:58"))
        print(dateString)
        
        
        self.dataSource_Portrait = TableNotifications_Portrait(self.tbNotification, arrNoti: self._notificationItems!)
            self.tbNotification.dataSource = self.dataSource_Portrait
            self.tbNotification.delegate = self.dataSource_Portrait
            self.tbNotification.reloadData()
        
    }
    
    func LoadNotificationNew(){
        ChatHub.addChatHub(hub: ChatHub.chatHub)
            ChatHub.chatHub.on("notification") { args in
                let notificationItemNew = NotificationItem()
                
                let item = args?[0] as? [Any]
                notificationItemNew.NotificationID = item?[2] as? Int
                notificationItemNew.NotificationProID = item?[3] as? Int
                notificationItemNew.NotificationTitle = item?[0] as? String
         
                var dateFormatter = DateFormatter()
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
    
}
