//
//  Tab_VanBanDuAnVC.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Tab_VanBanDuAnVC: UIViewController , UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider{

    var itemInfo = IndicatorInfo(title: "Quản lý văn bản")
    
    var arrVanBan : [VanBanEntity] = []
    let apiUrl = "\(UrlPreFix.QLDA.rawValue)/GetFile"
    @IBOutlet weak var viewLabelSTT: UIView!
    @IBOutlet weak var viewLabelTenDuAn: UIView!
    @IBOutlet weak var viewLabelDetail: UIView!
    var idDuAn : String = String(variableConfig.m_szIdDuAn)
    var userName : String = variableConfig.m_szUserName
    var password : String = variableConfig.m_szPassWord
    var arrOpen : Set<Int> = []
    
    @IBOutlet weak var tbVanBanDuAn: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbVanBanDuAn.rowHeight = UITableViewAutomaticDimension
        tbVanBanDuAn.estimatedRowHeight = 30
        tbVanBanDuAn.separatorColor = UIColor.clear
        loadData()
        addBorder()
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UITableViewDataSource
    
    
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func loadData() {
        let params = "{\"sDuAnID\":\"\(self.idDuAn)\",\"szUsername\":\"\(self.userName)\",\"szPassword\":\"\(self.password)\"}"
        
        ApiService.Post(url: apiUrl, params: params, callback: loadVanBanSuccess) { (error) in
            print("Có lỗi:\(error)")
        }
    
    }
    
    func loadVanBanSuccess(data: Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let jsonResult = dic["GetFileResult"] as? [[String]] {
                var vanBan : VanBanEntity
                for var item in jsonResult {
                    vanBan = VanBanEntity(tenVanBan: item[0], soVanBan: item[1], ngayBanHanh: item[2], coQuanBanHanh: item[3], tenFileVanBan: item[4], duongDan: item[5])
                    arrVanBan.append(vanBan)
                }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        
                        self.tbVanBanDuAn.reloadData()
                    }
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVanBan.count
    }
    
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VanBanDuAnTableViewCell
        cell.lblTenVanban.text = "\(arrVanBan[indexPath.row].tenVanBan)"
        cell.lblTenVanban.sizeToFit()
        
        //let tieuDeHeight = cell.lblTenVanban.frame.height + CGFloat(10)
        
        let w : Int = Int(cell.viewTieuDeTenVanBan.frame.width)
        let size = CGSize(width: w, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: "\(arrVanBan[indexPath.row].tenVanBan)").boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
        //print("Estimated\(estimatedFrame.height)")
        
        let tieuDeHeight = estimatedFrame.height +  CGFloat(10)
        //let tieuDeHeight : CGFloat = CGFloat(40)
        //cell.lblTenVanBanHeight.constant = (tieuDeHeight - CGFloat(10))
        //cell.lblTenVanBanTop.constant = 0
        //print("tiêu đề height \(tieuDeHeight)")
        
        
        let rowIndex = indexPath.row + 1
        
        cell.lblSoTT.text = String(rowIndex)
        

        
        //label.backgroundColor = UIColor.white
        
        
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
        
        var eventClick = UITapGestureRecognizer()
        //let value=(String)(indexPath.section)+"-"+(String)(indexPath.row)
        let value = String(indexPath.row)
        cell.viewTieuDeChiTiet.accessibilityLabel = value
        //print(indexPath.row)
        eventClick.addTarget(self, action:  #selector(Tab_VanBanDuAnVC.chiTietClick(sender: )))
        cell.viewTieuDeChiTiet.addGestureRecognizer(eventClick)
        cell.viewTieuDeChiTiet.isUserInteractionEnabled = true;
        

        var stkFrame : CGFloat = CGFloat(tieuDeHeight)
        
        let viewCTNDWidth = cell.viewChiTietNoiDung.frame.width - 20
        
        let h1 = calulaterTextSize(text: "Số văn bản: \(arrVanBan[indexPath.row].soVanBan)", size: CGSize(width: viewCTNDWidth , height: 1000))
        
        let h2 = calulaterTextSize(text: "Ngày ban hành: \(arrVanBan[indexPath.row].ngayBanHanh)", size: CGSize(width: viewCTNDWidth , height: 1000))
        
        let h3 = calulaterTextSize(text: "Cơ quan ban hành: \(arrVanBan[indexPath.row].coQuanBanHanh)", size: CGSize(width: viewCTNDWidth , height: 1000))
        
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
        tbVanBanDuAn.reloadData()
        //print(value)
        
    }

    func addBorder() {
        let backgorund = UIColor(netHex: 0x21affa)
        self.viewLabelSTT.layer.borderColor = myColorBoder.cgColor
        self.viewLabelSTT.layer.borderWidth = 0.5
        self.viewLabelSTT.backgroundColor = backgorund
        
        self.viewLabelDetail.layer.borderColor = myColorBoder.cgColor
        self.viewLabelDetail.layer.borderWidth = 0.5
        self.viewLabelDetail.backgroundColor = backgorund
        
        self.viewLabelTenDuAn.layer.borderColor = myColorBoder.cgColor
        self.viewLabelTenDuAn.layer.borderWidth = 0.5
        self.viewLabelTenDuAn.backgroundColor = backgorund
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
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }*/
 
 
 
    
    
}
