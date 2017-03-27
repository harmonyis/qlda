//
//  TableKHLCNT_Landscape.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 20/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class TableKHLCNT_Landscape : NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    var m_dsGoiThau = [GoiThau]()
    var m_countGoiThau : Int = 0
    var m_TongGiaTri : Int = 0
    var m_thongTinKHLCNT : [String] = []
    var indexTrangThaiGoiThau = Set<Int>()
    var blackTheme = false
    var tbvKHLCNT : UITableView?
    var uiViewKHLCNT : UIViewController?
    let arrTieuDe = ["Số quyết định","Ngày phê duyệt","Cơ quan phê duyệt"]
    
    var wTongGiaTri : CGFloat = 0
    
    // MARK: - Table view data source
    init(_ tbvKHLC: UITableView, arrGoiThau: [GoiThau], arrthongTinKHLCNT : [String] , nTongGiaTri : Int, wTongGiaTri : CGFloat){
        super.init()
        self.m_dsGoiThau = arrGoiThau
        self.tbvKHLCNT = tbvKHLC
        self.m_thongTinKHLCNT = arrthongTinKHLCNT
        self.m_TongGiaTri = nTongGiaTri
        m_countGoiThau = m_dsGoiThau.count
        self.wTongGiaTri = wTongGiaTri
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.m_dsGoiThau.count + 4
        
        
    }
    
    
    
    let myColorBoder : UIColor = variableConfig.m_borderColor
    let myColorBackgroud : UIColor = UIColor(netHex: 0xb4e2f7)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        let index = indexPath.row
        if index < 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHLCNT_R1", for: indexPath) as! Cell_KHLCNT_R1
            print(self.m_thongTinKHLCNT)
            cell.lblGiaTri.text = self.m_thongTinKHLCNT[index + 1]
            cell.lblTieuDe.text = arrTieuDe[index]
            
            cell.uiView_R1.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R1.layer.borderWidth = 0.5
            return cell
        }
        else if index == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHLCNT_Header_Landscape", for: indexPath) as! Cell_KHLCNT_Header_Landscape
            
            cell.constraintRightTenGoiThau.constant = wTongGiaTri + 180
            cell.constraintRightTongGiaTr.constant = wTongGiaTri + 180

            cell.lblTongGiaTri.text = variableConfig.convert((String)(m_TongGiaTri))
            cell.lblDSGT.text = "Danh sách gói thầu (" + (String)(m_countGoiThau) + " gói thầu )"
            
            
            cell.uiViewLHD.layer.borderColor = myColorBoder.cgColor
            cell.uiViewLHD.layer.borderWidth = 0.5
            
            cell.uiViewSTT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewSTT.layer.borderWidth = 0.5
            
            cell.uiViewDSGT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewDSGT.layer.borderWidth = 0.5
            
            cell.uiView_GiaGT.layer.borderColor = myColorBoder.cgColor
            cell.uiView_GiaGT.layer.borderWidth = 0.5
            
            cell.uiViewGiaGoiThau.layer.borderColor = myColorBoder.cgColor
            cell.uiViewGiaGoiThau.layer.borderWidth = 0.5
            
            cell.uiViewdetail.layer.borderColor = myColorBoder.cgColor
            cell.uiViewdetail.layer.borderWidth = 0.5
            
            cell.uiViewHTLCNT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHTLCNT.layer.borderWidth = 0.5
            
            cell.uiViewPTLCNT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewPTLCNT.layer.borderWidth = 0.5
            
            cell.uiViewTenGoiThau.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTenGoiThau.layer.borderWidth = 0.5
            
            cell.uiViewTongGiaTri.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTongGiaTri.layer.borderWidth = 0.5
            return cell
            
        }
        else {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHLCNT_HD_Landscape", for: indexPath) as! Cell_KHLCNT_HD_Landscape
            cell.lblSTT.text = (String)(index - 3)
            
            cell.constraintRightTenGT.constant = wTongGiaTri + 180 - 8
            
            cell.lblTenGT.text = m_dsGoiThau[index - 4].TenGT!
            //cell.lblTenGoiThau.numberOfLines = 0
            //  cell.lblTenGoiThau.sizeToFit()
            
            cell.lblGiaGT.text = variableConfig.convert(m_dsGoiThau[index - 4].GiaGT!)
            
          
            cell.lblHTLCNT.text = m_dsGoiThau[index - 4].HinhThucLCNT!
            
            
            cell.lblPHLCNT.text = m_dsGoiThau[index - 4].PhuongThucLCNT!
           
            cell.lblLoaiHD.text = m_dsGoiThau[index - 4].LoaiHopDong!
            
          
            cell.uiViewSTT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewSTT.layer.borderWidth = 0.5
            
            cell.uiViewPTLCNT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewPTLCNT.layer.borderWidth = 0.5
            
            cell.uiViewHTLCNT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewHTLCNT.layer.borderWidth = 0.5
            
            cell.uiViewGiaGT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewGiaGT.layer.borderWidth = 0.5
            
            cell.uiViewTenGT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTenGT.layer.borderWidth = 0.5
            
       //     cell.uiViewDetail.backgroundColor = myColorBackgroud
            cell.uiViewLoaiHD.layer.borderColor = myColorBoder.cgColor
            cell.uiViewLoaiHD.layer.borderWidth = 0.5
            
          
            
            return cell
        }
        
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
    func duAnConClickDetail(sender: UITapGestureRecognizer)
    {
        //print(sender.view?.tag)
        let value : Int = (sender.view?.tag)!
        // print(value)
        
        //  print(self.expandedCellPaths)
        if self.indexTrangThaiGoiThau.contains(value) {
            self.indexTrangThaiGoiThau.remove(value)
        }
        else {
            self.indexTrangThaiGoiThau.insert(value)
            
        }
        self.tbvKHLCNT?.rowHeight = UITableViewAutomaticDimension
        self.tbvKHLCNT?.estimatedRowHeight = 60
        self.tbvKHLCNT?.beginUpdates()
        self.tbvKHLCNT?.endUpdates()
        self.tbvKHLCNT?.reloadData()
    }
    // Hàm tính size text
    func calulaterTextSize(text : String, size : CGSize) -> CGRect{
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13)], context: nil)
        return estimatedFrame
    }
    
    
}
