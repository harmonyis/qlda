//
//  TableNotifications_Portrait.swift
//  QLDA_IOS
//
//  Created by namos on 3/17/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class TableNotifications_Portrait:  NSObject, UITableViewDelegate, UITableViewDataSource {

    var _notificationItems = [NotificationItem]()
    var _tbNotification : UITableView?
    var _uiViewNotification : UIViewController?
    var _nPage : Int? = 0
    var _idDuAnClick :Int? = 0
    
    let myColorDefault : UIColor = UIColor(netHex: 0x000000)
    let myColorUnRead : UIColor = UIColor(netHex: 0x0e83d5)
    let mycolorSelected : UIColor = UIColor.red
    
    // MARK: - Table view data source
    init(_ tbvNoti: UITableView,arrNoti: [NotificationItem], uiNotification: UIViewController){
        super.init()
        self._tbNotification = tbvNoti
        self._notificationItems = arrNoti
        self._uiViewNotification = uiNotification
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self._notificationItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = _tbNotification?.dequeueReusableCell(withIdentifier: "idCustomCell", for: indexPath) as! CustomTableNotificationCell
        let itemNotification :NotificationItem = self._notificationItems[indexPath.row]
        // Kiem tra xem thong bao da doc chua
        var myColorTemp : UIColor? = nil
        if(itemNotification.NotificationisRead == false){
            myColorTemp = myColorUnRead
        }
        else{
            myColorTemp = myColorDefault
        }
        // label thong bao
        cell.lblTitle.text = itemNotification.NotificationTitle
        cell.lblTitle.font = UIFont.systemFont(ofSize: 13)
        cell.lblTitle.textAlignment = NSTextAlignment.left
        cell.lblTitle.textColor = myColorTemp
        
        var eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(TableNotifications_Portrait.ClickCell(sender:)))
        cell.lblTitle.accessibilityLabel = (itemNotification.NotificationTitle!)
        cell.lblTitle.tag = (Int)(itemNotification.NotificationProID!)
        cell.lblTitle.addGestureRecognizer(eventClick)
        cell.lblTitle.isUserInteractionEnabled = true;
        cell.lblTitle.SetNotification(v: (Int)(itemNotification.NotificationID!))
        
        //-------------------------
        // label ngay tao
        if(itemNotification.NotificationCreated != nil){
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT : 7)
        let dateString = dateFormatter.string(from: itemNotification.NotificationCreated!)
        
        cell.lblDate.text = dateString
        cell.lblDate.font = UIFont.systemFont(ofSize: 13)
        cell.lblDate.textAlignment = NSTextAlignment.right
        cell.lblDate.textColor = myColorTemp
 
        }
        //-------------------------
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastElement = _notificationItems.count - 1
        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            _nPage = _nPage! + 1
            let no_VC = Notification_VC()
         
            
        }
    }
    
    func ClickCell(sender: UITapGestureRecognizer)
    {
        let idDuAn = (sender.view?.tag)!
        _idDuAnClick = idDuAn
        let value : String = (sender.view?.accessibilityLabel)!
        let ulLabel = sender.view as? UILabel
        let idNotification = ulLabel?.GetNotification()	
        
        self._tbNotification?.reloadData()
        // lay ten du an
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getTenDuAnByID"
        let params : String = "{\"nDuAnID\" : \(idDuAn), \"szUsername\": \""+variableConfig.m_szUserName+"\", \"szPassword\":\""+variableConfig.m_szPassWord+"\"}"
 
        ApiService.Post(url: apiUrl, params: params, callback: callbackGetNameDuAn, errorCallBack: errorGetNameDuAn)

        //await _chatHubProxy.Invoke("MakeReadNotification", _nCurrentUserID, nNotificationID);
        //update trong co so du lieu
        do{
            try ChatHub.chatHub.invoke("MakeReadNotification", arguments: [Config.userID, idNotification])
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
                    let vc = self._uiViewNotification?.storyboard?.instantiateViewController(withIdentifier: "Tab_") as! Tab_
                    self._uiViewNotification?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

        
    }
    
    func errorGetNameDuAn(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
    }


    
    // Hàm set chữ bold
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize),
            NSForegroundColorAttributeName: UIColor.black
        ]
        let nonBoldAttribute = [
            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    // Hàm tính size text
    func calulaterTextSize(text : String, size : CGSize) -> CGRect{
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13)], context: nil)
        return estimatedFrame
    }
}
