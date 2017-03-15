//
//  DSDAViewController.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit


class DSDA_VC: Base_VC , UISearchBarDelegate{
    
    @IBOutlet weak var uiSearchTDA: UISearchBar!
    @IBOutlet weak var tbDSDA: UITableView!
    var m_arrDSDA : [[String]] = []
    var DSDA = [DanhSachDA]()
    var m_DSDA = [DanhSachDA]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var dataSource_Portrait : TableDSDA_Portrait?
    var dataSource_Lanscape : TableDSDA_Lanscape?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbDSDA.separatorColor = UIColor.clear
        self.tbDSDA.register(UINib(nibName: "CustomCellDSDA_Lanscape", bundle: nil), forCellReuseIdentifier: "CustomCellDSDA_Lanscape")
       
        self.automaticallyAdjustsScrollViewInsets = false
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetDuAn"
        //let szUser=lblName.
        let params : String = "{\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: Alert, errorCallBack: AlertError)
        
        
     
            self.tbDSDA.sectionFooterHeight = 0;
             self.tbDSDA.sectionHeaderHeight = UITableViewAutomaticDimension
             self.tbDSDA.rowHeight = UITableViewAutomaticDimension
             self.tbDSDA.estimatedRowHeight = 30
            self.tbDSDA.estimatedSectionHeaderHeight = 30
      
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        LoadTableView()
    }

    func Alert(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let arrDSDA = dic["GetDuAnResult"] as? [[String]] {
                self.m_arrDSDA = arrDSDA
                for itemDA in arrDSDA {
                    print(itemDA[5])
                    print(itemDA[0])
                    if itemDA[0] == itemDA[5] {
                        let itemNhomDA = DanhSachDA()
                        itemNhomDA.IdDA = itemDA[0] as String
                        itemNhomDA.TenDA = itemDA[1] as String
                        itemNhomDA.GiaiDoan = itemDA[4] as String
                        itemNhomDA.NhomDA = itemDA[3] as String
                        itemNhomDA.ThoiGianThucHien = itemDA[8] as String
                        itemNhomDA.TongMucDauTu = itemDA[6] as String
                        itemNhomDA.GiaTriGiaiNgan = itemDA[7] as String
                        self.DSDA.append(itemNhomDA)
                    }
                    else if  self.DSDA.contains(where: { $0.IdDA! == itemDA[5] }) {
                        let NhomDuAn = self.DSDA.first(where: { $0.IdDA! == itemDA[5] })
                       
                        var NhomDuAnCon = [DuAn]()
                        NhomDuAnCon = (NhomDuAn?.DuAnCon)!
                        
                        let DuAnCon = DuAn()
                        DuAnCon.IdDA = itemDA[0] as String
                        DuAnCon.TenDA = itemDA[1] as String
                        DuAnCon.GiaiDoan = itemDA[4] as String
                        DuAnCon.NhomDA = itemDA[3] as String
                        DuAnCon.ThoiGianThucHien = itemDA[8] as String
                        DuAnCon.TongMucDauTu = itemDA[6] as String
                        DuAnCon.GiaTriGiaiNgan = itemDA[7] as String
                        
                        NhomDuAnCon.append(DuAnCon)
                        
                        self.DSDA.remove(at: self.DSDA.index(where: { $0.IdDA! == itemDA[5] })!)
                        NhomDuAn?.DuAnCon=NhomDuAnCon
                        self.DSDA.append(NhomDuAn!)
                    }
                }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.DSDA = self.DSDA.sorted(by: { Int($0.IdDA!)! > Int($1.IdDA!)! })
                        self.m_DSDA = self.DSDA
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchText == "") {
            DSDA = [DanhSachDA]()
            for itemDA in self.m_arrDSDA {
                if itemDA[0] == itemDA[5] , ConvertToUnsign(itemDA[1]).contains(ConvertToUnsign(searchText)){
                    let itemNhomDA = DanhSachDA()
                    itemNhomDA.IdDA = itemDA[0] as String
                    itemNhomDA.TenDA = itemDA[1] as String
                    itemNhomDA.GiaiDoan = itemDA[4] as String
                    itemNhomDA.NhomDA = itemDA[3] as String
                    itemNhomDA.ThoiGianThucHien = itemDA[8] as String
                    itemNhomDA.TongMucDauTu = itemDA[6] as String
                    itemNhomDA.GiaTriGiaiNgan = itemDA[7] as String
                    self.DSDA.append(itemNhomDA)
                }
                else if  self.DSDA.contains(where: { $0.IdDA! == itemDA[5] }) , ConvertToUnsign(itemDA[1]).contains(ConvertToUnsign(searchText)) {
                    let NhomDuAn = self.DSDA.first(where: { $0.IdDA! == itemDA[5] })
                    print(itemDA[5])
                    print(itemDA[0])
                    var NhomDuAnCon = [DuAn]()
                    NhomDuAnCon = (NhomDuAn?.DuAnCon)!
                    
                    let DuAnCon = DuAn()
                    DuAnCon.IdDA = itemDA[0] as String
                    DuAnCon.TenDA = itemDA[1] as String
                    DuAnCon.GiaiDoan = itemDA[4] as String
                    DuAnCon.NhomDA = itemDA[3] as String
                    DuAnCon.ThoiGianThucHien = itemDA[8] as String
                    DuAnCon.TongMucDauTu = itemDA[6] as String
                    DuAnCon.GiaTriGiaiNgan = itemDA[7] as String
                    
                    NhomDuAnCon.append(DuAnCon)
                    
                    self.DSDA.remove(at: self.DSDA.index(where: { $0.IdDA! == itemDA[5] })!)
                    NhomDuAn?.DuAnCon=NhomDuAnCon
                    self.DSDA.append(NhomDuAn!)
                }
                else if  !self.DSDA.contains(where: { $0.IdDA! == itemDA[5] }) , ConvertToUnsign(itemDA[1]).contains(ConvertToUnsign(searchText)) {
                    let NhomDuAn = self.m_arrDSDA.first(where: { $0[0] == itemDA[5] })
                    
                    let itemNhomDA = DanhSachDA()
                    itemNhomDA.IdDA = (NhomDuAn?[0])! as String
                    itemNhomDA.TenDA = (NhomDuAn?[1])! as String
                    itemNhomDA.GiaiDoan = (NhomDuAn?[4])! as String
                    itemNhomDA.NhomDA = (NhomDuAn?[3])! as String
                    itemNhomDA.ThoiGianThucHien = (NhomDuAn?[8])! as String
                    itemNhomDA.TongMucDauTu = (NhomDuAn?[6])! as String
                    itemNhomDA.GiaTriGiaiNgan = (NhomDuAn?[7])! as String
                    self.DSDA.append(itemNhomDA)
                    
                    var NhomDuAnCon = [DuAn]()
                    let DuAnCon = DuAn()
                    DuAnCon.IdDA = itemDA[0] as String
                    DuAnCon.TenDA = itemDA[1] as String
                    DuAnCon.GiaiDoan = itemDA[4] as String
                    DuAnCon.NhomDA = itemDA[3] as String
                    DuAnCon.ThoiGianThucHien = itemDA[8] as String
                    DuAnCon.TongMucDauTu = itemDA[6] as String
                    DuAnCon.GiaTriGiaiNgan = itemDA[7] as String
                    
                    NhomDuAnCon.append(DuAnCon)
                    self.DSDA.remove(at: self.DSDA.index(where: { $0.IdDA! == itemDA[5] })!)
                    itemNhomDA.DuAnCon=NhomDuAnCon
                    self.DSDA.append(itemNhomDA)            }
            }
        }
        else
        {
            self.DSDA = self.m_DSDA
        }
        LoadTableView()
        
    }
    
    func LoadTableView(){
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            self.dataSource_Lanscape = TableDSDA_Lanscape(self.tbDSDA, arrDSDA: self.DSDA, tbvcDSDA: self)
            self.tbDSDA.dataSource = self.dataSource_Lanscape
            self.tbDSDA.delegate = self.dataSource_Lanscape
            self.tbDSDA.reloadData()
            
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            self.dataSource_Portrait = TableDSDA_Portrait(self.tbDSDA, arrDSDA: self.DSDA, tbvcDSDA: self)
            self.tbDSDA.dataSource = self.dataSource_Portrait
            self.tbDSDA.delegate = self.dataSource_Portrait
            self.tbDSDA.reloadData()
        }

    }
    func  ConvertToUnsign(_ sztext: String) -> String
    {
        var signs : [String] = [
            "aAeEoOuUiIdDyY",
            "áàạảãâấầậẩẫăắằặẳẵ",
            "ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ",
            "éèẹẻẽêếềệểễ",
            "ÉÈẸẺẼÊẾỀỆỂỄ",
            "óòọỏõôốồộổỗơớờợởỡ",
            "ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ",
            "úùụủũưứừựửữ",
            "ÚÙỤỦŨƯỨỪỰỬỮ",
            "íìịỉĩ",
            "ÍÌỊỈĨ",
            "đ",
            "Đ",
            "ýỳỵỷỹ",
            "ÝỲỴỶỸ"
        ]
        var szValue : String = sztext
        for i in 1..<signs.count
        {
            for  j in 0..<signs[i].characters.count
            {
                let item : String = signs[i]
                szValue = (szValue as NSString).replacingOccurrences(of: (String)(signs[i][j]), with: (String)(signs[0][i-1]))
            }
        }
        return szValue.lowercased();
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
    
      
    
}
