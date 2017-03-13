//
//  TableDSDA_Lanscape.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 13/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class TableDSDA_Lanscape: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    var m_arrDSDA : [[String]] = []
    var DSDA = [DanhSachDA]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var tbDSDA : UITableView?
    var uiViewDSDA : UIViewController?
    
    // MARK: - Table view data source
    init(_ tbvDSDA: UITableView,arrDSDA: [DanhSachDA], tbvcDSDA: UIViewController){
        super.init()
        self.DSDA = arrDSDA
        self.tbDSDA = tbvDSDA
        self.uiViewDSDA = tbvcDSDA
        
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
    
    /* func numberOfSections(_ tableView: UITableView) -> Int {
     return self.DSDA.count
     }
     
     
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
     if(self.indexGroupDuAnCon.contains(section))
     {
     return 0
     }
     else {
     return self.DSDA[section].DuAnCon!.count
     }
     }
     
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
        
        let itemNhomDA :DanhSachDA = self.DSDA[indexPath.section]
        let itemDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        
        
        //  let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        // cell.lblTenDuAn=label
        let msg  = itemDuAnCon[indexPath.row].TenDA!
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont.systemFont(ofSize: 13), myText: msg)
        
        let labelWidth = cell.lblTenDuAn.frame.width
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        //let height =  tableView.rowHeight - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
        var height = CGFloat(labelLines * (stringSizeAsText.height + 3)*1.3)
        if height<30
        {
            height=30
        }
        print(height)
        if !self.indexTrangThaiDuAnCon.contains((String)(indexPath.section)+"-"+(String)(indexPath.row)) {
            
            return height + 2
            
        }
        return   height + 150
        
    }
    
    
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSFontAttributeName: font]
        let size = (myText as NSString).size(attributes: fontAttributes)
        return size
        
    }
    
    /*
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
     return UITableViewAutomaticDimension
     }
     */
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
        
        let itemNhomDA :DanhSachDA = self.DSDA[section]
        let msg  = itemNhomDA.TenDA!
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont.systemFont(ofSize: 13), myText: msg)
        
        let labelWidth = cell.lblTenDuAn.frame.width
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        //let height =  tableView.rowHeight - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
        var height = CGFloat(labelLines * (stringSizeAsText.height + 3)*1.3)
        
        if height<30
        {
            height=30
        }
        
        if !self.indexTrangThaiDuAnCha.contains(section) {
            
            return height + 2
            
        }
        return height + 150
    }
    
    
    // */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
        // cell.ght = 60
        //  cell.scrollEnabled = false
        let itemNhomDA :DanhSachDA = self.DSDA[section]
        cell.lblTenDuAn.text = itemNhomDA.TenDA!
        cell.lblTenDuAn.font = UIFont.systemFont(ofSize: 13)
        cell.lblTenDuAn.textAlignment = NSTextAlignment.left
        cell.lblNhomDuAn.text = itemNhomDA.NhomDA!
        cell.lblGiaiDoan.text = itemNhomDA.GiaiDoan!
        cell.lblGiaTriGiaiNgan.text = variableConfig.convert(itemNhomDA.GiaTriGiaiNgan!)
        cell.lblTongDauTu.text = variableConfig.convert(itemNhomDA.TongMucDauTu!)
        cell.lblThoiGianThucHien.text = itemNhomDA.ThoiGianThucHien!
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
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(1)
        borderBottom.borderColor =  myColorBoder.cgColor
        borderBottom.borderWidth = borderWidth
        borderBottom.frame = CGRect(x: 0, y: cell.UiViewBDThongTinCT.frame.height - 1, width: cell.UiViewBDThongTinCT.frame.width, height: 1)
        cell.UiViewBDThongTinCT.layer.addSublayer(borderBottom)
        cell.UiViewBDThongTinCT.layer.masksToBounds = true
        
        
        
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
    
    
    /*    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.DSDA.count
     }
     */
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell", for: indexPath) as! CustomCellDSDATableViewCell
        let itemNhomDA :DanhSachDA = self.DSDA[indexPath.section]
        let itemDSDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        let itemDuAnCon : DuAn = itemDSDuAnCon[indexPath.row]
        
        //  let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        // cell.lblTenDuAn=label
        cell.lblTenDuAn.text = itemDuAnCon.TenDA!
        cell.lblTenDuAn.numberOfLines = 0
        cell.lblTenDuAn.font = UIFont.italicSystemFont(ofSize: 13)
        cell.lblTenDuAn.textAlignment = NSTextAlignment.left
        //  cell.lblTenDuAn.lineBreakMode = wrap
        
        cell.lblNhomDuAn.text = itemDuAnCon.NhomDA!
        cell.lblGiaiDoan.text = itemDuAnCon.GiaiDoan!
        cell.lblGiaTriGiaiNgan.text = variableConfig.convert(itemDuAnCon.GiaTriGiaiNgan!)
        cell.lblTongDauTu.text = variableConfig.convert(itemDuAnCon.TongMucDauTu!)
        cell.lblThoiGianThucHien.text = itemDuAnCon.ThoiGianThucHien!
        
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
        borderBottom.frame = CGRect(x: 0, y: cell.UiViewBDThongTinCT.frame.height - 1, width: cell.UiViewBDThongTinCT.frame.width, height: 1)
        cell.UiViewBDThongTinCT.layer.addSublayer(borderBottom)
        cell.UiViewBDThongTinCT.layer.masksToBounds = true
        
        
        cell.UiViewThongTinChiTiet.layer.borderColor = myColorBoder.cgColor
        cell.UiViewThongTinChiTiet.layer.borderWidth = 0.5
        //   cell.UiViewThongTinChiTiet.layer.masksToBounds=true
        
        cell.UiViewBDThongTin.layer.borderColor = myColorBoder.cgColor
        cell.UiViewBDThongTin.layer.borderWidth = 0.5
        
        //  cell.UiViewContent.layer.borderWidth=1
        /* if let image = feedEntry.image {
         cell.trackAlbumArtworkView.image = image
         } else {
         feedManager.fetchImageAtIndex(index: indexPath.row, completion: { (index) in
         self.handleImageLoadForIndex(index: index)
         })
         }
         
         cell.audioPlaybackView.isHidden = !expandedCellPaths.contains(indexPath)
         */
        
        // cell.imgDetail.addTarget(self, action: #selector(DSDA_VC.tappedMe()))
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
        print("ssssss")
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
    
}
