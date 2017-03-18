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
    
    let myColorDefault : UIColor = UIColor(netHex: 0x000000)
    let myColorUnRead : UIColor = UIColor(netHex: 0x0e83d5)
    let mycolorSelected : UIColor = UIColor.red
    
    // MARK: - Table view data source
    init(_ tbvNoti: UITableView,arrNoti: [NotificationItem]){
        super.init()
        self._tbNotification = tbvNoti
        self._notificationItems = arrNoti
        
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
        //-------------------------
        // label ngay tao
        if(itemNotification.NotificationCreated != nil){
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        let dateString = dateFormatter.string(from: itemNotification.NotificationCreated!)
        
        cell.lblDate.text = dateString
        cell.lblDate.font = UIFont.systemFont(ofSize: 13)
            cell.lblDate.textAlignment = NSTextAlignment.right
        cell.lblDate.textColor = myColorTemp
        }
        //-------------------------
        return cell
    }
    
    
    func ClickCell(sender: UITapGestureRecognizer)
    {
        let idDuAn = (sender.view?.tag)!
        
        self._tbNotification?.reloadData()
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
