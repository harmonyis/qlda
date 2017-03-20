//
//  TableKHGN_Lanscape.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 18/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation

class TableKHGN_Lanscape: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    var m_arrDSDA : [[String]] = []
    var m_NhomHopDong = [NhomHopDong]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var tbDSDA : UITableView?
    var uiViewDSDA : UIViewController?
    
    // MARK: - Table view data source
    init(_ tbvDSDA: UITableView,arrNhomHopDong: [NhomHopDong], tbvcDSDA: UIViewController){
        super.init()
        self.m_NhomHopDong = arrNhomHopDong
        self.tbDSDA = tbvDSDA
        self.uiViewDSDA = tbvcDSDA
        
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
        
        
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell_KHGN_Header_Landscape") as! CustomCell_KHGN_Header_Landscape
            
            
            let itemNhomHD :NhomHopDong = self.m_NhomHopDong[section]
            cell.lblLoaiHD.text = itemNhomHD.LoaiHopDong!
        
            cell.lblGTHD.text = itemNhomHD.GiaTriHopDong
            cell.lblLKGTTT.text = itemNhomHD.GiaTriLK
            
            cell.uiHeader_SNK.layer.borderColor = myColorBoder.cgColor
            cell.uiHeader_SNK.layer.borderWidth = 0.5
            
            cell.uiHeader_DVTH.layer.borderColor = myColorBoder.cgColor
            cell.uiHeader_DVTH.layer.borderWidth = 0.5
            
            cell.uiHeader_GTHD.layer.borderColor = myColorBoder.cgColor
            cell.uiHeader_GTHD.layer.borderWidth = 0.5
            
            cell.uiHeader_TGTH.layer.borderColor = myColorBoder.cgColor
            cell.uiHeader_TGTH.layer.borderWidth = 0.5
            
            cell.uiHeaderGroup.layer.borderColor = myColorBoder.cgColor
            cell.uiHeaderGroup.layer.borderWidth = 0.5
            
            cell.uiHeader_TenHD.layer.borderColor = myColorBoder.cgColor
            cell.uiHeader_TenHD.layer.borderWidth = 0.5
        
            cell.uiHeader_LKGTTT.layer.borderColor = myColorBoder.cgColor
            cell.uiHeader_LKGTTT.layer.borderWidth = 0.5
        
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
            
            var eventClick = UITapGestureRecognizer()
            cell.uiHeaderGroup.tag = section
            eventClick.addTarget(self, action:  #selector(TableKHGN_Portrait.duAnChaClickGroup(sender: )))
            cell.uiHeaderGroup.addGestureRecognizer(eventClick)
            cell.uiHeaderGroup.isUserInteractionEnabled = true;
            
            return cell
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
             let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell_KHGN_HD_Landscape", for: indexPath) as! CustomCell_KHGN_HD_Landscape
            let itemNhomHD :NhomHopDong = self.m_NhomHopDong[indexPath.section]
            let itemDSHDCon :[HopDong] = itemNhomHD.NhomHopDong!
            let itemHopDongCon : HopDong = itemDSHDCon[indexPath.row]
            
            cell.lblGTHD.text = Config.convert(itemHopDongCon.GiaTriHopDong!)
            cell.lblLKGTTT.text = Config.convert(itemHopDongCon.GiaTriLK!)
            cell.lblDVTH.text = itemHopDongCon.DonViThucHien!
            cell.lblTGTH.text = itemHopDongCon.ThoiGianThucHien!
        
            cell.lblSoNK.text = itemHopDongCon.SoNK!
        
            
            cell.lblTenHD.text = itemHopDongCon.TenGoiThau!
            
            cell.lblSTT.text = (String)(indexPath.row + 1 )
            
            cell.uiHD_STT.layer.borderColor = myColorBoder.cgColor
            cell.uiHD_STT.layer.borderWidth = 0.5
            
            cell.uiHD_DVTH.layer.borderColor = myColorBoder.cgColor
            cell.uiHD_DVTH.layer.borderWidth = 0.5
            
            cell.uiHD_GTHD.layer.borderColor = myColorBoder.cgColor
            cell.uiHD_GTHD.layer.borderWidth = 0.5
            
            cell.uiHD_TGTH.layer.borderColor = myColorBoder.cgColor
            cell.uiHD_TGTH.layer.borderWidth = 0.5
            
            cell.uiHD_LKGTTT.layer.borderColor = myColorBoder.cgColor
            cell.uiHD_LKGTTT.layer.borderWidth = 0.5
            
            cell.uiHD_SoNK.layer.borderColor = myColorBoder.cgColor
            cell.uiHD_SoNK.layer.borderWidth = 0.5
            
            cell.uiHD_TenHD.layer.borderColor = myColorBoder.cgColor
            cell.uiHD_TenHD.layer.borderWidth = 0.5
            
                      return cell
        
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