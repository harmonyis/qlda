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
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDSDA_Lanscape") as! CustomCellDSDA_Lanscape
       
        let itemNhomDA :DanhSachDA = self.DSDA[indexPath.section]
        let itemDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        
        
        //  let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        // cell.lblTenDuAn=label
        let msg  = itemDuAnCon[indexPath.row].TenDA!
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont.systemFont(ofSize: 13), myText: msg)
        
        let labelWidth = cell.lblTenDA.frame.width
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
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDSDA_Lanscape") as! CustomCellDSDA_Lanscape
        
        let itemNhomDA :DanhSachDA = self.DSDA[section]
        let msg  = itemNhomDA.TenDA!
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont.systemFont(ofSize: 13), myText: msg)
        
        let labelWidth = cell.lblTenDA.frame.width
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
    
    */
    // */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDSDA_Lanscape") as! CustomCellDSDA_Lanscape
        // cell.ght = 60
        //  cell.scrollEnabled = false
        let itemNhomDA :DanhSachDA = self.DSDA[section]
        cell.lblTenDA.text = itemNhomDA.TenDA!
        cell.lblTenDA.font = UIFont.systemFont(ofSize: 13)
        cell.lblTenDA.textAlignment = NSTextAlignment.left
       // cell.lblTenDA.sizeToFit()
        
         let heightTD = calulaterTextSize(text: itemNhomDA.TenDA!, size: CGSize(width: cell.lblTenDA.frame.width , height: 1000))
        cell.lblNhomDA.text = itemNhomDA.NhomDA!
       // cell.lblNhomDA.sizeToFit()
        cell.lblGiaiDoan.text = itemNhomDA.GiaiDoan!
       // cell.lblGiaiDoan.sizeToFit()
        cell.lblGTGN.text = variableConfig.convert(itemNhomDA.GiaTriGiaiNgan!)
       // cell.lblGTGN.sizeToFit()
        cell.lblTMDT.text = variableConfig.convert(itemNhomDA.TongMucDauTu!)
       // cell.lblTMDT.sizeToFit()
        cell.lblTGTH.text = itemNhomDA.ThoiGianThucHien!
      //  cell.lblTGTH.sizeToFit()
        cell.uiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.uiViewGroup.layer.borderWidth = 0.5
        cell.imgGroup.isHidden = false
       
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
        
        cell.uiViewTGTH.layer.borderColor = myColorBoder.cgColor
        cell.uiViewTGTH.layer.borderWidth = 0.5
        
       
        
        cell.uiViewTenDA.layer.borderColor = myColorBoder.cgColor
        cell.uiViewTenDA.layer.borderWidth = 0.5
        
        cell.uiViewGTGN.layer.borderColor = myColorBoder.cgColor
        cell.uiViewGTGN.layer.borderWidth = 0.5
        
        cell.uiViewTMDT.layer.borderColor = myColorBoder.cgColor
        cell.uiViewTMDT.layer.borderWidth = 0.5
        
        cell.uiViewNhomDA.layer.borderColor = myColorBoder.cgColor
        cell.uiViewNhomDA.layer.borderWidth = 0.5
        
        cell.uiViewGiaiDoan.layer.borderColor = myColorBoder.cgColor
        cell.uiViewGiaiDoan.layer.borderWidth = 0.5
        
        
        
        var eventClick = UITapGestureRecognizer()
        
        cell.imgGroup.tag = section
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.duAnChaClickGroup(sender: )))
        cell.imgGroup.addGestureRecognizer(eventClick)
        cell.imgGroup.isUserInteractionEnabled = true;
        
        eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.ClickTenDuAn(sender:)))
        cell.lblTenDA.tag = (Int)(itemNhomDA.IdDA!)!
        cell.lblTenDA.accessibilityLabel = (itemNhomDA.TenDA!)
        cell.lblTenDA.addGestureRecognizer(eventClick)
        cell.lblTenDA.isUserInteractionEnabled = true;
        
        cell.autoresizingMask = .flexibleWidth
        cell.autoresizingMask = .flexibleHeight
        
         cell.constraintHeightDA.constant = CGFloat(heightTD.height) + 20
        
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDSDA_Lanscape", for: indexPath) as! CustomCellDSDA_Lanscape
        let itemNhomDA :DanhSachDA = self.DSDA[indexPath.section]
        let itemDSDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        let itemDuAnCon : DuAn = itemDSDuAnCon[indexPath.row]
        
        //  let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        // cell.lblTenDuAn=label
        cell.lblTenDA.text = itemDuAnCon.TenDA!
        cell.lblTenDA.numberOfLines = 0
        cell.lblTenDA.font = UIFont.italicSystemFont(ofSize: 13)
        cell.lblTenDA.textAlignment = NSTextAlignment.left
      //  cell.lblTenDA.sizeToFit()
         let heightTD = calulaterTextSize(text: itemDuAnCon.TenDA!, size: CGSize(width: cell.lblTenDA.frame.width , height: 1000))
        
        
        //  cell.lblTenDuAn.lineBreakMode = wrap
        
        cell.lblNhomDA.text = itemDuAnCon.NhomDA!
     //   cell.lblNhomDA.sizeToFit()
        cell.lblGiaiDoan.text = itemDuAnCon.GiaiDoan!
    //    cell.lblGiaiDoan.sizeToFit()
        cell.lblGTGN.text = variableConfig.convert(itemDuAnCon.GiaTriGiaiNgan!)
    //    cell.lblGTGN.sizeToFit()
        cell.lblTMDT.text = variableConfig.convert(itemDuAnCon.TongMucDauTu!)
     //   cell.lblTMDT.sizeToFit()
        cell.lblTGTH.text = itemDuAnCon.ThoiGianThucHien!
     //   cell.lblTGTH.sizeToFit()
        cell.uiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.uiViewGroup.layer.borderWidth = 0.5
        
        cell.uiViewTGTH.layer.borderColor = myColorBoder.cgColor
        cell.uiViewTGTH.layer.borderWidth = 0.5
        
        // if !cell.imgGroup.isHidden
        cell.imgGroup.isHidden=true
        
        //  cell.UIViewTieuDe.layer.borderWidth=1
        
        cell.uiViewTenDA.layer.borderColor = myColorBoder.cgColor
        cell.uiViewTenDA.layer.borderWidth = 0.5
        
        cell.uiViewGTGN.layer.borderColor = myColorBoder.cgColor
        cell.uiViewGTGN.layer.borderWidth = 0.5
        
        cell.uiViewTMDT.layer.borderColor = myColorBoder.cgColor
        cell.uiViewTMDT.layer.borderWidth = 0.5
        
        cell.uiViewNhomDA.layer.borderColor = myColorBoder.cgColor
        cell.uiViewNhomDA.layer.borderWidth = 0.5
        
        cell.uiViewGiaiDoan.layer.borderColor = myColorBoder.cgColor
        cell.uiViewGiaiDoan.layer.borderWidth = 0.5
        
        
        var eventClick = UITapGestureRecognizer()
        let value=(String)(indexPath.section)+"-"+(String)(indexPath.row)
        
        eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.ClickTenDuAn(sender:)))
        cell.lblTenDA.accessibilityLabel = (itemDuAnCon.TenDA!)
        cell.lblTenDA.tag = (Int)(itemDuAnCon.IdDA!)!
        cell.lblTenDA.addGestureRecognizer(eventClick)
        cell.lblTenDA.isUserInteractionEnabled = true;
        
        print(heightTD.height)
         cell.constraintHeightDA.constant = CGFloat(heightTD.height) + 20
                
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
    // Hàm tính size text
    func calulaterTextSize(text : String, size : CGSize) -> CGRect{
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13)], context: nil)
        return estimatedFrame
    }
    
}
