//
//  Tab_VanBanDuAnVC.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Tab_VanBanDuAnVC: Base , IndicatorInfoProvider{
    
    var itemInfo = IndicatorInfo(title: "Văn bản dự án")
    
    var arrVanBan : [VanBanEntity] = []
    let apiUrl = "\(UrlPreFix.QLDA.rawValue)/GetFile"
    var idDuAn : String = String(variableConfig.m_szIdDuAn)
    var userName : String = variableConfig.m_szUserName
    var password : String = variableConfig.m_szPassWord
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    var tableDatasource : QLVanBanDatasource?
    var tableLandDatasource : QLVanBanLandDatasource?
    
    
    @IBOutlet weak var tbVanBanDuAn: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbVanBanDuAn.rowHeight = UITableViewAutomaticDimension
        tbVanBanDuAn.estimatedRowHeight = 30
        tbVanBanDuAn.separatorColor = UIColor.clear
        self.tbVanBanDuAn.estimatedSectionHeaderHeight = 30
        self.tbVanBanDuAn.sectionHeaderHeight = UITableViewAutomaticDimension
        
        
        self.tbVanBanDuAn.register(UINib(nibName: "HeaderableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderPort")
        self.tbVanBanDuAn.register(UINib(nibName: "VanBanLandTableViewCell", bundle: nil), forCellReuseIdentifier: "cellLand")
                self.tbVanBanDuAn.register(UINib(nibName: "HeaderLandTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderLand")
        loadData()
        
        
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
                        self.rotate()
                    }
                }
                
            }
        }
    }
    
    func rotate() {
        if UIDevice.current.orientation.isLandscape {
            self.tableLandDatasource = QLVanBanLandDatasource(arrVanBan: self.arrVanBan, table: self.tbVanBanDuAn)
            self.tbVanBanDuAn.dataSource = self.tableLandDatasource
            self.tbVanBanDuAn.delegate = self.tableLandDatasource
            self.tbVanBanDuAn.reloadData()
        }
        else {
            self.tableDatasource = QLVanBanDatasource(arrVanBan: self.arrVanBan, table: self.tbVanBanDuAn)
            self.tbVanBanDuAn.dataSource = self.tableDatasource
            self.tbVanBanDuAn.delegate = self.tableDatasource
            self.tbVanBanDuAn.reloadData()
            
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        rotate()
    }
    
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return CGFloat(150)
     }*/
    
    
    
    
    
}
