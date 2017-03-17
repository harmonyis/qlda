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
                print(dic)
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
                /*self.DSDA = self.DSDA.sorted(by: { Int($0.IdDA!)! > Int($1.IdDA!)! })
                self.m_DSDA = self.DSDA*/
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
        self.dataSource_Portrait = TableNotifications_Portrait(self.tbNotification, arrNoti: self._notificationItems!)
            self.tbNotification.dataSource = self.dataSource_Portrait
            self.tbNotification.delegate = self.dataSource_Portrait
            self.tbNotification.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
