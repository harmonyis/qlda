//
//  Tab_KHGN.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 07/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class Tab_KHGN: UIViewController, IndicatorInfoProvider {
var itemInfo = IndicatorInfo(title: "Giải ngân")
   
    @IBOutlet weak var tbvKHGN: UITableView!
    @IBOutlet weak var uiViewHeaderLandscape: UIView!
    @IBOutlet weak var constraintHeightHeader: NSLayoutConstraint!
  
    var m_NhomHD = [NhomHopDong]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var dataSource_Portrait : TableKHGN_Portrait?
    var dataSource_Lanscape : TableKHGN_Lanscape?
    var dGiaTriGiaiNgan : Double = 0
    var dLKThanhToan : Double = 0
    
    var wGTHD : CGFloat = 0
    var wLKGTTT : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tbvKHGN.separatorColor = UIColor.clear
         self.tbvKHGN.register(UINib(nibName: "CustomCell_KHGN_Header_Landscape", bundle: nil), forCellReuseIdentifier: "CustomCell_KHGN_Header_Landscape")
        self.tbvKHGN.register(UINib(nibName: "CustomCell_KHGN_HD_Landscape", bundle: nil), forCellReuseIdentifier: "CustomCell_KHGN_HD_Landscape")
        self.tbvKHGN.register(UINib(nibName: "Cell_KHGN_R4", bundle: nil), forCellReuseIdentifier: "Cell_KHGN_R4")
        self.automaticallyAdjustsScrollViewInsets = false
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetTheoDoiGiaiNganDSHD"
        //let szUser=lblName.
        let params : String = "{ \"szIdDuAn\" : \""+(String)(variableConfig.m_szIdDuAn)+"\", \"szNam\" : \""+"2017"+"\", \"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: Alert, errorCallBack: AlertError)
        
        self.tbvKHGN.sectionFooterHeight = 0;
        self.tbvKHGN.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tbvKHGN.rowHeight = UITableViewAutomaticDimension
        self.tbvKHGN.estimatedRowHeight = 30
        self.tbvKHGN.estimatedSectionHeaderHeight = 30
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        LoadTableView()
    }
    
    
    func Alert(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let arrHD = dic["GetTheoDoiGiaiNganDSHDResult"] as? [[String]] {
               
                let item : NhomHopDong = NhomHopDong()
                
                item.LoaiHopDong = "Tong"
                item.GiaTriLK = "0"
                item.GiaTriHopDong = "0"
                
                
                self.m_NhomHD.append(item)
                
                for itemHD in arrHD {
                
                    if !(itemHD[1] == "") {
                    dGiaTriGiaiNgan = dGiaTriGiaiNgan + (Double)(itemHD[1])!
                        }
                        
                        if !(itemHD[7] == "") {
                    dLKThanhToan = dLKThanhToan + (Double)(itemHD[7])!
                    }
                    var itemHopDong = HopDong()
                    itemHopDong.TenGoiThau = itemHD[0]
                    itemHopDong.GiaTriHopDong = itemHD[1]
                    itemHopDong.DonViThucHien = itemHD[2]
                    itemHopDong.ThoiGianThucHien = itemHD[3]
                    
                    if !(itemHD[4] == ""){
                    itemHopDong.SoNK = itemHD[4] + ", "
                    }
                    itemHopDong.SoNK = itemHopDong.SoNK! + itemHD[5]
                    itemHopDong.GiaTriLK = itemHD[7]
                    
                   if self.m_NhomHD.contains(where: { $0.LoaiHopDong! == itemHD[6] }){
                    
                    let itemNhomHopDong = self.m_NhomHD.first(where: { $0.LoaiHopDong! == itemHD[6] })
                    
                    itemNhomHopDong?.GiaTriLK = Config.convert((String)((Float)((itemNhomHopDong?.GiaTriLK)!)! + (Float)(itemHD[7])!))
                    
                    itemNhomHopDong?.GiaTriHopDong = Config.convert((String)((Float)((itemNhomHopDong?.GiaTriHopDong)!)! + (Float)(itemHD[1])!))
                    var itemHDCon = [HopDong]()
                    itemHDCon = (itemNhomHopDong?.NhomHopDong)!
                    
                    itemHDCon.append(itemHopDong)
                    itemNhomHopDong?.NhomHopDong=itemHDCon
                    self.m_NhomHD.remove(at: self.m_NhomHD.index(where: { $0.LoaiHopDong! == itemHD[6] })!)
                    
                    self.m_NhomHD.append(itemNhomHopDong!)
                    }
                    else
                    {
                        let itemNhomHopDong = NhomHopDong()
                        itemNhomHopDong.LoaiHopDong = itemHD[6]
                        if itemHD[7] == ""{
                        itemNhomHopDong.GiaTriLK = "0"
                        }
                        else {
                        itemNhomHopDong.GiaTriLK = itemHD[7]
                        }
                        if itemHD[1] == "" {
                        itemNhomHopDong.GiaTriHopDong = "0"
                        }
                        else {
                        itemNhomHopDong.GiaTriHopDong = itemHD[1]
                            }
                        var itemHDCon = [HopDong]()
                        itemHDCon = (itemNhomHopDong.NhomHopDong)!
                        
                        itemHDCon.append(itemHopDong)
                        itemNhomHopDong.NhomHopDong=itemHDCon
                        
                        self.m_NhomHD.append(itemNhomHopDong)
                    }
                
                }
                
                let itemNhomHopDong = self.m_NhomHD.first(where: { $0.LoaiHopDong! == "Tong" })
                
                itemNhomHopDong?.GiaTriLK = Config.convert((String)(dLKThanhToan))
                
                itemNhomHopDong?.GiaTriHopDong = Config.convert((String)(dGiaTriGiaiNgan))
                
                let size = CGSize(width: 1000 , height: 30)
                let font = UIFont.systemFont(ofSize: 13)
                wGTHD = (itemNhomHopDong?.GiaTriHopDong?.computeTextSize(size: size, font: font).width)! + 15
                wLKGTTT = (itemNhomHopDong?.GiaTriLK?.computeTextSize(size: size, font: font).width)! + 15
                print(m_NhomHD)
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                      //  self.DSDA = self.DSDA.sorted(by: { Int($0.IdDA!)! > Int($1.IdDA!)! })
                       
                        self.LoadTableView()
                        
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
    var searchActive : Bool = false
    var filtered = [UserContact]()
 
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    
    func LoadTableView(){
    
        print("_________________")
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            
            
            for item in uiViewHeaderLandscape.subviews {
                if item.tag == 100 {
                    item.removeFromSuperview()
                }
            }
           
            let width = self.view.bounds.width - 20 - 8
           

            let wNoiDung = width - wGTHD - wLKGTTT - 70 - 60 - 80
            let wDVTH = width - wNoiDung - wGTHD - wLKGTTT  - 60 - 80
            let wTGTH = width - wNoiDung - wDVTH - wGTHD - wLKGTTT  - 80
            let wSNK = width - wNoiDung - wDVTH - wTGTH - wGTHD - wLKGTTT
            
            // add dòng 1 của header KHGN
            var uiView:UIView = UIView()
            
            
            
            var lable:UILabel = UILabel()
            lable = UILabel()
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Thời gian thực hiện (ngày)"
            lable.frame = CGRect(x: 5, y: 2 , width: wTGTH - 10, height: 70 - 4)
            lable.numberOfLines = 0
            lable.sizeToFit()
            var height_R1_Header = lable.frame.height
           height_R1_Header = height_R1_Header + 8
            
            
             uiView = UIView()
            uiView.frame = CGRect(x: 0, y: 0 , width: 20, height: height_R1_Header)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
             uiView.backgroundColor = UIColor(netHex: 0x21AFFA)
            
            
            
            self.uiViewHeaderLandscape.addSubview(uiView)
            
          
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20), y: 0 , width: wNoiDung, height: height_R1_Header)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
             uiView.backgroundColor = UIColor(netHex: 0x21AFFA)
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Nội dung"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wNoiDung - 10, height: height_R1_Header - 4)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung), y: 0 ,width : wDVTH, height: height_R1_Header)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
             uiView.backgroundColor = UIColor(netHex: 0x21AFFA)
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Đơn vị thực hiện"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wDVTH - 10, height: height_R1_Header - 4)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung + wDVTH), y: 0 , width: wTGTH, height: height_R1_Header)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            uiView.backgroundColor = UIColor(netHex: 0x21AFFA)
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Thời gian thực hiện (ngày)"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wTGTH - 10, height: height_R1_Header - 4)
            lable.numberOfLines = 0
            lable.sizeToFit()
            uiView.addSubview(lable)
            print(lable.frame.height)
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung + wDVTH + wTGTH), y: 0 , width: wSNK, height: height_R1_Header)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
             uiView.backgroundColor = UIColor(netHex: 0x21AFFA)
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Số, ngày ký"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wSNK - 10, height: height_R1_Header - 4)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung + wDVTH + wTGTH + wSNK), y: 0 , width: wGTHD, height: height_R1_Header)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
             uiView.backgroundColor = UIColor(netHex: 0x21AFFA)
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Giá trị hợp đồng"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wGTHD - 10, height: height_R1_Header - 4)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung + wDVTH + wTGTH + wSNK + wGTHD), y: 0 , width: wLKGTTT + 8, height: height_R1_Header)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
             uiView.backgroundColor = UIColor(netHex: 0x21AFFA)
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "LK giá trị thanh toán"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wLKGTTT + 8 - 10, height: height_R1_Header - 4)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderLandscape.addSubview(uiView)
 // add dòng thứ 2 của KHGN
            uiView = UIView()
            uiView.frame = CGRect(x: (20), y: height_R1_Header , width: wNoiDung, height: 30)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.black
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Tổng giá trị"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wNoiDung - 10, height: 30 - 4)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung), y: height_R1_Header ,width : wDVTH, height: 30)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung + wDVTH), y: height_R1_Header , width: wTGTH, height: 30)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung + wDVTH + wTGTH), y: height_R1_Header , width: wSNK, height: 30)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
           
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung + wDVTH + wTGTH + wSNK), y: height_R1_Header , width: wGTHD, height: 30)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.black
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = variableConfig.convert((String)(dGiaTriGiaiNgan))
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wGTHD - 10, height: 30 - 4)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderLandscape.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wNoiDung + wDVTH + wTGTH + wSNK + wGTHD), y: height_R1_Header , width: wLKGTTT + 8, height: 30)
            uiView.layer.borderColor = myColorBoder.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.black
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = variableConfig.convert((String)(dLKThanhToan))
            lable.textAlignment = .center
            lable.frame = CGRect(x: 5, y: 2 , width: wLKGTTT + 8 - 10, height: 30 - 4)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderLandscape.addSubview(uiView)
             constraintHeightHeader.constant = height_R1_Header + 30
            
            self.dataSource_Lanscape = TableKHGN_Lanscape(self.tbvKHGN, arrNhomHopDong: self.m_NhomHD, tbvcDSDA: self, wGTHD : self.wGTHD, wLKGTTT : self.wLKGTTT)
            self.tbvKHGN.dataSource = self.dataSource_Lanscape
            self.tbvKHGN.delegate = self.dataSource_Lanscape
            self.tbvKHGN.reloadData()
            
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
          
            
            self.dataSource_Portrait = TableKHGN_Portrait(self.tbvKHGN, arrNhomHopDong: self.m_NhomHD, tbvcDSDA: self, wGTHD : self.wGTHD, wLKGTTT : self.wLKGTTT)
           self.tbvKHGN.dataSource = self.dataSource_Portrait
            self.tbvKHGN.delegate = self.dataSource_Portrait
            self.tbvKHGN.reloadData()
        }
        
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
