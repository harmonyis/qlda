//
//  CanhBaoLandDatasource.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/18/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class CanhBaoLandDatasource : NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var arrCanhBao : [CanhBaoEntity]
    var table : UITableView
    
    init (arrData : [CanhBaoEntity],table : UITableView) {
        self.arrCanhBao = arrData
        self.table = table
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCanhBao.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCanhBao[section].arrSection.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = arrCanhBao[indexPath.section].arrSection[indexPath.row].type
        
        if type == -1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CanhBaoTableViewCell
            let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! CTHHDSection
            cell.lblTenDuAn.text = item.title
            
            
            
            
            return cell
        } else if type == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHDLand") as! CellHopDongLandTableViewCell
            let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! TTHopDong
            
            cell.lbl2.text = "\(item.tenHD)"
            cell.lbl3.text = item.ngayBD
            cell.lbl4.text = item.thoiGianTH
            cell.lbl5.text = item.ngayKT
            cell.lbl6.text = item.ngayCham
            //cell.lblSoNgayCham.isHidden = true
            
            
            return cell
            
        }
        else if type == 1 || type == 2{

            let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! ChamNHSQT
            //cell.lblTitle.text = "Chậm nộp hồ sơ quyết toán"
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHDLand") as! CellHopDongLandTableViewCell
            
            cell.lbl2.text = "\(item.ngayKyBB)"
            cell.lbl3.text = item.thoiGianQD
            cell.lbl4.text = item.ngayDuKienTrinh
            cell.lbl5.text = item.ngayCham
            cell.lbl6.text = item.ghiChu
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHDLand") as! CellHopDongLandTableViewCell
            
            let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! ChamPDHSQT
            //cell.lblTitle.text = "Chậm phê duyệt quyết toán"
            
            cell.lbl2.text = "\(item.ngayNhanDuHS)"
            cell.lbl3.text = item.thoiGianQD
            cell.lbl4.text = item.ngayDuKienPD
            cell.lbl5.text = item.ngayCham
            cell.lbl6.text = item.ghiChu
            
            return cell
        }
        
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHDLand") as! CellHopDongLandTableViewCell
        cell.lbl2.text = "đâhsi áidaisu hdiashdi áhdiashdiashdihs díhai dhaishdia hsdi áhduia hsiduahs idah"
        return cell
 */
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader") as! CBHeaderTableViewCell
        cell.lblHeader.text = "\(arrCanhBao[section].titleSection)"
        
        return cell
        
    }
}
