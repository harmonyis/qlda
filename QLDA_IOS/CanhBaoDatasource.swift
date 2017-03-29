//
//  CanhBaoDatasource.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/13/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
import UIKit
class CanhBaoDatasource : NSObject, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    
    /*
     typealias MethodHandler1 = (_ sampleParameter : String)  -> Void
     var method2 : (_ sampleParameter : String)  -> Void
     
     init(method : @escaping (_ sampleParameter : String)  -> Void) {
     method2 = method
     }
     */
    var table : UITableView
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    var arrCanhBao : [CanhBaoEntity]
    var setClick : Set<String> = []
    var setHeaderClick : Set<String> = []
    var uiViewCB : UIViewController?
    var m_canceSwipe = false
    init(arr:[CanhBaoEntity], table : UITableView,ViewCB : UIViewController) {
        self.arrCanhBao = arr
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

    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     print("selected in \(indexPath.section):\(indexPath.row)")
     }
    
 
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCanhBao.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.setHeaderClick.contains("\(section)") {
            return 0
        } else {
            return arrCanhBao[section].arrSection.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let eventClick : UITapGestureRecognizer = UITapGestureRecognizer()
        let indexString = "\(String(indexPath.row))-\(String(indexPath.section))"
        
        
        
        
        let type = arrCanhBao[indexPath.section].arrSection[indexPath.row].type
        if type == -1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CanhBaoTableViewCell
            let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! CTHHDSection
            cell.lblTenDuAn.text = item.title
            cell.viewLeft.layer.borderWidth = 0.5
            cell.viewLeft.layer.borderColor = myColorBoder.cgColor
            
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = myColorBoder.cgColor

            
            cell.viewLeft.layer.borderColor = myColorBoder.cgColor
            cell.viewLeft.layer.borderWidth = 0.5

            
            
            
            return cell
        } else if type == 0 {
            if !setClick.contains(indexString) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellHDHidden", for: indexPath) as! CellHopDongHiddenTableViewCell
                let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! TTHopDong
                cell.lblTenHD.text = item.tenHD
                
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = myColorBoder.cgColor
                cell.viewTop.layer.borderColor = myColorBoder.cgColor
                cell.viewTop.layer.borderWidth = 0.5
                cell.viewTopLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewTopLeft.layer.borderWidth = 0.5
                cell.viewTopRight.layer.borderColor = myColorBoder.cgColor
                cell.viewTopRight.layer.borderWidth = 0.5
                
                
                cell.viewTopRight.accessibilityLabel = indexString
                eventClick.addTarget(self, action:  #selector(CanhBaoDatasource.evenClick(sender: )))
                cell.viewTopRight.addGestureRecognizer(eventClick)
                cell.viewTopRight.isUserInteractionEnabled = true;
                
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellHD", for: indexPath) as! CellHopDongTableViewCell
                let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! TTHopDong
                cell.lblTenHD.text = "\(item.tenHD)"
                
                var targetString : String = "Ngày bắt đầu: \(item.ngayBD)"
                var range = NSMakeRange(13, targetString.characters.count - 13	)
                cell.lblNgayBD.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                targetString = "Thời gian thực hiện (ngày): \(item.thoiGianTH)"
                range = NSMakeRange(27, targetString.characters.count - 27)
                cell.lblTGTH.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                
                targetString = "Ngày kết thúc: \(item.ngayKT)"
                range = NSMakeRange(14, targetString.characters.count - 14)
                cell.lblNgayKT.attributedText = attributedString(from: targetString, nonBoldRange: range)
                //cell.lblNgayKT.isHidden = true
                
                targetString = "Số ngày chậm: \(item.ngayCham)"
                range = NSMakeRange(13, targetString.characters.count - 13)
                cell.lblSoNgayCham.attributedText = attributedString(from: targetString, nonBoldRange: range)
                //cell.lblSoNgayCham.isHidden = true
                
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = myColorBoder.cgColor
                
                cell.viewLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewLeft.layer.borderWidth = 0.5
                cell.viewTop.layer.borderColor = myColorBoder.cgColor
                cell.viewTop.layer.borderWidth = 0.5
                cell.viewTopLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewTopLeft.layer.borderWidth = 0.5
                cell.viewTopRight.layer.borderColor = myColorBoder.cgColor
                cell.viewTopRight.layer.borderWidth = 0.5
                

                cell.viewTopRight.accessibilityLabel = indexString
                eventClick.addTarget(self, action:  #selector(CanhBaoDatasource.evenClick(sender: )))
                
                cell.viewTopRight.addGestureRecognizer(eventClick)
                cell.viewTopRight.isUserInteractionEnabled = true;
                
                return cell
            }
        }
        else if type == 1 || type == 2{
            
            if setClick.contains(indexString) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellChamQT", for: indexPath) as! CBChamQTTableViewCell
                let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! ChamNHSQT
                cell.lblTitle.text = "Chậm nộp hồ sơ quyết toán"
                
                var targetString : String = "Ngày ký biên bản bàn giao đưa vào sử dụng: \(item.ngayKyBB)"
                var range = NSMakeRange(42, targetString.characters.count - 42)
                cell.lblNgayNhan.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                targetString = "Thời gian quy định (tháng): \(item.thoiGianQD)"
                range = NSMakeRange(26, targetString.characters.count - 26)
                cell.lblThoiGianQD.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                
                targetString = "Ngày dự kiến trình HSQT: \(item.ngayDuKienTrinh)"
                range = NSMakeRange(24, targetString.characters.count - 24)
                cell.lblNgayDuKien.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                targetString = "Số ngày chậm: \(item.ngayCham)"
                range = NSMakeRange(13, targetString.characters.count - 13)
                cell.lblSoNgayCham.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                
                if type == 1 {
                    targetString = "Ghi chú: Dự án chưa phê duyệt HSQT"
                    range = NSMakeRange(8, targetString.characters.count - 8)
                    cell.lblGhiChu.attributedText = attributedString(from: targetString, nonBoldRange: range)
                } else {
                    targetString = "Ghi chú: \(item.ghiChu)"
                    range = NSMakeRange(8, targetString.characters.count - 8)
                    cell.lblGhiChu.attributedText = attributedString(from: targetString, nonBoldRange: range)
                }
                
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = myColorBoder.cgColor
                
                cell.viewLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewLeft.layer.borderWidth = 0.5
                cell.viewTop.layer.borderColor = myColorBoder.cgColor
                cell.viewTop.layer.borderWidth = 0.5
                cell.viewTopLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewTopLeft.layer.borderWidth = 0.5
                cell.viewTopRight.layer.borderColor = myColorBoder.cgColor
                cell.viewTopRight.layer.borderWidth = 0.5
                
                cell.viewTopRight.accessibilityLabel = indexString
                eventClick.addTarget(self, action:  #selector(CanhBaoDatasource.evenClick(sender: )))
                
                cell.viewTopRight.addGestureRecognizer(eventClick)
                cell.viewTopRight.isUserInteractionEnabled = true;
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellChamQTHidden", for: indexPath) as! CBChamQTHiddenTableViewCell
                //let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! ChamNHSQT
                cell.lblTitle.text = "Chậm nộp hồ sơ quyết toán"
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = myColorBoder.cgColor
                
                cell.viewTop.layer.borderColor = myColorBoder.cgColor
                cell.viewTop.layer.borderWidth = 0.5
                cell.viewTopLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewTopLeft.layer.borderWidth = 0.5
                cell.viewTopRight.layer.borderColor = myColorBoder.cgColor
                cell.viewTopRight.layer.borderWidth = 0.5
                
                cell.viewTopRight.accessibilityLabel = indexString
                eventClick.addTarget(self, action:  #selector(CanhBaoDatasource.evenClick(sender: )))
                
                cell.viewTopRight.addGestureRecognizer(eventClick)
                cell.viewTopRight.isUserInteractionEnabled = true;
                return cell
            }
        } else {
            
            if setClick.contains(indexString) {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellChamQT", for: indexPath) as! CBChamQTTableViewCell
                let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! ChamPDHSQT
                cell.lblTitle.text = "Chậm phê duyệt quyết toán"
                
                var targetString : String = "Ngày nhận đủ hồ sơ quyết toán: \(item.ngayNhanDuHS)"
                var range = NSMakeRange(30, targetString.characters.count - 30)
                cell.lblNgayNhan.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                targetString = "Thời gian quy định (tháng): \(item.thoiGianQD)"
                range = NSMakeRange(26, targetString.characters.count - 26)
                cell.lblThoiGianQD.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                
                targetString = "Ngày dự kiến phê duyệt HSQT: \(item.ngayDuKienPD)"
                range = NSMakeRange(28, targetString.characters.count - 28)
                cell.lblNgayDuKien.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                targetString = "Số ngày chậm: \(item.ngayCham)"
                range = NSMakeRange(13, targetString.characters.count - 13)
                cell.lblSoNgayCham.attributedText = attributedString(from: targetString, nonBoldRange: range)
                
                if type == 4 {
                    targetString = "Ghi chú: \(item.ghiChu)"
                    range = NSMakeRange(8, targetString.characters.count - 8)
                    cell.lblGhiChu.attributedText = attributedString(from: targetString, nonBoldRange: range)
                } else {
                    targetString = "Ghi chú: Dự án chưa phê duyệt HSQT"
                    range = NSMakeRange(8, targetString.characters.count - 8)
                    cell.lblGhiChu.attributedText = attributedString(from: targetString, nonBoldRange: range)
                }
                
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = myColorBoder.cgColor
                
                cell.viewLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewLeft.layer.borderWidth = 0.5
                cell.viewTop.layer.borderColor = myColorBoder.cgColor
                cell.viewTop.layer.borderWidth = 0.5
                cell.viewTopLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewTopLeft.layer.borderWidth = 0.5
                cell.viewTopRight.layer.borderColor = myColorBoder.cgColor
                cell.viewTopRight.layer.borderWidth = 0.5
                
                cell.viewTopRight.accessibilityLabel = indexString
                eventClick.addTarget(self, action:  #selector(CanhBaoDatasource.evenClick(sender: )))
                
                cell.viewTopRight.addGestureRecognizer(eventClick)
                cell.viewTopRight.isUserInteractionEnabled = true;
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellChamQTHidden", for: indexPath) as! CBChamQTHiddenTableViewCell
                //let item = arrCanhBao[indexPath.section].arrSection[indexPath.row] as! ChamNHSQT
                cell.lblTitle.text = "Chậm phê duyệt quyết toán"
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = myColorBoder.cgColor
                
                cell.viewTop.layer.borderColor = myColorBoder.cgColor
                cell.viewTop.layer.borderWidth = 0.5
                cell.viewTopLeft.layer.borderColor = myColorBoder.cgColor
                cell.viewTopLeft.layer.borderWidth = 0.5
                cell.viewTopRight.layer.borderColor = myColorBoder.cgColor
                cell.viewTopRight.layer.borderWidth = 0.5
                
                cell.viewTopRight.accessibilityLabel = indexString
                eventClick.addTarget(self, action:  #selector(CanhBaoDatasource.evenClick(sender: )))
                
                cell.viewTopRight.addGestureRecognizer(eventClick)
                cell.viewTopRight.isUserInteractionEnabled = true;
                return cell
            }
        }
        //cell.lblTenDuAn.text = "\(arrCanhBao[indexPath.section].arrSection[indexPath.row])"
        
    }
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return CGFloat(60)
     }
     */
    func evenClick(sender: UITapGestureRecognizer) {
        let value = (sender.view?.accessibilityLabel!)! as String
        if self.setClick.contains(value) {
            self.setClick.remove(value)
        } else {
            self.setClick.insert(value)
        }
        self.table.reloadData()
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
    
    /*
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return CGFloat(60)
     }
     */
    
    
    
}
