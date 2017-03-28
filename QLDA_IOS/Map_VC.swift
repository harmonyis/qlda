//
//  Map_VC.swift
//  QLDA_IOS
//
//  Created by MinhHieu on 3/2/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import GoogleMaps

class Map_VC: Base_VC, UISearchBarDelegate, GMSMapViewDelegate {

    @IBOutlet weak var  UiMapView: GMSMapView!
    
    @IBOutlet weak var tbDSDA: UITableView!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var uiSearchDA: UISearchBar!
    
    @IBOutlet weak var lblHeader: UILabel!
    
    var checkLoadView : Int = 0
     var m_textHightLight : String = ""
    var m_arrDSDA : [[String]] = []
    var DSDA = [DanhSachDA]()
    var m_DSDA = [DanhSachDA]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var dataSource_Portrait : TableDSDAMap_Portrait?
    var dataSource_Lanscape : TableDSDA_Lanscape?
    
    static var dicMarker: [Int: GMSMarker] = [:]
    
    var mapView : GMSMapView? = nil
    static var mapItems : [MapItem]? = nil
    var makers : [GMSMarker]? = nil
    
    @IBOutlet weak var constraintWidthMap: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightMap: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomMap: NSLayoutConstraint!
    @IBOutlet weak var constraintRightMap: NSLayoutConstraint!
    
    @IBOutlet weak var constraintWidthDSDA: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightDSDA: NSLayoutConstraint!
    
    func setConstraint(height : CGFloat, width : CGFloat){
        let w = width
        var h = height
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            h = h - 64 - 4
            constraintWidthMap.constant = w
            constraintHeightMap.constant = 310
            constraintBottomMap.constant = h - 310 + 1
            constraintRightMap.constant = 0
            
            constraintWidthDSDA.constant = w
            constraintHeightDSDA.constant = h - 310
        }
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
            let hBar = self.navigationController?.navigationBar.frame.height
            h = h - hBar! - 4
            constraintWidthMap.constant = w * 5.5/10 - 0.5
            constraintHeightMap.constant = h
            constraintBottomMap.constant = 1
            constraintRightMap.constant = w * 4.5/10
            
            constraintWidthDSDA.constant = w * 4.5/10
            constraintHeightDSDA.constant = h + 1

        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setConstraint(height: size.height, width: size.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraint(height: view.frame.height, width: view.frame.width)
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        toggleView()
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 21.101884872388879, longitude: 105.72625648970795, zoom: 6.0)
         UiMapView.camera = camera

        getData()
        self.UiMapView.delegate = self
        // Danh sach du an
        self.tbDSDA.separatorColor = UIColor.clear
        self.tbDSDA.register(UINib(nibName: "CustomCellDSDA_Lanscape", bundle: nil), forCellReuseIdentifier: "CustomCellDSDA_Lanscape")
        
