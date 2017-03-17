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
  
    var m_NhomHD = [NhomHopDong]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var dataSource_Portrait : TableKHGN_Portrait?
    var dataSource_Lanscape : TableDSDA_Lanscape?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tbvKHGN.separatorColor = UIColor.clear
     //   self.tbvKHGN.register(UINib(nibName: "CustomCellDSDA_Lanscape", bundle: nil), forCellReuseIdentifier: "CustomCellDSDA_Lanscape")
        
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
               
                
                for itemHD in arrHD {
                
                  
                    var itemHopDong = HopDong()
                    itemHopDong.TenGoiThau = itemHD[0]
                    itemHopDong.GiaTriHopDong = itemHD[1]
                    itemHopDong.DonViThucHien = itemHD[2]
                    itemHopDong.ThoiGianThucHien = itemHD[3]
                    itemHopDong.SoNK = itemHD[4] + ", " + itemHD[5]
                    itemHopDong.GiaTriLK = itemHD[7]
                    
                   if self.m_NhomHD.contains(where: { $0.LoaiHopDong! == itemHD[6] }){
                    
                    let itemNhomHopDong = self.m_NhomHD.first(where: { $0.LoaiHopDong! == itemHD[6] })
                    
                    itemNhomHopDong?.GiaTriLK = (String)((Float)((itemNhomHopDong?.GiaTriLK)!)! + (Float)(itemHD[7])!)
                    
                    itemNhomHopDong?.GiaTriHopDong = (String)((Float)((itemNhomHopDong?.GiaTriHopDong)!)! + (Float)(itemHD[1])!)
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
            
        
            
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
          
            
            self.dataSource_Portrait = TableKHGN_Portrait(self.tbvKHGN, arrNhomHopDong: self.m_NhomHD, tbvcDSDA: self)
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
