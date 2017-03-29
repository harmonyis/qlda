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
    var setHeaderClick : Set<String> = []
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    var uiViewCB : UIViewController?
    var m_canceSwipe = false
    init (arrData : [CanhBaoEntity],table : UITableView,ViewCB : UIViewController) {
        self.arrCanhBao = arrData
        self.table = table
        self.uiViewCB = ViewCB
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if m_canceSwipe == false && scrollView.contentOffset.y < -50 {
            m_canceSwipe = true
            self.uiViewCB?.viewDidLoad()
        }
        else if scrollView.contentOffset.y > 0 {
            self.m_canceSwipe = false
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCanhBao.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.setHeaderClick.contains("\(section)") {
            return 0
        } else {
            return arrCanhBao[section].arrSection.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = arrCanhBao[indexPath.section].arrSection[indexPath.row].type
        
        if type == -1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHDTitleLand", for: indexPath) as! CellHopDongTitleLandTableViewCell
            
            
            let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! CTHHDSection
            
            cell.lbl1R1.text = item.title
            cell.lbl2R2.text = "Tên hợp đồng"
            cell.lbl3R2.text = "Ngày bắt đầu"
            cell.lbl4R2.text = "Thời gian thực hiện (ngày)"
            cell.lbl5R2.text = "Ngày kết thúc"
            cell.lbl6R2.text = "Số ngày chậm"
            
             cell.viewR1.viewWithTag(1)!.layer.addBorder(edge: .right, color: myColorBoder, thickness: 0.5)
            cell.view2R2.layer.borderWidth = 0.5
            cell.view2R2.layer.borderColor = myColorBoder.cgColor
            //cell.view2R2.layer.addBorder(edge: .right, color: myColorBoder, thickness: 0.5)
            //cell.view2R2.layer.addBorder(edge: .left, color: myColorBoder, thickness: 0.5)
            
            cell.view1R2.layer.borderWidth = 0.5
            cell.view1R2.layer.borderColor = myColorBoder.cgColor
            
            cell.view2R2.layer.borderWidth = 0.5
            cell.view2R2.layer.borderColor = myColorBoder.cgColor
            
            cell.view3R2.layer.borderWidth = 0.5
            cell.view3R2.layer.borderColor = myColorBoder.cgColor
            
            cell.view4R2.layer.borderWidth = 0.5
            cell.view4R2.layer.borderColor = myColorBoder.cgColor
            
            cell.view5R2.layer.borderWidth = 0.5
            cell.view5R2.layer.borderColor = myColorBoder.cgColor
            
            cell.view6R2.layer.borderWidth = 0.5
            cell.view6R2.layer.borderColor = myColorBoder.cgColor
            

            
            cell.layer.borderColor = myColorBoder.cgColor
            cell.layer.borderWidth = 0.5
            
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
            cell.layer.borderColor = myColorBoder.cgColor
            cell.layer.borderWidth = 0.5
            
            cell.view1.layer.borderWidth = 0.5
            cell.view1.layer.borderColor = myColorBoder.cgColor
            
            cell.view2.layer.borderWidth = 0.5
            cell.view2.layer.borderColor = myColorBoder.cgColor
            
            cell.view3.layer.borderWidth = 0.5
            cell.view3.layer.borderColor = myColorBoder.cgColor
            
            cell.view4.layer.borderWidth = 0.5
            cell.view4.layer.borderColor = myColorBoder.cgColor
            
            cell.view5.layer.borderWidth = 0.5
            cell.view5.layer.borderColor = myColorBoder.cgColor
            
            cell.view6.layer.borderWidth = 0.5
            cell.view6.layer.borderColor = myColorBoder.cgColor
            
            return cell
            
        }
        else if type == 1 || type == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChamQTLand") as! CellChamQTLandTableViewCell
            let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! ChamNHSQT
            
            cell.lbl1R1.text = "Chậm nộp hồ sơ quyết toán"
            
            cell.lbl2R3.text = "\(item.ngayKyBB)"
            cell.lbl3R3.text = item.thoiGianQD
            cell.lbl4R3.text = item.ngayDuKienTrinh
            cell.lbl5R3.text = item.ngayCham
            cell.lbl6R3.text = item.ghiChu
            
            
            
            cell.lbl2R2.text = "Ngày ký biên bản bàn giao đưa vào sử dụng"
            cell.lbl3R2.text = "Thời gian quy định (tháng)"
            cell.lbl4R2.text = "Ngày dự kiến trình HSQT"
            cell.lbl5R2.text = "Số ngày chậm"
            cell.lbl6R2.text = "Ghi chú"
            cell.layer.borderColor = myColorBoder.cgColor
            cell.layer.borderWidth = 0.5
            

            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChamQTLand") as! CellChamQTLandTableViewCell
            
            let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! ChamPDHSQT
            cell.lbl1R1.text = "Chậm phê duyệt quyết toán"
            
            cell.lbl2R3.text = "\(item.ngayNhanDuHS)"
            cell.lbl3R3.text = item.thoiGianQD
            cell.lbl4R3.text = item.ngayDuKienPD
            cell.lbl5R3.text = item.ngayCham
            cell.lbl6R3.text = item.ghiChu
            
            cell.lbl2R2.text = "Ngày nhận đủ hồ sơ quyết toán"
            cell.lbl3R2.text = "Thời gian quy định (tháng)"
            cell.lbl4R2.text = "Ngày dự kiến phê duyệt HSQT"
            cell.lbl5R2.text = "Số ngày chậm"
            cell.lbl6R2.text = "Ghi chú"
            cell.layer.borderColor = myColorBoder.cgColor
            cell.layer.borderWidth = 0.5
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader") as! CBHeaderTableViewCell
        cell.lblHeader.text = "\(arrCanhBao[section].titleSection)"
        
        if self.setHeaderClick.contains("\(section)") {
            cell.imgHeaderIcon.image = UIImage(named: "arrow_down")
        }
        
        
        cell.imgIcon.layer.borderColor = myColorBoder.cgColor
        cell.imgIcon.layer.borderWidth = 0.5
        cell.layer.borderColor = myColorBoder.cgColor
        cell.layer.borderWidth = 0.5
        
        let eventClick : UITapGestureRecognizer = UITapGestureRecognizer()
        cell.accessibilityLabel = "\(section)"
        eventClick.addTarget(self, action:  #selector(CanhBaoDatasource.headerClick(sender: )))
        
        cell.addGestureRecognizer(eventClick)
        cell.isUserInteractionEnabled = true;
        
        return cell
        
    }
    
    func headerClick(sender:UITapGestureRecognizer) {
        let value = (sender.view?.accessibilityLabel!)! as String
        if self.setHeaderClick.contains(value) {
            self.setHeaderClick.remove(value)
        } else {
            self.setHeaderClick.insert(value)
        }
        self.table.reloadData()
    }
}
