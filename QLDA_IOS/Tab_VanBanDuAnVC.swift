//
//  Tab_VanBanDuAnVC.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Tab_VanBanDuAnVC: Base , IndicatorInfoProvider, UIDocumentInteractionControllerDelegate{
    
    var itemInfo = IndicatorInfo(title: "Văn bản dự án")
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var arrVanBan : [VanBanEntity] = []
    let apiUrl = "\(UrlPreFix.QLDA.rawValue)/GetFile"
    var idDuAn : String = String(variableConfig.m_szIdDuAn)
    var userName : String = variableConfig.m_szUserName
    var password : String = variableConfig.m_szPassWord
    var tableDatasource : QLVanBanDatasource?
    var tableLandDatasource : QLVanBanLandDatasource?
    var refreshControl: UIRefreshControl!
    var bcheck = true
    var params : String = ""
    var ApiUrl : String = ""
    var url = ""
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
        self.tbVanBanDuAn.isHidden = true
        self.indicator.startAnimating()
        for item in tbVanBanDuAn.subviews {
            if item.tag == 101 {
                bcheck = false
            }
        }
        if bcheck == true {
            refreshControl = UIRefreshControl()
        //    refreshControl.addTarget(self, action:  #selector(Tab_TTC.refresh(sender: )), for: UIControlEvents.valueChanged)
            refreshControl.tintColor = variableConfig.m_swipeColor
            refreshControl.tag = 101
            self.tbVanBanDuAn.addSubview(refreshControl)
        }
        
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
    // open file
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    func saveFile(arrData : [Int8], fileName : String) {
        let myArray:[Int8] = [ 0x4d, 0x2a, 0x41, 0x2a, 0x53, 0x2a, 0x48]
        let pointer = UnsafeBufferPointer(start:myArray, count:myArray.count)
        let data = Data(buffer:pointer)
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/\(fileName)"))
        
        try! data.write(to: URL(fileURLWithPath: destinationURLForFile.path))
        print(fileName)
        showFileWithPath(path: destinationURLForFile.path)
    }
    
    
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
    }
    
    //Open file
    func refresh(sender:AnyObject) {
        arrVanBan = []
        
        loadData() 
        
    }

    func download(vanBan : VanBanEntity) {
         url = "\(UrlPreFix.QLDA.rawValue)/GetFileByName"
        params = "{\"filename\":\"\(vanBan.tenFileVanBan)\", \"szDuogDan\":\"\(vanBan.duongDan)\", \"szUsername\":\"\(self.userName)\", \"szPassword\":\"\(self.password)\"}"
        ApiService.PostAsync(url: url, params: params, callback: { (success : SuccessEntity) in
            let json = try? JSONSerialization.jsonObject(with: success.data! , options: [])
            if let dic = json as? [String:Any] {
                if let arr = dic["GetFileByNameResult"] as? [Int8] {
                    self.saveFile(arrData: arr, fileName: vanBan.tenFileVanBan)
                }
            }
        }, errorCallBack: self.noConnectToServer)
    }
    
    // MARK: - UITableViewDataSource
    
    
    
    // MARK: - IndicatorInfoProvider
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func loadData() {
         params = "{\"sDuAnID\":\"\(self.idDuAn)\",\"szUsername\":\"\(self.userName)\",\"szPassword\":\"\(self.password)\"}"
        ApiService.PostAsyncAc(url: apiUrl, params: params, callback:loadVanBanSuccess, errorCallBack: alertAction)
        //  ApiService.Post(url: apiUrl, params: params, callback: loadVanBanSuccess) { (error) in
        
        
    }
    
    func loadVanBanSuccess(data: SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }
        
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
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
                         self.refreshControl?.endRefreshing()
                    }
                }
                
            }
        }
    }
    
    func rotate() {
        if UIDevice.current.orientation.isLandscape {
            self.tableLandDatasource = QLVanBanLandDatasource(arrVanBan: self.arrVanBan, table: self.tbVanBanDuAn,tenVanBanClick:download)
            self.tbVanBanDuAn.dataSource = self.tableLandDatasource
            self.tbVanBanDuAn.delegate = self.tableLandDatasource
            self.tbVanBanDuAn.reloadData()
        }
        else {
            self.tableDatasource = QLVanBanDatasource(arrVanBan: self.arrVanBan, table: self.tbVanBanDuAn,tenVanBanClick:download)
            
            self.tbVanBanDuAn.dataSource = self.tableDatasource
            self.tbVanBanDuAn.delegate = self.tableDatasource
            self.tbVanBanDuAn.reloadData()
            
        }
        self.tbVanBanDuAn.isHidden = false
        self.indicator.stopAnimating()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        rotate()
    }
    
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return CGFloat(150)
     }*/
    
    
    
    
    
}
