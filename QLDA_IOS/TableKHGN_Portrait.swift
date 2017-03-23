//
//  TableKHGN_Portrait.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 16/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class TableKHGN_Portrait: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    var m_arrDSDA : [[String]] = []
    var m_NhomHopDong = [NhomHopDong]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var tbDSDA : UITableView?
    var uiViewDSDA : UIViewController?
    
    var wGTHD : CGFloat = 0
    var wLKGTTT : CGFloat = 0
    
    // MARK: - Table view data source
    init(_ tbvDSDA: UITableView,arrNhomHopDong: [NhomHopDong], tbvcDSDA: UIViewController, wGTHD : CGFloat, wLKGTTT : CGFloat){
        super.init()
        self.m_NhomHopDong = arrNhomHopDong
        self.tbDSDA = tbvDSDA
        self.uiViewDSDA = tbvcDSDA
        self.wGTHD = wGTHD
        self.wLKGTTT = wLKGTTT
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.m_NhomHopDong.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(self.indexGroupDuAnCon.contains(section))
        {
            return 0
        }
        else {
            return self.m_NhomHopDong[section].NhomHopDong!.count
        }    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if section > 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHGN_R2") as! Cell_KHGN_R2
            
        cell.constraintRightGTHD.constant = wLKGTTT + 20
        cell.constraintRightNoiDung.constant = wGTHD + wLKGTTT + 20
        
        let itemNhomHD :NhomHopDong = self.m_NhomHopDong[section]
        cell.lblTenGoiThau.text = itemNhomHD.LoaiHopDong!
        cell.lblTenGoiThau.font = UIFont.systemFont(ofSize: 13)
        cell.lblTenGoiThau.textAlignment = NSTextAlignment.left
        
        cell.lblGTHD.text = itemNhomHD.GiaTriHopDong
        cell.lblLKGTTT.text = itemNhomHD.GiaTriLK
        
        cell.uiViewLoaiGoiThau.layer.borderColor = myColorBoder.cgColor
        cell.uiViewLoaiGoiThau.layer.borderWidth = 0.5
        
        cell.uiViewLoaiGoiThau_GTHD.layer.borderColor = myColorBoder.cgColor
        cell.uiViewLoaiGoiThau_GTHD.layer.borderWidth = 0.5
        
        cell.uiViewLoaiGoiThau_group.layer.borderColor = myColorBoder.cgColor
        cell.uiViewLoaiGoiThau_group.layer.borderWidth = 0.5
        
        cell.uiViewLoaiGoiThau_TenGT.layer.borderColor = myColorBoder.cgColor
        cell.uiViewLoaiGoiThau_TenGT.layer.borderWidth = 0.5
        
        cell.uiViewLoaiGoiThau_detail.layer.borderColor = myColorBoder.cgColor
        cell.uiViewLoaiGoiThau_detail.layer.borderWidth = 0.5
        
        cell.uiViewLoaiGoiThau_LKGTTT.layer.borderColor = myColorBoder.cgColor
        cell.uiViewLoaiGoiThau_LKGTTT.layer.borderWidth = 0.5

        var image : UIImage = UIImage(named:"ic_minus")!
        if (itemNhomHD.NhomHopDong?.count)!>0 {
            
            if !self.indexGroupDuAnCon.contains(section)
            {
                image  = UIImage(named:"ic_Group-Up")!
                cell.imgGroup.image = image
                
            }
            else
            {
                image  = UIImage(named:"ic_Group-Down")!
                cell.imgGroup.image = image
                
            }
        }
        
        cell.imgGroup.image = image
        
       let eventClick = UITapGestureRecognizer()
        cell.uiViewLoaiGoiThau_group.tag = section
        eventClick.addTarget(self, action:  #selector(TableKHGN_Portrait.duAnChaClickGroup(sender: )))
        cell.uiViewLoaiGoiThau_group.addGestureRecognizer(eventClick)
        cell.uiViewLoaiGoiThau_group.isUserInteractionEnabled = true;
        
                return cell
            }
        else
          {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "R1") as! Cell_KHGN_R1
            
            
            let itemNhomHD :NhomHopDong = self.m_NhomHopDong[section]
            
            print(wGTHD, wLKGTTT)
            cell.constraintRightR1GTHD.constant = wLKGTTT + 20
            cell.constraintRightR1NoiDung.constant = wGTHD + wLKGTTT + 20
            cell.constraintRightR2GTHD.constant = wLKGTTT + 20
            cell.constraintRightR2TongGiaTri.constant = wGTHD + wLKGTTT + 20
            
            cell.lblGTHD.text = itemNhomHD.GiaTriHopDong
            cell.lblLKGTTT.text = itemNhomHD.GiaTriLK
            
            cell.uiViewHeader_R1_GTHD.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R1_GTHD.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R1_Group.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R1_Group.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R1_LKGTT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R1_LKGTT.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R1_detail.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R1_detail.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R1_NoiDung.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R1_NoiDung.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R2_GTHD.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R2_GTHD.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R2_Group.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R2_Group.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R2_detail.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R2_detail.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R2_LKGTTT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R2_LKGTTT.layer.borderWidth = 0.5
            
            cell.uiViewHeader_R2_TongGiaTri.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHeader_R2_TongGiaTri.layer.borderWidth = 0.5
            
           
            
            return cell
        
        }
    }
    func duAnChaClickGroup(sender: UITapGestureRecognizer)
    {
        //print(sender.view?.tag)
        let value  = (sender.view?.tag)
        
        if self.indexGroupDuAnCon.contains(value!) {
            self.indexGroupDuAnCon.remove(value!)
        }
        else {
            self.indexGroupDuAnCon.insert(value!)
            
        }
        
        // self.tbDSDA.beginUpdates()
        //    self.tbDSDA.endUpdates()
        self.tbDSDA?.reloadData()
    }
    
    func duAnChaClickDetail(sender: UITapGestureRecognizer)
    {
        //print(sender.view?.tag)
        let value  = (sender.view?.tag)
        
        if self.indexTrangThaiDuAnCha.contains(value!) {
            self.indexTrangThaiDuAnCha.remove(value!)
        }
        else {
            self.indexTrangThaiDuAnCha.insert(value!)
            
        }
        
        self.tbDSDA?.reloadData()
    }
    
    
    
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        let value=(String)(indexPath.section)+"-"+(String)(indexPath.row)
        if self.indexTrangThaiDuAnCon.contains(value) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHGN_R3", for: indexPath) as! Cell_KHGN_R3
            
        cell.constraintRightGTHD.constant = wLKGTTT + 20
        cell.constraintRightNoiDung.constant = wGTHD + wLKGTTT + 20
            
            
        let itemNhomHD :NhomHopDong = self.m_NhomHopDong[indexPath.section]
        let itemDSHDCon :[HopDong] = itemNhomHD.NhomHopDong!
        let itemHopDongCon : HopDong = itemDSHDCon[indexPath.row]
        
        cell.lblGTHD.text = Config.convert(itemHopDongCon.GiaTriHopDong!)
        cell.lblLKGTTT.text = Config.convert(itemHopDongCon.GiaTriLK!)
        
        var targetString : String = "Đơn vị thực hiện: \(itemHopDongCon.DonViThucHien!)"
        var range = NSMakeRange(17, targetString.characters.count - 17)
        cell.lblDVTH.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
         targetString = "Thời gian thực hiện: \(itemHopDongCon.ThoiGianThucHien!)"
         range = NSMakeRange(19, targetString.characters.count - 19)
        cell.lblTGTH.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
        targetString = "Số, ngày ký: \(itemHopDongCon.SoNK!)"
        range = NSMakeRange(12, targetString.characters.count - 12)
        cell.lblSoNK.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
        cell.lblTenHD.text = itemHopDongCon.TenGoiThau!
       
        cell.lblSTT.text = (String)(indexPath.row + 1 )
        
        cell.uiViewHopDong_TieuDe_STT.layer.borderColor = myColorBoder.cgColor
        cell.uiViewHopDong_TieuDe_STT.layer.borderWidth = 0.5
        
        cell.uiViewHopDong_TieuDe_detail.layer.borderColor = myColorBoder.cgColor
        cell.uiViewHopDong_TieuDe_detail.layer.borderWidth = 0.5
        
        cell.uiViewHopDong_TieuDe_TenHD.layer.borderColor = myColorBoder.cgColor
        cell.uiViewHopDong_TieuDe_TenHD.layer.borderWidth = 0.5
        
        cell.uiViewHopDong_TieuDe_GTHD.layer.borderColor = myColorBoder.cgColor
        cell.uiViewHopDong_TieuDe_GTHD.layer.borderWidth = 0.5
        
        cell.uiViewHopDong_TieuDe_LKGTTT.layer.borderColor = myColorBoder.cgColor
        cell.uiViewHopDong_TieuDe_LKGTTT.layer.borderWidth = 0.5
        
        cell.uiViewHopDong_TTCT_Left.layer.borderColor = myColorBoder.cgColor
        cell.uiViewHopDong_TTCT_Left.layer.borderWidth = 0.5
        
        cell.uiViewHopDong_TTCT_Right.layer.borderColor = myColorBoder.cgColor
        cell.uiViewHopDong_TTCT_Right.layer.borderWidth = 0.5
        
        let eventClick = UITapGestureRecognizer()
        
        cell.uiViewHopDong_TieuDe_detail.accessibilityLabel = value
        
        eventClick.addTarget(self, action:  #selector(TableKHGN_Portrait.duAnConClickDetail(sender: )))
        
        cell.uiViewHopDong_TieuDe_detail.addGestureRecognizer(eventClick)
        cell.uiViewHopDong_TieuDe_detail.isUserInteractionEnabled = true;

        
        
        return cell
           }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "R4", for: indexPath) as! Cell_KHGN_R4
            cell.constraintRightGTHD.constant = wLKGTTT + 20
            cell.constraintRightNoiDung.constant = wGTHD + wLKGTTT + 20
            let itemNhomHD :NhomHopDong = self.m_NhomHopDong[indexPath.section]
            let itemDSHDCon :[HopDong] = itemNhomHD.NhomHopDong!
            let itemHopDongCon : HopDong = itemDSHDCon[indexPath.row]
            
            cell.lblGTHD.text = Config.convert(itemHopDongCon.GiaTriHopDong!)
            cell.lblLKGTTT.text = Config.convert(itemHopDongCon.GiaTriLK!)
            
            cell.lblTenHD.text = itemHopDongCon.TenGoiThau!
            
            cell.lblSTT.text = (String)(indexPath.row + 1 )
            
            cell.uiView_R4_STT.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R4_STT.layer.borderWidth = 0.5
            
            cell.uiView_R4_TenHD.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R4_TenHD.layer.borderWidth = 0.5
            
            cell.uiView_R4_GTHD.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R4_GTHD.layer.borderWidth = 0.5
            
            cell.uiView_R4_LKGTTT.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R4_LKGTTT.layer.borderWidth = 0.5
            
            cell.uiView_R4_detail.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R4_detail.layer.borderWidth = 0.5
            
           
            
            let eventClick = UITapGestureRecognizer()
            
            cell.uiView_R4_detail.accessibilityLabel = value
            
            eventClick.addTarget(self, action:  #selector(TableKHGN_Portrait.duAnConClickDetail(sender: )))
            
            cell.uiView_R4_detail.addGestureRecognizer(eventClick)
            cell.uiView_R4_detail.isUserInteractionEnabled = true;
            
            
            
            return cell
        
        }
 
    }
    
    func duAnConClickDetail(sender: UITapGestureRecognizer)
    {
        //print(sender.view?.tag)
        let value : String = (sender.view?.accessibilityLabel)!
        // print(value)
        
        //  print(self.expandedCellPaths)
        if self.indexTrangThaiDuAnCon.contains(value) {
            self.indexTrangThaiDuAnCon.remove(value)
        }
        else {
            self.indexTrangThaiDuAnCon.insert(value)
            
        }
        self.tbDSDA?.beginUpdates()
        self.tbDSDA?.endUpdates()
        self.tbDSDA?.reloadData()
    }
    func ClickTenDuAn(sender: UITapGestureRecognizer)
    {
        let value : String = (sender.view?.accessibilityLabel)!
        variableConfig.m_szIdDuAn = (sender.view?.tag)!
        variableConfig.m_szTenDuAn = value
        let vc = uiViewDSDA?.storyboard?.instantiateViewController(withIdentifier: "Tab_") as! Tab_
        uiViewDSDA?.navigationController?.pushViewController(vc, animated: true)
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
