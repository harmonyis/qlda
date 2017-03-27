//
//  DSDAViewController.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit


class DSDA_VC: Base_VC , UISearchBarDelegate{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var s : UITableViewController = UITableViewController()
    
    @IBOutlet weak var constraintHeightHeader: NSLayoutConstraint!
    @IBOutlet weak var uiViewHeaderDSDA: UIView!
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
    var widthDSDA : CGFloat = 0
    var heightDSDA : CGFloat = 0
    var m_textHightLight : String = String()
    var wGN : CGFloat = 0
    var wTMDT : CGFloat = 0
    var ApiUrl : String = ""
    var params : String = ""
    
    var refreshControl: UIRefreshControl!
    var bcheck = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        uiViewHeaderDSDA.isHidden = true
        uiSearchTDA.isHidden = true
        tbDSDA.isHidden = true
        self.m_textHightLight = ""
        self.tbDSDA.separatorColor = UIColor.clear
        self.tbDSDA.register(UINib(nibName: "CustomCellDSDA_Lanscape", bundle: nil), forCellReuseIdentifier: "CustomCellDSDA_Lanscape")
        
        // thêm swipe cho trang
        
        for item in tbDSDA.subviews {
            if item.tag == 101 {
                bcheck = false
            }
        }
        if bcheck == true {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(DSDA_VC.refresh(sender: )), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = variableConfig.m_swipeColor
        refreshControl.tag = 101
        self.tbDSDA.addSubview(refreshControl)
}
       
        
        self.automaticallyAdjustsScrollViewInsets = false
        ApiUrl = "\(UrlPreFix.QLDA.rawValue)/GetDuAn"
        //let szUser=lblName.
        params = "{\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        
        ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: loadDataSuccess, errorCallBack: alertAction)
        
        
        
        self.tbDSDA.sectionFooterHeight = 0;
        self.tbDSDA.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tbDSDA.rowHeight = UITableViewAutomaticDimension
        self.tbDSDA.estimatedRowHeight = 30
        self.tbDSDA.estimatedSectionHeaderHeight = 30
        
    }
    func refresh(sender:AnyObject) {
        self.DSDA = []
         ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: loadDataSuccess, errorCallBack: alertAction)
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        LoadTableView()
    }
    
    
    
    func loadDataSuccess(data : SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }
        
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        if let dic = json as? [String:Any] {
            if let arrDSDA = dic["GetDuAnResult"] as? [[String]] {
                self.m_arrDSDA = arrDSDA
                for itemDA in arrDSDA {
                    
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
                        self.computeWidthCell()
                        self.LoadTableView()
                        self.activityIndicator.stopAnimating()
                        self.uiViewHeaderDSDA.isHidden = false
                        self.uiSearchTDA.isHidden = false
                        self.tbDSDA.isHidden = false
                        self.refreshControl?.endRefreshing()
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
            self.m_textHightLight = searchText
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
            self.m_textHightLight = ""
            self.DSDA = self.m_DSDA
        }
        LoadTableView()
        
    }
    func LoadTableView(){
        
        widthDSDA = self.view.bounds.size.width
        heightDSDA = self.view.bounds.size.height
        variableConfig.m_widthScreen = max(self.heightDSDA, self.widthDSDA)
        
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            
            //   uiViewHeaderDSDA.viewWithTag(100)?.removeFromSuperview()
            
            
            for item in uiViewHeaderDSDA.subviews {
                if item.tag == 100 {
                    item.removeFromSuperview()
                }
            }
            let width = max(self.heightDSDA, self.widthDSDA) - 20
            constraintHeightHeader.constant = 50
            uiViewHeaderDSDA.backgroundColor = UIColor(netHex: 0x21AFFA)
            
            var uiView:UIView = UIView()
            
            
            uiView.frame = CGRect(x: 0, y: 0 , width: 20, height: 50)
            uiView.layer.borderColor = variableConfig.m_borderColor.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            self.uiViewHeaderDSDA.addSubview(uiView)
            
            var lable:UILabel = UILabel()
            
            let wTotal = width - wGN - wTMDT
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20), y: 0 , width: (45*wTotal/100), height: 50)
            uiView.layer.borderColor = variableConfig.m_borderColor.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Tên dự án"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 0, y: 0 , width: (45*wTotal/100), height: 50)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            
            self.uiViewHeaderDSDA.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + 45*wTotal/100), y: 0 , width: (15*wTotal/100), height: 50)
            uiView.layer.borderColor = variableConfig.m_borderColor.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Nhóm"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 0, y: 0 , width: (15*wTotal/100), height: 50)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderDSDA.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + 60*wTotal/100), y: 0 , width: (20*wTotal/100), height: 50)
            uiView.layer.borderColor = variableConfig.m_borderColor.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Giai đoạn"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 0, y: 0 , width: (20*wTotal/100), height: 50)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderDSDA.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + 80*wTotal/100), y: 0 , width: (20*wTotal/100), height: 50)
            uiView.layer.borderColor = variableConfig.m_borderColor.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Thời gian thực hiện"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 0, y: 0 , width: (20*wTotal/100), height: 50)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderDSDA.addSubview(uiView)
            
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wTotal), y: 0 , width: (wTMDT), height: 50)
            uiView.layer.borderColor = variableConfig.m_borderColor.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Giá trị giải ngân"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 0, y: 0 , width: (wTMDT), height: 50)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderDSDA.addSubview(uiView)
            
            uiView = UIView()
            uiView.frame = CGRect(x: (20 + wTotal + wTMDT), y: 0 , width: (wGN), height: 50)
            uiView.layer.borderColor = variableConfig.m_borderColor.cgColor
            uiView.layer.borderWidth = 0.5
            uiView.tag = 100
            
            lable = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Tổng mức đầu tư"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 0, y: 0 , width: (wGN), height: 50)
            lable.numberOfLines = 0
            
            uiView.addSubview(lable)
            self.uiViewHeaderDSDA.addSubview(uiView)
            
            
            // self.uiViewHeaderDSDA.frame = CGRect(x: 0,y: 116 ,width: self.widthDSDA , height: 30)
            // uiViewHeader.tag = 100
            
            self.dataSource_Lanscape = TableDSDA_Lanscape(self.tbDSDA, arrDSDA: self.DSDA, tbvcDSDA: self, wTMDT : wTMDT, wGN : wGN , textHightLight : m_textHightLight)
            self.tbDSDA.dataSource = self.dataSource_Lanscape
            self.tbDSDA.delegate = self.dataSource_Lanscape
            self.tbDSDA.reloadData()
            
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            for item in uiViewHeaderDSDA.subviews {
                if item.tag == 100 {
                    item.removeFromSuperview()
                }
            }
            constraintHeightHeader.constant = 30
            
            let lable:UILabel = UILabel()
            lable.textColor = UIColor.white
            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            lable.text = "Danh sách dự án"
            lable.textAlignment = .center
            lable.frame = CGRect(x: 10, y: 0 , width: 300, height: 30)
            lable.numberOfLines = 0
            lable.tag = 100
            uiViewHeaderDSDA.backgroundColor = UIColor(netHex: 0x21AFFA)
            
            
            // self.uiViewHeaderDSDA.frame = CGRect(x: 0,y: 116 ,width: self.widthDSDA , height: 30)
            // uiViewHeader.tag = 100
            self.uiViewHeaderDSDA.addSubview(lable)
            
            self.dataSource_Portrait = TableDSDA_Portrait(self.tbDSDA, arrDSDA: self.DSDA, tbvcDSDA: self , textHightLight : m_textHightLight)
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
    
    // Hàm tính size text
    /*
     func calulaterTextSize(text : String, size : CGSize) -> CGRect{
     let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
     let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13)], context: nil)
     return estimatedFrame
     }*/
    
    func computeWidthCell(){
        var temp : CGFloat = 0
        let size = CGSize(width: 1000 , height: 30)
        let font = UIFont.boldSystemFont(ofSize: 13)
        for item in DSDA{
            temp = variableConfig.convert(item.GiaTriGiaiNgan!).computeTextSize(size : size, font : font).width
            //temp = calulaterTextSize(text: variableConfig.convert(item.GiaTriGiaiNgan!), size: CGSize(width: 1000 , height: 30)).width
            wGN = max(wGN, temp)
            temp = variableConfig.convert(item.TongMucDauTu!).computeTextSize(size : size, font : font).width
            //temp = calulaterTextSize(text: variableConfig.convert(item.TongMucDauTu!), size: CGSize(width: 1000 , height: 30)).width
            wTMDT = max(wTMDT, temp)
            
            for child in item.DuAnCon!{
                temp = variableConfig.convert(child.GiaTriGiaiNgan!).computeTextSize(size : size, font : font).width
                //temp = calulaterTextSize(text: variableConfig.convert(child.GiaTriGiaiNgan!), size: CGSize(width: 1000 , height: 30)).width
                wGN = max(wGN, temp)
                
                temp = variableConfig.convert(child.TongMucDauTu!).computeTextSize(size : size, font : font).width
                //temp = calulaterTextSize(text: variableConfig.convert(child.TongMucDauTu!), size: CGSize(width: 1000 , height: 30)).width
                wTMDT = max(wTMDT, temp)
            }
        }
        wGN = wGN + 10
        wTMDT = wTMDT + 10
        print(wGN,wTMDT)
    }
}
