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
    var wTMDT : CGFloat = 0
    var wGN : CGFloat = 0
    var m_textHightLight : String = String()
    var m_caneSwipe = false
    // MARK: - Table view data source
    init(_ tbvDSDA: UITableView,arrDSDA: [DanhSachDA], tbvcDSDA: UIViewController){
        super.init()
        self.DSDA = arrDSDA
        self.tbDSDA = tbvDSDA
        self.uiViewDSDA = tbvcDSDA
           }
    
    init(_ tbvDSDA: UITableView,arrDSDA: [DanhSachDA], tbvcDSDA: UIViewController, wTMDT : CGFloat, wGN : CGFloat , textHightLight: String = ""){
        super.init()
        m_caneSwipe = false
        self.DSDA = arrDSDA
        self.tbDSDA = tbvDSDA
        self.uiViewDSDA = tbvcDSDA
        self.wTMDT = wTMDT
        self.wGN = wGN
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDSDA_Lanscape") as! CustomCellDSDA_Lanscape
        let width = tableView.frame.width - 20
        print(width)
        let wTotal = width - wGN - wTMDT
        
        cell.constrainWidthGroup.constant = 20
        cell.constrainWidthTenDuAn.constant = 20
        
        cell.constrainWidthNhomDA.constant = 20 + 45*wTotal/100
        cell.constrainWidthGiaiDoan.constant = 20 + 60*wTotal/100
        cell.constrainWidthTGTH.constant = 20 + 80*wTotal/100
        cell.constrainWidthTMDT.constant = 20 + wTotal
        cell.constrainWidthGTGN.constant = 20 + wTotal + wTMDT
        
        // cell.ght = 60
        //  cell.scrollEnabled = false
        let itemNhomDA :DanhSachDA = self.DSDA[section]
       
        var targetString : String = itemNhomDA.TenDA!
        let rangeHL = (targetString.toUnsign() as NSString).range(of: m_textHightLight.toUnsign())
        
        cell.lblTenDA.font = UIFont.systemFont(ofSize: 13)
        let attributedStringHL = NSMutableAttributedString(string: itemNhomDA.TenDA!)
        attributedStringHL.addAttribute( NSForegroundColorAttributeName, value: UIColor.black, range: rangeHL)
        cell.lblTenDA.attributedText = attributedStringHL
        
        cell.lblTenDA.textAlignment = NSTextAlignment.left
       // cell.lblTenDA.sizeToFit()
        
        cell.lblNhomDA.text = itemNhomDA.NhomDA!
       // cell.lblNhomDA.sizeToFit()
        cell.lblGiaiDoan.text = itemNhomDA.GiaiDoan!
       // cell.lblGiaiDoan.sizeToFit()
        cell.lblTMDT.text = variableConfig.convert(itemNhomDA.GiaTriGiaiNgan!)
       // cell.lblGTGN.sizeToFit()
        cell.lblGTGN.text = variableConfig.convert(itemNhomDA.TongMucDauTu!)
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
        
      //   cell.constraintHeightDA.constant = CGFloat(heightTD.height) + 20
        
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
        
        if m_caneSwipe == false && scrollView.contentOffset.y < -50 {
            m_caneSwipe = true
            self.uiViewDSDA?.viewDidLoad()
            
            
        }
    }
    /*    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.DSDA.count
     }
     */
    let myColorBoder : UIColor = variableConfig.m_borderColor
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDSDA_Lanscape", for: indexPath) as! CustomCellDSDA_Lanscape
     
        let width = tableView.frame.width - 20
        cell.constrainWidthGroup.constant = 20
        cell.constrainWidthTenDuAn.constant = 20
        print(width)
        let wTotal = width - wGN - wTMDT
        
        cell.constrainWidthGroup.constant = 20
        cell.constrainWidthTenDuAn.constant = 20
        
        cell.constrainWidthNhomDA.constant = 20 + 45*wTotal/100
        cell.constrainWidthGiaiDoan.constant = 20 + 60*wTotal/100
        cell.constrainWidthTGTH.constant = 20 + 80*wTotal/100
        cell.constrainWidthTMDT.constant = 20 + wTotal
        cell.constrainWidthGTGN.constant = 20 + wTotal + wTMDT
        
        /*
        cell.constrainWidthNhomDA.constant = (CGFloat)(180*width/550) + 20
        cell.constrainWidthGiaiDoan.constant = (CGFloat)(240*width/550) + 20
        cell.constrainWidthTGTH.constant = (CGFloat)(320*width/550) + 20
        cell.constrainWidthTMDT.constant = (CGFloat)(390*width/550) + 20
        cell.constrainWidthGTGN.constant = (CGFloat)(470*width/550) + 20
        */
        
        
        let itemNhomDA :DanhSachDA = self.DSDA[indexPath.section]
        let itemDSDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        let itemDuAnCon : DuAn = itemDSDuAnCon[indexPath.row]
        
        //  let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        // cell.lblTenDuAn=label
        cell.lblTenDA.textAlignment = NSTextAlignment.left
        
        var targetString : String = itemDuAnCon.TenDA!
        let rangeHL = (targetString.toUnsign() as NSString).range(of: m_textHightLight.toUnsign())
        
        cell.lblTenDA.font = UIFont.italicSystemFont(ofSize: 13)
        let attributedStringHL = NSMutableAttributedString(string: itemDuAnCon.TenDA!)
        attributedStringHL.addAttribute( NSForegroundColorAttributeName, value: UIColor.black, range: rangeHL)
        cell.lblTenDA.attributedText = attributedStringHL
      //  cell.lblTenDA.sizeToFit()
             //  cell.lblTenDuAn.lineBreakMode = wrap
        
        cell.lblNhomDA.text = itemDuAnCon.NhomDA!
     //   cell.lblNhomDA.sizeToFit()
        cell.lblGiaiDoan.text = itemDuAnCon.GiaiDoan!
    //    cell.lblGiaiDoan.sizeToFit()
        cell.lblTMDT.text = variableConfig.convert(itemDuAnCon.GiaTriGiaiNgan!)
    //    cell.lblGTGN.sizeToFit()
        cell.lblGTGN.text = variableConfig.convert(itemDuAnCon.TongMucDauTu!)
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
        
        
        eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(TableDSDA_Portrait.ClickTenDuAn(sender:)))
        cell.lblTenDA.accessibilityLabel = (itemDuAnCon.TenDA!)
        cell.lblTenDA.tag = (Int)(itemDuAnCon.IdDA!)!
        cell.lblTenDA.addGestureRecognizer(eventClick)
        cell.lblTenDA.isUserInteractionEnabled = true;
        
      //  print(heightTD.height)
        // cell.constraintHeightDA.constant = CGFloat(heightTD.height) + 20
                
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
