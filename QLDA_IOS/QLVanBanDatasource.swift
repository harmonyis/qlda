//
//  QLVanBanDatasource.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/20/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation

class QLVanBanDatasource : NSObject, UITableViewDataSource ,UITableViewDelegate{
    
    var arrVanBan : [VanBanEntity]
    var table :UITableView
    var arrOpen : Set<Int> = []
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    var tenVBClick : (VanBanEntity) -> Void
    var uiViewVB : UIViewController?
    var m_caneSwipe = false
    init (arrVanBan : [VanBanEntity], table : UITableView , ViewVB : UIViewController, tenVanBanClick: @escaping (VanBanEntity) -> Void) {
        self.arrVanBan = arrVanBan
        self.table = table
        self.tenVBClick = tenVanBanClick
        self.uiViewVB = ViewVB
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if m_caneSwipe == false && scrollView.contentOffset.y < -50 {
            m_caneSwipe = true
            self.uiViewVB?.viewDidLoad()
        }
        else if scrollView.contentOffset.y > 0 {
            self.m_caneSwipe = false
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Chỉ số \(section)")
        return self.arrVanBan.count
    }
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VanBanDuAnTableViewCell
        cell.lblTenVanban.text = "\(arrVanBan[indexPath.row].tenVanBan)"
        cell.lblTenVanban.sizeToFit()
        
        //let tieuDeHeight = cell.lblTenVanban.frame.height + CGFloat(10)
        
        let w : Int = Int(cell.viewTieuDeTenVanBan.frame.width - 5)
        let size = CGSize(width: w, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: "\(arrVanBan[indexPath.row].tenVanBan)").boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
        let tieuDeHeight = estimatedFrame.height +  CGFloat(10)
        
        
        let rowIndex = indexPath.row + 1
        
        cell.lblSoTT.text = String(rowIndex)
        
        
        
        //label.backgroundColor = UIColor.white
        
        var eventClick = UITapGestureRecognizer()
        //let value=(String)(indexPath.section)+"-"+(String)(indexPath.row)
        let valueTenVB = String(indexPath.row)
        cell.viewTieuDeTenVanBan.accessibilityLabel = valueTenVB
        //print(indexPath.row)
        eventClick.addTarget(self, action:  #selector(QLVanBanDatasource.tenVanBanClick(sender:)))
        cell.viewTieuDeTenVanBan.addGestureRecognizer(eventClick)
        cell.viewTieuDeTenVanBan.isUserInteractionEnabled = true
        
        
        
        var targetString : String = "Số văn bản: \(arrVanBan[indexPath.row].soVanBan)"
        var range = NSMakeRange(12, targetString.characters.count - 12	)
        
        cell.lblSoVanBan.attributedText = attributedString(from: targetString, nonBoldRange: range)
        cell.lblSoVanBan.sizeToFit()
        
        
        
        targetString = "Ngày ban hành: \(arrVanBan[indexPath.row].ngayBanHanh)"
        range = NSMakeRange(15, targetString.characters.count - 15)
        
        cell.lblNgayBanHanh.attributedText = attributedString(from: targetString, nonBoldRange: range)
        cell.lblNgayBanHanh.sizeToFit()
        
        
        targetString = "Cơ quan ban hành: \(arrVanBan[indexPath.row].coQuanBanHanh)"
        range = NSMakeRange(18, targetString.characters.count - 18)
        cell.lblCoQuanBanHanh.attributedText = attributedString(from: targetString, nonBoldRange: range)
        cell.lblCoQuanBanHanh.sizeToFit()
        
        let bg = UIColor(netHex: 0xB4e2f7)
        cell.viewTieuDe.layer.borderColor = myColorBoder.cgColor
        cell.viewTieuDe.layer.borderWidth = 0.5
        //cell.viewTieuDe.backgroundColor = bg
        
        cell.viewChiTiet.layer.borderColor = myColorBoder.cgColor
        cell.viewChiTiet.layer.borderWidth = 0.5
        //cell.viewChiTiet.backgroundColor = bg
        
        cell.viewTieuDeSTT.layer.borderColor = myColorBoder.cgColor
        cell.viewTieuDeSTT.layer.borderWidth = 0.5
        cell.viewTieuDeSTT.backgroundColor = bg
        
        
        cell.viewTieuDeTenVanBan.backgroundColor = bg
        cell.viewTieuDeChiTiet.backgroundColor = bg
        
        
        
        
        var borderRight = CALayer()
        var borderWidth = CGFloat(1)
        borderRight.borderColor =  myColorBoder.cgColor
        borderRight.borderWidth = borderWidth
        borderRight.frame = CGRect(x: 0, y: 0 ,width: 1, height: tieuDeHeight)
        
        
        
        cell.viewTieuDeTenVanBan.layer.addSublayer(borderRight)
        
        borderRight = CALayer()
        borderWidth = CGFloat(1)
        borderRight.borderColor =  myColorBoder.cgColor
        borderRight.borderWidth = borderWidth
        borderRight.frame = CGRect(x: 0, y: 0 ,width: 1, height: tieuDeHeight)
        
        cell.viewTieuDeChiTiet.layer.addSublayer(borderRight)
        
        borderRight = CALayer()
        borderWidth = CGFloat(1)
        borderRight.borderColor =  myColorBoder.cgColor
        borderRight.borderWidth = borderWidth
        borderRight.frame = CGRect(x: 0, y: 0 ,width: 1, height: cell.viewChiTietNoiDung.frame.height)
        
        cell.viewChiTietNoiDung.layer.addSublayer(borderRight)
        //cell.viewTieuDeChiTiet.layer.masksToBounds = true
        //cell.viewTieuDeTenVanBan.layer.masksToBounds = true
        
        eventClick = UITapGestureRecognizer()
        //let value=(String)(indexPath.section)+"-"+(String)(indexPath.row)
        let value = String(indexPath.row)
        cell.viewTieuDeChiTiet.accessibilityLabel = value
        //print(indexPath.row)
        eventClick.addTarget(self, action:  #selector(QLVanBanDatasource.chiTietClick(sender: )))
        cell.viewTieuDeChiTiet.addGestureRecognizer(eventClick)
        cell.viewTieuDeChiTiet.isUserInteractionEnabled = true;
        
        
        var stkFrame : CGFloat = CGFloat(tieuDeHeight)
        
        let viewCTNDWidth = cell.viewChiTietNoiDung.frame.width - 20
        
        let h1 = calulaterTextSize(text: "Số văn bản: \(arrVanBan[indexPath.row].soVanBan)", size: CGSize(width: viewCTNDWidth - 10 , height: 1000))
        
        let h2 = calulaterTextSize(text: "Ngày ban hành: \(arrVanBan[indexPath.row].ngayBanHanh)", size: CGSize(width: viewCTNDWidth - 10, height: 1000))
        
        let h3 = calulaterTextSize(text: "Cơ quan ban hành: \(arrVanBan[indexPath.row].coQuanBanHanh)", size: CGSize(width: viewCTNDWidth - 10, height: 1000))
        
        let h = h1.height + h2.height + h3.height
        //print(h)
        //print("view ::::: \(cell.viewChiTietNoiDung.frame.width)")
        if arrOpen.contains(indexPath.row) {
            //stkFrame = 110
            stkFrame = h + CGFloat(25) + CGFloat(tieuDeHeight)
        }
        
        cell.viewTieuDeHeight.constant = tieuDeHeight
        
        cell.stkHeight.constant = stkFrame
        
        
        cell.viewChiTietHeight.constant = (stkFrame - tieuDeHeight)
        
        
        
        
        
        //cell.lblSoVanBan.sizeToFit()
        
        
        
        
        
        //print(cell.frame.height)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderPort") as! HeaderTableViewCell
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        return cell
    }

    
    func calulaterTextSize(text : String, size : CGSize) -> CGRect{
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13)], context: nil)
        return estimatedFrame
    }
    
    func chiTietClick(sender: UITapGestureRecognizer) {
        let value : Int = Int((sender.view?.accessibilityLabel)!)!
        if arrOpen.contains(value) {
            arrOpen.remove(value)
        } else {
            arrOpen.insert(value)
        }
        //print("Giá trị dòng \(value)")
        self.table.reloadData()
        //print(value)
        
    }
    
    func tenVanBanClick(sender:UITapGestureRecognizer) {
        let value : Int = Int((sender.view?.accessibilityLabel)!)!
        //print(value)
        self.tenVBClick(arrVanBan[value])
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
    
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSFontAttributeName: font]
        let size = (myText as NSString).size(attributes: fontAttributes)
        
        return size
        
    }
}