        self.automaticallyAdjustsScrollViewInsets = false
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetDuAn"
        //let szUser=lblName.
        let params : String = "{\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
         ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: GetDanhSachDuAn, errorCallBack: alertAction)
      //  ApiService.Post(url: ApiUrl, params: params, callback: GetDanhSachDuAn, errorCallBack: GetDanhSachDuAnError)

        self.tbDSDA.sectionFooterHeight = 0;
        self.tbDSDA.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tbDSDA.rowHeight = UITableViewAutomaticDimension
        self.tbDSDA.estimatedRowHeight = 30
        self.tbDSDA.estimatedSectionHeaderHeight = 30
        
        UiMapView.delegate = self
        mapView?.delegate = self
    }
    // dsda---
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        LoadTableView()
    }
    
    func GetDanhSachDuAn(data : SuccessEntity) {
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
                        self.checkLoadView += 1
                        self.toggleView()
                        self.DSDA = self.DSDA.sorted(by: { Int($0.IdDA!)! > Int($1.IdDA!)! })
                        self.m_DSDA = self.DSDA
                        self.LoadTableView()
                        
                    }
                }
                
            }
        }
    }
    
    
    
    func GetDanhSachDuAnError(error : Error) {
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
            m_textHightLight = searchText
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
                    self.DSDA.append(itemNhomDA)
                }
            }
        }
        else
        {
            m_textHightLight = ""
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
            self.dataSource_Portrait = TableDSDAMap_Portrait(self.tbDSDA, arrDSDA: self.DSDA, tbvcDSDA: self,uiMapView:UiMapView,dicMarker: Map_VC.dicMarker,textHightLight : m_textHightLight)
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
    // enddsda-------------------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData()
    {
        //let apiUrl : String = "\(UrlPreFix.Map.rawValue)/Map_getThongTinDuAn"
         let apiUrl : String = "\(UrlPreFix.Map.rawValue)/Map_getThongTinDuAn?szUsername=demo1&szPassword=abc@123"
        //let params : String = "{\"szUsername\" : \""+"demo1"+"\", \"szPassword\": \""+"abc@123"+"\"}"
        ApiService.Get(url: apiUrl, callback: callbackLoadDuAn, errorCallBack: errorLoadDuAn)
    }
    
    func callbackLoadDuAn(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [[String:Any]] {
            Map_VC.mapItems = [MapItem]()
            for item in dic {
                let mapItem = MapItem()
                let KinhDoTemp = Double((item["KinhDo"] as? String)!)
                let ViDoTemp = Double((item["ViDo"] as? String)!)
                let sTenDuAn = item["TenDuAn"] as? String
                let sDiaDiemXayDung = item["DiaDiemXayDung"] as? String
                let sThoiGian = item["ThoiGianThucHien"] as? String
                let dTDMT = item["TongMucDauTu"] as? Double!
                let dGiaiNgan = item["GiaiNgan"] as? Double!
                
                mapItem.TMDT = dTDMT
                mapItem.GiaiNgan = dGiaiNgan
                mapItem.ThoiGian = sThoiGian
                mapItem.DiaDiemXayDung = sDiaDiemXayDung
                mapItem.DuAnChaID = Int((item["DuAnChaID"]  as? String)!)
                mapItem.DuAnID = Int((item["DuAnID"] as? String)!)
                mapItem.isDuAnCon = item["isDuAnCon"] as? Bool
                mapItem.KinhDo = KinhDoTemp
                mapItem.ViDo = ViDoTemp
                mapItem.TenDuAn = sTenDuAn
                Map_VC.mapItems?.append(mapItem)
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.checkLoadView += 1
                self.toggleView()
                self.createMarker()
            }
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?.first as! CustomInfoWindow
        infoWindow.layer.borderWidth = 1
        infoWindow.layer.borderColor = (UIColor.init(netHex: 0xDDDDDD)).cgColor
        
        var targetString : String = ""
        targetString  = "Địa điểm: \(marker.title!)"
        var range = NSMakeRange(9, targetString.characters.count - 9 )
        infoWindow.lblTitle.attributedText = attributedString(from: targetString, nonBoldRange: range)
        infoWindow.lblTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        infoWindow.lblTitle.numberOfLines = 0
        
        let arrInfo = marker.snippet?.components(separatedBy: "|")
        
        targetString  = "Thời gian thực hiện: \((arrInfo?[0])!)"
        range = NSMakeRange(20, targetString.characters.count - 20 )
        infoWindow.lblTime.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
        targetString  = "TMDT: \(variableConfig.convert((arrInfo?[1])!))"
        range = NSMakeRange(5, targetString.characters.count - 5 )
        infoWindow.lblTMDT.attributedText = attributedString(from: targetString, nonBoldRange: range)
        
        targetString  = "Giải ngân: \(variableConfig.convert((arrInfo?[2])!))"
        range = NSMakeRange(10, targetString.characters.count - 10 )
        infoWindow.lblGiaiNgan.attributedText = attributedString(from: targetString, nonBoldRange: range)
        infoWindow.autoresizingMask = .flexibleHeight
     
        //infoWindow.frame = CGRect(x: 30, y: 5 , width: self.UiMapView.frame.width - 60, height: 80)
        return infoWindow
        
    }
    
    // Tạo marker trên bản đồ
    func createMarker(){
        var TotalKinhDo : Double = 0
        var TotalViDo : Double = 0
        var TotalDuAnCoViTri = 0;
        
       for item in Map_VC.mapItems!
        {
            let KinhDoTemp = item.KinhDo
            let ViDoTemp = item.ViDo
            if KinhDoTemp != nil && ViDoTemp != nil
            {
                TotalKinhDo += KinhDoTemp!
                TotalViDo += ViDoTemp!
                TotalDuAnCoViTri = TotalDuAnCoViTri + 1
                
                //Create marker
                let Position = CLLocationCoordinate2D(latitude: ViDoTemp!, longitude: KinhDoTemp!)
                let marker = GMSMarker(position: Position)
                
                marker.title = item.DiaDiemXayDung
                marker.snippet = (item.ThoiGian!) + "|" + String(item.TMDT!) + "|" + String(item.GiaiNgan!)
                
                marker.map = UiMapView
                
                Map_VC.dicMarker[item.DuAnID!] = marker
            }
        }
        
        
        if TotalDuAnCoViTri != 0
        {
            TotalKinhDo = TotalKinhDo / Double(TotalDuAnCoViTri)
            TotalViDo = TotalViDo / Double(TotalDuAnCoViTri)
            let camera = GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withLatitude: TotalViDo, longitude: TotalKinhDo, zoom: 6.0))
            UiMapView.moveCamera(camera)

        }
        UiMapView.delegate = self
    }
    
    func setViTri(idDA: Int,uiMapView:GMSMapView){
        if(Map_VC.dicMarker[idDA] != nil){
            let marker = Map_VC.dicMarker[idDA]
            let position = marker?.position
            let camera = GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withLatitude: (position?.latitude)!, longitude: (position?.longitude)!,zoom: 15))
            uiMapView.moveCamera(camera)
            uiMapView.selectedMarker = marker
        }
        else{
            self.view.makeToast("Dự án không có vị trí!", duration: 1.5, position: .bottom)
        }
    }
    
    func errorLoadDuAn(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    func toggleView(){
        
        if checkLoadView == 2{
            activityIndicator.stopAnimating()
            UiMapView.isHidden = false
            lblHeader.isHidden = false
            uiSearchDA.isHidden = false
            tbDSDA.isHidden = false
        }
        else{
            UiMapView.isHidden = true
            lblHeader.isHidden = true
            uiSearchDA.isHidden = true
            tbDSDA.isHidden = true
        }
    }
    // Hàm set chữ bold
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
}
