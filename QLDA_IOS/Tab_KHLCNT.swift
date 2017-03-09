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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tbDSDA.rowHeight = UITableViewAutomaticDimension
        self.tbDSDA.estimatedRowHeight = 30
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
        if let dic = json as? [String:Any] {
          
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.scrollToRow(at: indexPath, at: .top, animated: false)
      let index = indexPath.row
        if index < 3 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHLCNT_R1", for: indexPath) as! Cell_KHLCNT_R1
            print(self.m_thongTinKHLCNT)
             cell.lblGiaTri.text = self.m_thongTinKHLCNT[index + 1]
            cell.lblTieuDe.text = arrTieuDe[index]
       return cell
            }
        else if index == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHLCNT_R2", for: indexPath) as! Cell_KHLCNT_R2
            cell.lblGiaTri.text = (String)(m_TongGiaTri)
            cell.lblcountDSGT.text = "Danh sách gói thầu (" + (String)(m_countGoiThau - 4) + " gói thầu )"
         return cell
           
        }
        else {
         let  cell = tableView.dequeueReusableCell(withIdentifier: "Cell_KHLCNT_R3", for: indexPath) as! Cell_KHLCNT_R3
            cell.lblSTT.text = (String)(index - 3)
            cell.lblTenGoiThau.text = m_dsGoiThau[index - 4].TenGT
        cell.lblGiaTriTT.text = m_dsGoiThau[index - 4].GiaGT
            cell.lblHinhThucLCNT.text = m_dsGoiThau[index - 4].HinhThucLCNT
           cell.lblPhuongThucLCNT.text = m_dsGoiThau[index - 4].PhuongThucLCNT
            cell.lblLoaiHD.text = m_dsGoiThau[index - 4].LoaiHopDong
            
            cell.uiViewSTT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewSTT.layer.borderWidth = 0.5
            
            cell.uiViewTenGoiThau.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTenGoiThau.layer.borderWidth = 0.5
            
            cell.uiViewGiaTriTT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewGiaTriTT.layer.borderWidth = 0.5
            
            cell.uiViewThongTinCT.layer.borderColor = myColorBoder.cgColor
            cell.uiViewThongTinCT.layer.borderWidth = 0.5
            
            cell.UiViewBDLeftTTCT.layer.borderColor = myColorBoder.cgColor
            cell.UiViewBDLeftTTCT.layer.borderWidth = 0.5
            
            
            cell.uiViewDetail.layer.borderColor = myColorBoder.cgColor
            cell.uiViewDetail.layer.borderWidth = 0.5
            
            cell.uiViewTieuDe.layer.borderColor = myColorBoder.cgColor
            cell.uiViewTieuDe.layer.borderWidth = 0.5
                     let heightC =  cell.uiViewGoiThau.heightAnchor.constraint(equalToConstant:  50 )
                             NSLayoutConstraint.activate([heightC])
            
            return cell
            }
        
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
