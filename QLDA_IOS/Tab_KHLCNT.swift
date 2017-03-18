//
//  Tab_KHLCNT.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 08/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip

class Tab_KHLCNT: UIViewController , UITableViewDataSource, UITableViewDelegate ,IndicatorInfoProvider{

    @IBOutlet weak var tbDSDA: UITableView!
    var m_dsGoiThau = [GoiThau]()
    var m_countGoiThau : Int = 0
    var m_TongGiaTri : Int = 0
    var m_thongTinKHLCNT : [String] = []
    var indexTrangThaiGoiThau = Set<Int>()
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "KHLCNT")
    let arrTieuDe = ["Số quyết định","Ngày phê duyệt","Cơ quan phê duyệt"]
    
    var wTongGiaTri : CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tbDSDA.separatorColor = UIColor.clear
        self.tbDSDA.rowHeight = UITableViewAutomaticDimension
        self.tbDSDA.estimatedRowHeight = 60
        //let szUser=lblName.
        let params : String = "{\"szIdDA\": \""+(String)(variableConfig.m_szIdDuAn)+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetGoiThau"
        
        ApiService.Post(url: ApiUrl, params: params, callback: GetGoiThau, errorCallBack: AlertError)
        
        
    }
    
    func GetGoiThau(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let arrGoiThau = dic["GetGoiThauResult"] as? [[String]] {
                print(arrGoiThau)
                for item in arrGoiThau {
                    let goiThau : GoiThau = GoiThau()
                    goiThau.IdGT = item[0]
                    goiThau.TenGT = item[1]
                    goiThau.GiaGT = item[2]
                    goiThau.HinhThucLCNT = item[4]
                    goiThau.PhuongThucLCNT = item[5]
                    goiThau.LoaiHopDong = item[6]
                    m_dsGoiThau.append(goiThau)
                    m_countGoiThau = m_countGoiThau + 1
                    m_TongGiaTri = m_TongGiaTri + (Int)(item[2])!
                }
                var idGoiThau :String
                if arrGoiThau.count > 0 {
                    idGoiThau = arrGoiThau[0][3]
                }
                else
                {
                    idGoiThau = ""
                }
                
                //Tính kích thước tổng giái trị
                let size = CGSize(width: 1000 , height: 30)
                let fontTitle = UIFont.boldSystemFont(ofSize: 13)
                let fontGiaTri = UIFont.systemFont(ofSize: 13)
                wTongGiaTri = variableConfig.convert((String)(m_TongGiaTri)).computeTextSize(size : size, font : fontGiaTri).width
                //So sanh với kích thước title
                wTongGiaTri = max(wTongGiaTri, "Giá gói thầu".computeTextSize(size : size, font : fontTitle).width)
                //Padding 10
                wTongGiaTri += 15
                
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        
                        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetKeHoachLuaChonNhaThau"
                        //let szUser=lblName.
                        let params : String = "{\"szIdKHLCNT\": \""+idGoiThau+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
                        
                        ApiService.Post(url: ApiUrl, params: params, callback: self.GetKeHoachLCNT, errorCallBack: self.AlertError)
                    }
                }
                
            }
        }
    }
    
    func GetKeHoachLCNT(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if var dic = json as? [String:Any] {
            if let check = dic["GetKeHoachLuaChonNhaThauResult"] as? [String] {
            }
            else{
                dic["GetKeHoachLuaChonNhaThauResult"] = ["GetKeHoachLuaChonNhaThauResult":(
                    "",
                    "",
                    "",
                    "")]
            }
            if let arrGoiThau = dic["GetKeHoachLuaChonNhaThauResult"] as? [String] {
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.m_thongTinKHLCNT = arrGoiThau
                        self.m_countGoiThau =  self.m_countGoiThau + 4
                        self.tbDSDA.reloadData()
                    }
                }
            }
            
        }
    }
    
    func AlertError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func backLogin(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //  func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    //    return    150
    //  }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.m_countGoiThau
        
        
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
            cell.lblcountDSGT.text = "Danh sách gói thầu (" + (String)(m_countGoiThau - 4) + " gói thầu )"
            
            
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
            
            cell.constraintLeftTenGoiThau.constant = wTongGiaTri + 30

            cell.lblTenGoiThau.text = m_dsGoiThau[index - 4].TenGT!
            cell.lblTenGoiThau.numberOfLines = 0
          //  cell.lblTenGoiThau.sizeToFit()
            
            cell.lblGiaTriTT.text = variableConfig.convert(m_dsGoiThau[index - 4].GiaGT!)
            
            var targetString : String = "Hình thức LCNT: \(m_dsGoiThau[index - 4].HinhThucLCNT!)"
            var range = NSMakeRange(16, targetString.characters.count - 16 )
            cell.lblHinhThucLCNT.attributedText = attributedString(from: targetString, nonBoldRange: range)
            
            cell.lblHinhThucLCNT.numberOfLines = 0
        //    cell.lblHinhThucLCNT.sizeToFit()
            
            targetString = "Phương thức LCNT: \(m_dsGoiThau[index - 4].PhuongThucLCNT!)"
            range = NSMakeRange(19, targetString.characters.count - 19 )
            cell.lblPhuongThucLCNT.attributedText = attributedString(from: targetString, nonBoldRange: range)
             cell.lblPhuongThucLCNT.numberOfLines = 0
      //      cell.lblPhuongThucLCNT.sizeToFit()
            
            targetString = "Loại hợp đồng: \(m_dsGoiThau[index - 4].LoaiHopDong!)"
            range = NSMakeRange(16, targetString.characters.count - 16 )
            cell.lblLoaiHD.attributedText = attributedString(from: targetString, nonBoldRange: range)

            cell.lblLoaiHD.numberOfLines = 0
       //     cell.lblLoaiHD.sizeToFit()
            // cell.lblPhuongThucLCNT.frame = CGRect(x: 105, y: 31 , width: cell.lblPhuongThucLCNT.frame.width, height: CGFloat.greatestFiniteMagnitude)
            
            
            
            
            
            var heightTieuDe = cell.lblTenGoiThau.frame.height + 10
            var heightHTLCNT = cell.lblHinhThucLCNT.frame.height + 14
            var heightPTLCNT = cell.lblPhuongThucLCNT.frame.height
            var heightLoaiHD = cell.lblLoaiHD.frame.height + 14
            
           
            
            
            if heightTieuDe < 29 {
                heightTieuDe = 28
            }
            if heightHTLCNT < 31 {
                heightHTLCNT = 30
            }
            if heightPTLCNT < 31 {
                heightPTLCNT = 30
            }
            if heightLoaiHD < 31 {
                heightLoaiHD = 30            }
            
          
            
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
            
            var eventClick = UITapGestureRecognizer()
            
            cell.uiViewDetail.tag = (Int)(m_dsGoiThau[index - 4].IdGT!)!
            eventClick.addTarget(self, action:  #selector(Tab_KHLCNT.duAnConClickDetail(sender: )))
            cell.uiViewDetail.addGestureRecognizer(eventClick)
            cell.uiViewDetail.isUserInteractionEnabled = true;
            
 cell.uiViewThongTinCT.isHidden = !self.indexTrangThaiGoiThau.contains((Int)(m_dsGoiThau[index - 4].IdGT!)!)

            
            
 if !self.indexTrangThaiGoiThau.contains((Int)(m_dsGoiThau[index - 4].IdGT!)!) {
    
    for constraint in cell.uiViewTieuDe.constraints as [NSLayoutConstraint] {
        if constraint.identifier == "idConstrainHeightTieuDe" {
            constraint.constant = heightTieuDe
        }
    }
    for constraint in cell.uiViewThongTinCT.constraints as [NSLayoutConstraint] {
        if constraint.identifier == "idConstrainHeightThongTinCT" {
            constraint.constant = 0
        }
    }
    
    for constraint in cell.uiViewGoiThau.constraints as [NSLayoutConstraint] {
        if constraint.identifier == "idConstrainstViewGT" {
            constraint.constant = heightTieuDe
        }
    }
    
    for constraint in cell.uiViewTenGoiThau.constraints as [NSLayoutConstraint] {
        if constraint.identifier == "idConstrainTopTenGT" {
            constraint.constant = 5
              }
    }
 }
 else
 {
  //  heightTieuDe = heightTieuDe + 2
    for constraint in cell.uiViewTenGoiThau.constraints as [NSLayoutConstraint] {
        if constraint.identifier == "idConstrainTopTenGT" {
            constraint.constant = 5
                  }
    }

    
    for constraint in cell.uiViewTieuDe.constraints as [NSLayoutConstraint] {
        if constraint.identifier == "idConstrainHeightTieuDe" {
        //    constraint.constant = heightTieuDe
        }
    }
    for constraint in cell.uiViewThongTinCT.constraints as [NSLayoutConstraint] {
        if constraint.identifier == "idConstrainHeightThongTinCT" {
            constraint.constant = heightHTLCNT + heightPTLCNT + heightLoaiHD
        }
    }
    for constraint in cell.uiViewGoiThau.constraints as [NSLayoutConstraint] {
        if constraint.identifier == "idConstrainstViewGT" {
            constraint.constant = heightTieuDe + heightHTLCNT + heightPTLCNT + heightLoaiHD
        }
    }
 }
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
    self.tbDSDA.rowHeight = UITableViewAutomaticDimension
    self.tbDSDA.estimatedRowHeight = 60
    self.tbDSDA.beginUpdates()
    self.tbDSDA.endUpdates()
 self.tbDSDA.reloadData()
 }
 
 init(itemInfo: IndicatorInfo) {
 self.itemInfo = itemInfo
 super.init(nibName: nil, bundle: nil)
 }
 
 required init?(coder aDecoder: NSCoder) {
 super.init(coder: aDecoder)
 }
 func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
 return itemInfo
 }
 }
