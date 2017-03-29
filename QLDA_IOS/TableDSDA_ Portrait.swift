//
//  TableDSDA_LanscapeTableViewController.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 13/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class TableDSDA_Portrait: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    var m_arrDSDA : [[String]] = []
    var DSDA = [DanhSachDA]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var tbDSDA : UITableView?
    var uiViewDSDA : UIViewController?
    var m_textHightLight : String = String()
    var m_caneSwipe =true
    // MARK: - Table view data source
    init(_ tbvDSDA: UITableView,arrDSDA: [DanhSachDA], tbvcDSDA: UIViewController , textHightLight : String = ""){
        super.init()
        self.DSDA = arrDSDA
        self.tbDSDA = tbvDSDA
        self.uiViewDSDA = tbvcDSDA
        self.m_textHightLight = textHightLight
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.DSDA.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(self.indexGroupDuAnCon.contains(section))
        {
            return 0
        }
        else {
            return self.DSDA[section].DuAnCon!.count
        }    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
      
        
        
        let itemNhomDA :DanhSachDA = self.DSDA[section]
        
        var targetString : String = itemNhomDA.TenDA!
        let rangeHL = (targetString.toUnsign() as NSString).range(of: m_textHightLight.toUnsign())
        
        cell.lblTenDuAn.font = UIFont.systemFont(ofSize: 13)
        let attributedStringHL = NSMutableAttributedString(string: itemNhomDA.TenDA!)
        attributedStringHL.addAttribute( NSForegroundColorAttributeName, value: UIColor.black, range: rangeHL)
         cell.lblTenDuAn.attributedText = attributedStringHL
        
        cell.lblTenDuAn.textAlignment = NSTextAlignment.left
        
        let heightTD = calulaterTextSize(text: itemNhomDA.TenDA!, size: CGSize(width: cell.lblTenDuAn.frame.width , height: 1000))
        
        
        targetString = "Nhóm: \(itemNhomDA.NhomDA!)"
        var range = NSMakeRange(6, targetString.characters.count - 6 )
        cell.lblNhomDuAn.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
        
        //  cell.lblNhomDuAn.text = itemNhomDA.NhomDA!
        targetString  = "Giai đoạn: \(itemNhomDA.GiaiDoan!)"
        range = NSMakeRange(10, targetString.characters.count - 10 )
        cell.lblGiaiDoan.attributedText = attributedString(from: targetString, nonBoldRange: range)
        //cell.lblGiaiDoan.text = itemNhomDA.GiaiDoan!
        
        targetString  = "Giá trị giải ngân: \(variableConfig.convert(itemNhomDA.GiaTriGiaiNgan!))"
        range = NSMakeRange(18, targetString.characters.count - 18 )
        cell.lblGiaTriGiaiNgan.attributedText = attributedString(from: targetString, nonBoldRange: range)
        // cell.lblGiaTriGiaiNgan.text = variableConfig.convert(itemNhomDA.GiaTriGiaiNgan!)
        
        targetString  = "Tổng mức đầu tư: \(variableConfig.convert(itemNhomDA.TongMucDauTu!))"
        range = NSMakeRange(16, targetString.characters.count - 16 )
        cell.lblTongDauTu.attributedText = attributedString(from: targetString, nonBoldRange: range)
        // cell.lblTongDauTu.text = variableConfig.convert(itemNhomDA.TongMucDauTu!)
        
        targetString  = "Thời gian thực hiện: \(itemNhomDA.ThoiGianThucHien!)"
        range = NSMakeRange(20, targetString.characters.count - 20 )
        cell.lblThoiGianThucHien.attributedText = attributedString(from: targetString, nonBoldRange: range)
        //     cell.lblThoiGianThucHien.text = itemNhomDA.ThoiGianThucHien!
        
        cell.UiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.UiViewGroup.layer.borderWidth = 0.5
        cell.imgGroup.isHidden = false
        cell.UiViewDetail.layer.borderColor = myColorBoder.cgColor
        cell.UiViewDetail.layer.borderWidth = 0.5
        var image : UIImage = UIImage(named:"ic_minus")!
        if (itemNhomDA.DuAnCon?.count)!>0 {
            
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
        
        //  cell.UIViewTieuDe.layer.borderWidth=1
        
        cell.UiViewTenDuAn.layer.borderColor = myColorBoder.cgColor
        cell.UiViewTenDuAn.layer.borderWidth = 0.5
        
        
        cell.UiViewThongTinChiTiet.layer.borderColor = myColorBoder.cgColor
        cell.UiViewThongTinChiTiet.layer.borderWidth = 0.5
        
        
        cell.UiViewBDThongTin.layer.borderColor = myColorBoder.cgColor
        cell.UiViewBDThongTin.layer.borderWidth = 0.5
        
        var eventClick = UITapGestureRecognizer()
        
        cell.UiViewDetail.tag = section
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.duAnChaClickDetail(sender: )))
        cell.UiViewDetail.addGestureRecognizer(eventClick)
        cell.UiViewDetail.isUserInteractionEnabled = true;
        
        eventClick = UITapGestureRecognizer()
        cell.imgGroup.tag = section
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.duAnChaClickGroup(sender: )))
        cell.imgGroup.addGestureRecognizer(eventClick)
        cell.imgGroup.isUserInteractionEnabled = true;
        
        eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.ClickTenDuAn(sender:)))
        cell.lblTenDuAn.tag = (Int)(itemNhomDA.IdDA!)!
        cell.lblTenDuAn.accessibilityLabel = (itemNhomDA.TenDA!)
        cell.lblTenDuAn.addGestureRecognizer(eventClick)
        cell.lblTenDuAn.isUserInteractionEnabled = true;
        
        
        cell.UIViewTieuDe.autoresizingMask = UIViewAutoresizing.flexibleTopMargin
        cell.UIViewTieuDe.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
        
        cell.UIViewTieuDe.autoresizesSubviews = true
        
        cell.UiViewThongTinChiTiet.isHidden = !self.indexTrangThaiDuAnCha.contains(section)
        
        if self.indexTrangThaiDuAnCha.contains(section) {
            cell.constraintHeightDA.constant = CGFloat(heightTD.height) + CGFloat(92) + 10
            cell.constraintHeightTieuDe.constant = CGFloat(heightTD.height) + 10
            cell.constrainHeightTTCT.constant = 92
            
            
        }
        else
        {
            cell.constraintHeightDA.constant = CGFloat(heightTD.height) + 10
            cell.constraintHeightTieuDe.constant = CGFloat(heightTD.height) + 10
            cell.constrainHeightTTCT.constant = 0
        }
        
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -50 {
            
            self.uiViewDSDA?.viewDidLoad()
        }
    }

    
    let myColorBoder : UIColor = variableConfig.m_borderColor
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell", for: indexPath) as! CustomCellDSDATableViewCell
        let itemNhomDA :DanhSachDA = self.DSDA[indexPath.section]
        let itemDSDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        let itemDuAnCon : DuAn = itemDSDuAnCon[indexPath.row]
        
        //  let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        // cell.lblTenDuAn=label
        cell.lblTenDuAn.textAlignment = NSTextAlignment.left
        
        var targetString : String = itemDuAnCon.TenDA!
        let rangeHL = (targetString.toUnsign() as NSString).range(of: m_textHightLight.toUnsign())
        
        cell.lblTenDuAn.font = UIFont.italicSystemFont(ofSize: 13)
        let attributedStringHL = NSMutableAttributedString(string: itemDuAnCon.TenDA!)
        attributedStringHL.addAttribute( NSForegroundColorAttributeName, value: UIColor.black, range: rangeHL)
        cell.lblTenDuAn.attributedText = attributedStringHL
        
        //  cell.lblTenDuAn.lineBreakMode = wrap
        let heightTD = calulaterTextSize(text: itemDuAnCon.TenDA!, size: CGSize(width: cell.lblTenDuAn.frame.width , height: 1000))
        
        
        targetString = "Nhóm: \(itemNhomDA.NhomDA!)"
        var range = NSMakeRange(6, targetString.characters.count - 6 )
        cell.lblNhomDuAn.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
        
        //  cell.lblNhomDuAn.text = itemNhomDA.NhomDA!
        targetString  = "Giai đoạn: \(itemDuAnCon.GiaiDoan!)"
        range = NSMakeRange(10, targetString.characters.count - 10 )
        cell.lblGiaiDoan.attributedText = attributedString(from: targetString, nonBoldRange: range)
        //cell.lblGiaiDoan.text = itemNhomDA.GiaiDoan!
        
        targetString  = "Giá trị giải ngân: \(variableConfig.convert(itemDuAnCon.GiaTriGiaiNgan!))"
        range = NSMakeRange(18, targetString.characters.count - 18 )
        cell.lblGiaTriGiaiNgan.attributedText = attributedString(from: targetString, nonBoldRange: range)
        // cell.lblGiaTriGiaiNgan.text = variableConfig.convert(itemNhomDA.GiaTriGiaiNgan!)
        
        targetString  = "Tổng mức đầu tư: \(variableConfig.convert(itemDuAnCon.TongMucDauTu!))"
        range = NSMakeRange(16, targetString.characters.count - 16 )
        cell.lblTongDauTu.attributedText = attributedString(from: targetString, nonBoldRange: range)
        // cell.lblTongDauTu.text = variableConfig.convert(itemNhomDA.TongMucDauTu!)
        
        targetString  = "Thời gian thực hiện: \(itemDuAnCon.ThoiGianThucHien!)"
        range = NSMakeRange(20, targetString.characters.count - 20 )
        cell.lblThoiGianThucHien.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
        
        
        cell.UiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.UiViewGroup.layer.borderWidth = 0.5
        
        cell.UiViewDetail.layer.borderColor = myColorBoder.cgColor
        cell.UiViewDetail.layer.borderWidth = 0.5
        // if !cell.imgGroup.isHidden
        cell.imgGroup.isHidden=true
        
        //  cell.UIViewTieuDe.layer.borderWidth=1
        
        cell.UiViewTenDuAn.layer.borderColor = myColorBoder.cgColor
        cell.UiViewTenDuAn.layer.borderWidth = 0.5
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(1)
        borderBottom.borderColor =  myColorBoder.cgColor
        borderBottom.borderWidth = borderWidth
        borderBottom.frame = CGRect(x: 0, y: cell.UiViewThongTinChiTiet.frame.height + 1, width: cell.UiViewThongTinChiTiet.frame.width, height: 1)
        cell.UiViewThongTinChiTiet.layer.addSublayer(borderBottom)
        cell.UiViewThongTinChiTiet.layer.masksToBounds = true
        
        
        cell.UiViewThongTinChiTiet.layer.borderColor = myColorBoder.cgColor
        cell.UiViewThongTinChiTiet.layer.borderWidth = 1
        //   cell.UiViewThongTinChiTiet.layer.masksToBounds=true
        
        cell.UiViewBDThongTin.layer.borderColor = myColorBoder.cgColor
        cell.UiViewBDThongTin.layer.borderWidth = 0.5
        
        
        var eventClick = UITapGestureRecognizer()
        let value=(String)(indexPath.section)+"-"+(String)(indexPath.row)
        cell.UiViewDetail.accessibilityLabel = value
        print(indexPath.row)
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.duAnConClickDetail(sender: )))
        
        cell.UiViewDetail.addGestureRecognizer(eventClick)
        cell.UiViewDetail.isUserInteractionEnabled = true;
        
        eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.ClickTenDuAn(sender:)))
        cell.lblTenDuAn.accessibilityLabel = (itemDuAnCon.TenDA!)
        cell.lblTenDuAn.tag = (Int)(itemDuAnCon.IdDA!)!
        cell.lblTenDuAn.addGestureRecognizer(eventClick)
        cell.lblTenDuAn.isUserInteractionEnabled = true;
        
        cell.UiViewThongTinChiTiet.isHidden = !self.indexTrangThaiDuAnCon.contains(value)
        
        if self.indexTrangThaiDuAnCon.contains(value) {
            cell.constraintHeightDA.constant = CGFloat(heightTD.height) + CGFloat(92) + 10
            cell.constraintHeightTieuDe.constant = CGFloat(heightTD.height) + 10
            cell.constrainHeightTTCT.constant = 92
            
            
        }
        else
        {
            cell.constraintHeightDA.constant = CGFloat(heightTD.height) + 10
            cell.constraintHeightTieuDe.constant = CGFloat(heightTD.height) + 10
            cell.constrainHeightTTCT.constant = 0
        }
        
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
