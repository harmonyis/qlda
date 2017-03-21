//
//  TableKHLCNT_Portrait.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 20/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class TableKHLCNT_Portrait: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
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
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
    
    
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHLCNT_R2", for: indexPath) as! Cell_KHLCNT_R2
            cell.constraintLeftTenGoiThau.constant = wTongGiaTri + 30
            cell.constraintLeftTongGiaTri.constant = wTongGiaTri + 30
            
            cell.lblGiaTri.text = variableConfig.convert((String)(m_TongGiaTri))
            cell.lblcountDSGT.text = "Danh sách gói thầu (" + (String)(m_countGoiThau) + " gói thầu )"
            
            
            cell.uiView_R2.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R2.layer.borderWidth = 0.5
            
            cell.uiView_R2_STT.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R2_STT.layer.borderWidth = 0.5
            
            cell.uiView_R2_TenGT.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R2_TenGT.layer.borderWidth = 0.5
            
            cell.uiView_R2_GiaGoiThau.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R2_GiaGoiThau.layer.borderWidth = 0.5
            
            cell.uiView_R2_Detail.layer.borderColor = myColorBoder.cgColor
            cell.uiView_R2_Detail.layer.borderWidth = 0.5
            
            cell.uiViewTongGT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTongGT.layer.borderWidth = 0.5
            
            cell.uiViewTongGT_C1.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTongGT_C1.layer.borderWidth = 0.5
            
            cell.uiViewTongGT_C2.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTongGT_C2.layer.borderWidth = 0.5
            return cell
            
        }
        else {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHLCNT_R3", for: indexPath) as! Cell_KHLCNT_R3
            cell.lblSTT.text = (String)(index - 3)
            
            cell.constraintRightTenGoiThau.constant = wTongGiaTri + 30
            
            cell.lblTenGoiThau.text = m_dsGoiThau[index - 4].TenGT!
            //cell.lblTenGoiThau.numberOfLines = 0
            //  cell.lblTenGoiThau.sizeToFit()
            
            cell.lblGiaTriTT.text = variableConfig.convert(m_dsGoiThau[index - 4].GiaGT!)
            
            var targetString : String = "Hình thức LCNT: \(m_dsGoiThau[index - 4].HinhThucLCNT!)"
            var range = NSMakeRange(16, targetString.characters.count - 16 )
            cell.lblHinhThucLCNT.attributedText = attributedString(from: targetString, nonBoldRange: range)
            
            
            targetString = "Phương thức LCNT: \(m_dsGoiThau[index - 4].PhuongThucLCNT!)"
            range = NSMakeRange(19, targetString.characters.count - 19 )
            cell.lblPhuongThucLCNT.attributedText = attributedString(from: targetString, nonBoldRange: range)
            
            targetString = "Loại hợp đồng: \(m_dsGoiThau[index - 4].LoaiHopDong!)"
            range = NSMakeRange(16, targetString.characters.count - 16 )
            cell.lblLoaiHD.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
            cell.uiViewSTT.backgroundColor = myColorBackgroud
            cell.uiViewSTT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewSTT.layer.borderWidth = 0.5
            
            cell.uiViewTenGoiThau.backgroundColor = myColorBackgroud
            cell.uiViewTenGoiThau.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTenGoiThau.layer.borderWidth = 0.5
            
            cell.uiViewGiaTriTT.backgroundColor = myColorBackgroud
            cell.uiViewGiaTriTT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewGiaTriTT.layer.borderWidth = 0.5
            
            cell.uiViewThongTinCT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewThongTinCT.layer.borderWidth = 0.5
            
            cell.UiViewBDLeftTTCT.layer.borderColor = myColorBoder.cgColor
            cell.UiViewBDLeftTTCT.layer.borderWidth = 0.5
            
            cell.uiViewDetail.backgroundColor = myColorBackgroud
            cell.uiViewDetail.layer.borderColor = myColorBoder.cgColor
            cell.uiViewDetail.layer.borderWidth = 0.5
            
            cell.uiViewTieuDe.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTieuDe.layer.borderWidth = 0.5
         
            let eventClick = UITapGestureRecognizer()
            
            cell.uiViewDetail.tag = (Int)(m_dsGoiThau[index - 4].IdGT!)!
            eventClick.addTarget(self, action:  #selector(TableKHLCNT_Portrait.duAnConClickDetail(sender: )))
            cell.uiViewDetail.addGestureRecognizer(eventClick)
            cell.uiViewDetail.isUserInteractionEnabled = true;
            
            cell.uiViewThongTinCT.isHidden = !self.indexTrangThaiGoiThau.contains((Int)(m_dsGoiThau[index - 4].IdGT!)!)
         
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
