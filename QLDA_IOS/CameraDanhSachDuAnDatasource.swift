//
//  CameraDanhSachDuAnDatasource.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/6/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
import UIKit

class CameraDanhSachDuAnDatasource : NSObject, UITableViewDataSource, UITableViewDelegate{
    var tb_DanhSachDuAn: UITableView
    
    init (tbView : UITableView) {
        self.tb_DanhSachDuAn = tbView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tb_DanhSachDuAn.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CameraDanhSachDuAnTableViewCell
        
        //cell.lblTenDuAn.text = "đâsdasdasd asda sdasd asda ád ádas đấ sdas đá as"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
