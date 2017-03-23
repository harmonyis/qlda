//
//  TableDSDAMap_Portrait.swift
//  QLDA_IOS
//
//  Created by namos on 3/15/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import GoogleMaps

class TableDSDAMap_Portrait : NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    var m_arrDSDA : [[String]] = []
    var DSDA = [DanhSachDA]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var tbDSDA : UITableView?
    var uiViewDSDA : UIViewController?
    var _uiMapView: GMSMapView!
    var _dicMarker: [Int: GMSMarker] = [:]
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    let myColorText : UIColor = UIColor(netHex: 0x0e83d5)
    let mycolorSelected : UIColor = UIColor.red
    var DuAnSelected : String = "0"
    
    // MARK: - Table view data source
    init(_ tbvDSDA: UITableView,arrDSDA: [DanhSachDA], tbvcDSDA: UIViewController, uiMapView : GMSMapView,dicMarker:[Int: GMSMarker]){
        super.init()
        self.DSDA = arrDSDA
        self.tbDSDA = tbvDSDA
        self.uiViewDSDA = tbvcDSDA
        self._uiMapView = uiMapView
        self._dicMarker = dicMarker
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
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
        
        let itemDAs :DanhSachDA = self.DSDA[section]
        cell.lblTenDuAn.text = itemDAs.TenDA!
        cell.lblTenDuAn.font = UIFont.systemFont(ofSize: 13)
        cell.lblTenDuAn.textAlignment = NSTextAlignment.left
        let idDA = Int(itemDAs.IdDA!)
        if(_dicMarker[idDA!] == nil){
            cell.lblTenDuAn.textColor = myColorBoder
        }
        else{
            if(itemDAs.IdDA == DuAnSelected){
                cell.lblTenDuAn.textColor = mycolorSelected
            }else{
                cell.lblTenDuAn.textColor = myColorText
            }
        }

        
        cell.UiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.UiViewGroup.layer.borderWidth = 0.5
        cell.imgGroup.isHidden = false

        var image : UIImage = UIImage(named:"ic_minus")!
        if (itemDAs.DuAnCon?.count)!>0 {
            
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
        
        var eventClick = UITapGestureRecognizer()
        
        cell.imgGroup.tag = section
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.duAnChaClickGroup(sender: )))
        cell.imgGroup.addGestureRecognizer(eventClick)
        cell.imgGroup.isUserInteractionEnabled = true;
        
        eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.ClickTenDuAn(sender:)))
        cell.lblTenDuAn.tag = (Int)(itemDAs.IdDA!)!
        cell.lblTenDuAn.accessibilityLabel = (itemDAs.TenDA!)
        cell.lblTenDuAn.addGestureRecognizer(eventClick)
        cell.lblTenDuAn.isUserInteractionEnabled = true;
        
        
        cell.UIViewTieuDe.autoresizingMask = UIViewAutoresizing.flexibleTopMargin
        cell.UIViewTieuDe.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
        
        cell.UIViewTieuDe.autoresizesSubviews = true
    
        return cell
    }
    func duAnChaClickGroup(sender: UITapGestureRecognizer)
    {
        let value  = (sender.view?.tag)
        
        if self.indexGroupDuAnCon.contains(value!) {
            self.indexGroupDuAnCon.remove(value!)
        }
        else {
            self.indexGroupDuAnCon.insert(value!)
            
        }
        self.tbDSDA?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell", for: indexPath) as! CustomCellDSDATableViewCell
        let itemDAs :DanhSachDA = self.DSDA[indexPath.section]
        let itemDSDuAnCon :[DuAn] = itemDAs.DuAnCon!
        let itemDuAnCon : DuAn = itemDSDuAnCon[indexPath.row]
        
        cell.lblTenDuAn.text = itemDuAnCon.TenDA!
        cell.lblTenDuAn.numberOfLines = 0
        cell.lblTenDuAn.font = UIFont.italicSystemFont(ofSize: 13)
        cell.lblTenDuAn.textAlignment = NSTextAlignment.left
        
        let idDACon = Int(itemDuAnCon.IdDA!)
        if(_dicMarker[idDACon!] == nil){
            cell.lblTenDuAn.textColor = myColorBoder
        }
        else{
            if(itemDuAnCon.IdDA == DuAnSelected){
                cell.lblTenDuAn.textColor = mycolorSelected
            }
            else{
                cell.lblTenDuAn.textColor = myColorText
            }
        }
      
     
        
        cell.UiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.UiViewGroup.layer.borderWidth = 0.5
        

        // if !cell.imgGroup.isHidden
        cell.imgGroup.isHidden=true
        
    
        cell.UiViewTenDuAn.layer.borderColor = myColorBoder.cgColor
        cell.UiViewTenDuAn.layer.borderWidth = 0.5
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(1)
        borderBottom.borderColor =  myColorBoder.cgColor
        borderBottom.borderWidth = borderWidth
        
        let eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.ClickTenDuAn(sender:)))
        cell.lblTenDuAn.accessibilityLabel = (itemDuAnCon.TenDA!)
        cell.lblTenDuAn.tag = (Int)(itemDuAnCon.IdDA!)!
        cell.lblTenDuAn.addGestureRecognizer(eventClick)
        cell.lblTenDuAn.isUserInteractionEnabled = true;
    
        return cell
    }
    

    func ClickTenDuAn(sender: UITapGestureRecognizer)
    {
        let idDuAn = (sender.view?.tag)!
        if(_dicMarker[idDuAn] != nil){
            self.DuAnSelected = String(idDuAn)
            let label:UILabel = (sender.view!) as! UILabel
            label.textColor = mycolorSelected

            let map_VC = Map_VC()
            map_VC.setViTri(idDA: idDuAn,uiMapView: _uiMapView)
            
        }
        self.tbDSDA?.reloadData()
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

