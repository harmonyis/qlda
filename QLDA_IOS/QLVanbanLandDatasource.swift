//
//  QLVanbanLandDatasource.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/20/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
import UIKit

class QLVanBanLandDatasource : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var arrVanBan  : [VanBanEntity]
    var table : UITableView
    init(arrVanBan : [VanBanEntity], table : UITableView) {
        self.arrVanBan = arrVanBan
        self.table = table
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLand", for: indexPath) as! VanBanLandTableViewCell
        let item = arrVanBan[indexPath.row]
        let stt = indexPath.row + 1
        cell.lbl1.text = String(stt)
        cell.lbl2.text = item.tenVanBan
        //cell.lbl2.textColor = UIColor
        cell.lbl3.text = item.soVanBan
        cell.lbl4.text = item.ngayBanHanh
        cell.lbl5.text = item.coQuanBanHanh
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVanBan.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderLand") as! HeaderLandTableViewCell
        let background = UIColor(netHex: 0x21affa)
        cell.lbl1.text = "STT"
        cell.lbl1.textAlignment = .center
        cell.lbl1.font = UIFont.boldSystemFont(ofSize: 13)
        cell.view1.backgroundColor = background
        
        cell.lbl2.text = "Tên văn bản"
        cell.lbl2.textAlignment = .center
        cell.lbl2.font = UIFont.boldSystemFont(ofSize: 13)
        cell.view2.backgroundColor = background
        cell.lbl3.text = "Số văn bản"
        cell.lbl3.textAlignment = .center
        cell.lbl3.font = UIFont.boldSystemFont(ofSize: 13)
        cell.view3.backgroundColor = background
        cell.lbl4.text = "Ngày ban hành"
        cell.lbl4.textAlignment = .center
        cell.lbl4.font = UIFont.boldSystemFont(ofSize: 13)
        cell.view4.backgroundColor = background
        cell.lbl5.text = "Cơ quan ban hành"
        cell.lbl5.textAlignment = .center
        cell.lbl5.font = UIFont.boldSystemFont(ofSize: 13)
        cell.view5.backgroundColor = background
        return cell
    }
    
}


