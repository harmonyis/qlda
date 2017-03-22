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

class Tab_KHLCNT: UIViewController ,IndicatorInfoProvider{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tbDSDA: UITableView!
    var m_dsGoiThau = [GoiThau]()
    var m_countGoiThau : Int = 0
    var m_TongGiaTri : Int = 0
    var m_thongTinKHLCNT : [String] = []
    var indexTrangThaiGoiThau = Set<Int>()
    var blackTheme = false
    var dataSource_Lanscape : TableKHLCNT_Landscape?
    var dataSource_Portrait : TableKHLCNT_Portrait?
    var itemInfo = IndicatorInfo(title: "KHLCNT")
    let arrTieuDe = ["Số quyết định","Ngày phê duyệt","Cơ quan phê duyệt"]
     let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    var wTongGiaTri : CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        self.tbDSDA.layer.borderColor = myColorBoder.cgColor
        self.tbDSDA.layer.borderWidth = 1

        
        self.tbDSDA.isHidden = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tbDSDA.separatorColor = UIColor.clear
        self.tbDSDA.rowHeight = UITableViewAutomaticDimension
        self.tbDSDA.estimatedRowHeight = 60
        
        self.tbDSDA.register(UINib(nibName: "Cell_KHLCNT_Header_Landscape", bundle: nil), forCellReuseIdentifier: "Cell_KHLCNT_Header_Landscape")
        
        self.tbDSDA.register(UINib(nibName: "Cell_KHLCNT_HD_Landscape", bundle: nil), forCellReuseIdentifier: "Cell_KHLCNT_HD_Landscape")
        
        let params : String = "{\"szIdDA\": \""+(String)(variableConfig.m_szIdDuAn)+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetGoiThau"
        
        ApiService.Post(url: ApiUrl, params: params, callback: GetGoiThau, errorCallBack: AlertError)
        
        
    }
    
    func GetGoiThau(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let arrGoiThau = dic["GetGoiThauResult"] as? [[String]] {
                
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
                //m_TongGiaTri = 10000000000000000
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
                        self.activityIndicator.stopAnimating()
                        
                        self.tbDSDA.isHidden = false
                    }
                }
                
            }
        }
    }
    
    func GetKeHoachLCNT(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if var dic = json as? [String:Any] {
           
            if var arrGoiThau = dic["GetKeHoachLuaChonNhaThauResult"] as? [String] {
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        if arrGoiThau.count<1 {
                            arrGoiThau = ["","","",""]
                            
                        }
                        self.m_thongTinKHLCNT = arrGoiThau
                        self.LoadTableView()
                    }
                }
            }
            
        }
    }
    func LoadTableView(){
        
      
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            
            self.dataSource_Lanscape = TableKHLCNT_Landscape(self.tbDSDA, arrGoiThau: self.m_dsGoiThau ,arrthongTinKHLCNT : self.m_thongTinKHLCNT , nTongGiaTri : self.m_TongGiaTri, wTongGiaTri : self.wTongGiaTri)
            self.tbDSDA.dataSource = self.dataSource_Lanscape
            self.tbDSDA.delegate = self.dataSource_Lanscape
            self.tbDSDA.reloadData()
            
            
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            
            
            self.dataSource_Portrait = TableKHLCNT_Portrait(self.tbDSDA, arrGoiThau: self.m_dsGoiThau ,arrthongTinKHLCNT : self.m_thongTinKHLCNT , nTongGiaTri : self.m_TongGiaTri, wTongGiaTri : self.wTongGiaTri)
            self.tbDSDA.dataSource = self.dataSource_Portrait
            self.tbDSDA.delegate = self.dataSource_Portrait
            self.tbDSDA.reloadData()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        LoadTableView()
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
        
        let value : Int = (sender.view?.tag)!
       
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
