//
//  QuanLyHinhAnh_VC.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/6/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import ImageViewer


class QuanLyHinhAnh_VC: Base_VC ,UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate  {

    @IBOutlet weak var clv: UICollectionView!

    @IBOutlet weak var tbDanhSachDuAn: UITableView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items : [ImageEntity] = []
    
    var ApiUrl : String = "\(UrlPreFix.Camera.rawValue)/GetAllFileUpload"
    
    var idDuAn : Int = 0
    var listName : String = ""
    var userName : String = ""
    var password : String = ""
    
    var DSDA = [DanhSachDA]()
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    var lstDuAnExists : [String] = []
    var DuAnSelected : String = "0"
    
    func GetDSHASuccess(data : Data) {
        //let result = String(data: data, encoding: String.Encoding.utf8)
        
       
        
        //print(result)
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        //print(json)
        if let dic = json as? [String:Any] {
            if let dataResult = dic["GetAllFileUploadResult"] as? [String:Any] {
                if let array = dataResult["DataResult"] as? [[String:Any]] {
                    var image : ImageEntity
                    for obj in array {
                        
                        image = ImageEntity()
                        image.ImageName = obj["ImageName"] as! String
                        image.ItemId = obj["Item"] as! String
                        image.ListName = obj["ListName"] as! String
                        
                        items.append(image)
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        // Bounce back to the main thread to update the UI
                        DispatchQueue.main.async {
                            
                            self.clv.reloadData()
                            //print("Hoàn thành")
                            //self.clv.reloadData()
                           // self.clv.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func GetDSHAByIdSuccess(data : Data) {
        //let result = String(data: data, encoding: String.Encoding.utf8)
        
        
        //print(result)
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        items.removeAll()
        if let dic = json as? [String:Any] {
            if let dataResult = dic["GetAllFileUploadByIDResult"] as? [String:Any] {
                if let array = dataResult["DataResult"] as? [[String:Any]] {
                    var image : ImageEntity
                    for obj in array {
                        
                        image = ImageEntity()
                        image.ImageName = obj["ImageName"] as! String
                        image.ItemId = obj["Item"] as! String
                        image.ListName = obj["ListName"] as! String
                        
                        items.append(image)
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        // Bounce back to the main thread to update the UI
                        DispatchQueue.main.async {
                            
                            self.clv.reloadData()
                            print("Hoàn thành")
                        }
                    }
                }
            }
        }
    }
    
    
    func GetDSHAError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        let imageName = items[indexPath.row].ImageName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let url = "http://harmonysoft.vn:8089/UploadFile/DuAn/\(items[indexPath.row].ItemId)/Icon/\(imageName!)"
        //print(url)
        cell.imgHinhAnh.downloadImage(url: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        return CGSize(width: collectionView.frame.size.width/4.08, height: collectionView.frame.size.width/4.08)
        
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?, _ imageView : UIImageView) -> Void, _ imageView : UIImageView) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error, imageView)
            }.resume()
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let galleryViewController = GalleryViewController(startIndex: indexPath.row, itemsDatasource: self, displacedViewsDatasource: nil, configuration: galleryConfiguration())
        
        self.presentImageGallery(galleryViewController)
    }
    func galleryConfiguration() -> GalleryConfiguration {
        
        return [
            
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            
            
            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),
            
            //GalleryConfigurationItem.swipeToDismissMode(.vertical),
            //GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            
            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffectStyle.light),
            
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            
            GalleryConfigurationItem.maximumZoolScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),
            
            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),
            
            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),
            
            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),
            
            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),
            
            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),
            
            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Danh sách hình ảnh"
        self.idDuAn = 142
        self.listName = "DuAn"
        self.userName = "administrator"
        self.password = "abc@123"
        
        let params : String = "{\"userName\" : \"\(userName)\", \"password\": \"\(password)\"}"
        ApiService.Post(url: ApiUrl, params: params, callback: GetDSHASuccess, errorCallBack: GetDSHAError)
        

        
        /*
        let nib = UINib(nibName: "CameraDanhSachDuAnTableViewCell", bundle: nil)
        tbDanhSachDuAn.register(nib, forCellReuseIdentifier: "cell")
        let datasource = CameraDanhSachDuAnDatasource(tbView: tbDanhSachDuAn)
        
        tbDanhSachDuAn.dataSource = datasource
        tbDanhSachDuAn.delegate = datasource
 */
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        print("Load Danh sách dự án thành công")
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.clv!.addGestureRecognizer(lpgr)
        
        
        // Do any additional setup after loading the view.
    }
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let point = gestureReconizer.location(in: self.clv)
        let indexPath = self.clv.indexPathForItem(at: point)
        
        if let index = indexPath {
            var cell = self.clv.cellForItem(at: index)
            // do stuff with your cell, for example print the indexPath
            print(index.row)
        } else {
            print("Could not find index path")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // danh sách dự án
    
    func Alert(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let arrDSDA = dic["GetDuAnResult"] as? [[String]] {
                
                
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
                    
                    
                }
                
                let itemTatCa = DanhSachDA()
                itemTatCa.IdDA = "0"
                itemTatCa.TenDA = "Tất cả dự án"
                self.DSDA.insert(itemTatCa, at: 0)
                
                let params1 : String = "{\"userName\" : \"\(userName)\", \"password\": \"\(password)\"}"
                let url1 = "\(UrlPreFix.Camera.rawValue)/GetListDuAnExistsImage"
                ApiService.Post(url: url1, params: params1, callback: { (data) in
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let dic = json as? [String:Any] {
                        if let result = dic["GetListDuAnExistsImageResult"] as? [String:Any] {
                            if let listDuAnExists = result["DataResult"] as? [String] {
                                //print(listDuAnExists)
                                self.lstDuAnExists = listDuAnExists
                                DispatchQueue.global(qos: .userInitiated).async {
                                    DispatchQueue.main.async {
                                        
                                        self.tbDanhSachDuAn.reloadData()
                                    }
                                }
                            }

                        }
                    }
                    
                }, errorCallBack: GetDSHAError)
                
                
                

                
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
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetDuAn"
        //let szUser=lblName.
        let params : String = "{\"szUsername\" : \"demo1\", \"szPassword\": \"abc@123\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: Alert, errorCallBack: AlertError)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.DSDA.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.indexGroupDuAnCon.contains(section))
        {
            return 0
        }
        else {
            return self.DSDA[section].DuAnCon!.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
        
        let itemNhomDA :DanhSachDA = self.DSDA[indexPath.section]
        let itemDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        
        
        //  let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        // cell.lblTenDuAn=label
        let msg  = itemDuAnCon[indexPath.row].TenDA!
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont.systemFont(ofSize: 13), myText: msg)
        
        let labelWidth = cell.lblTenDuAn.frame.width
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        //let height =  tableView.rowHeight - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
        var height = CGFloat(labelLines * (stringSizeAsText.height + 3))
        if height<30
        {
            height=30
        }
        print(height)
        if !self.indexTrangThaiDuAnCon.contains((String)(indexPath.section)+"-"+(String)(indexPath.row)) {
            
            return height + 13
            
        }
        return   height + 150
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
        
        let itemNhomDA :DanhSachDA = self.DSDA[section]
        let msg  = itemNhomDA.TenDA!
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont.systemFont(ofSize: 13), myText: msg)
        
        let labelWidth = cell.lblTenDuAn.frame.width
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        //let height =  tableView.rowHeight - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
        var height = CGFloat(labelLines * (stringSizeAsText.height + 3))
        
        if height<30
        {
            height=30
        }
        
        if !self.indexTrangThaiDuAnCha.contains(section) {
            
            return height + 13
            
        }
        return height + 150
    }
    
    
    // */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
        // cell.ght = 60
        //  cell.scrollEnabled = false
        let itemNhomDA :DanhSachDA = self.DSDA[section]
        cell.lblTenDuAn.text = itemNhomDA.TenDA!
        cell.lblTenDuAn.font = UIFont.boldSystemFont(ofSize: 13)
        
        
        
        if self.DuAnSelected == itemNhomDA.IdDA! {
            cell.lblTenDuAn.textColor = colorSelectd
        } else
        
        if self.lstDuAnExists.contains(itemNhomDA.IdDA!) || itemNhomDA.IdDA! == "0"{
            cell.lblTenDuAn.textColor = colorExistsItem
        } else {
            cell.lblTenDuAn.textColor = colorNotExistsItem
        }
        
        //cell.lblTenDuAn.textColor = colorSelectd
        
        
        cell.lblNhomDuAn.text = itemNhomDA.NhomDA!
        cell.lblGiaiDoan.text = itemNhomDA.GiaiDoan!
        cell.lblGiaTriGiaiNgan.text = itemNhomDA.GiaTriGiaiNgan!
        cell.lblTongDauTu.text = itemNhomDA.TongMucDauTu!
        cell.lblThoiGianThucHien.text = itemNhomDA.ThoiGianThucHien!
        cell.UiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.UiViewGroup.layer.borderWidth = 0.5
        cell.imgGroup.isHidden = false
                var image : UIImage = UIImage(named:"ic_minus")!
        if (itemNhomDA.DuAnCon?.count)!>0 {
            
            if !self.indexGroupDuAnCon.contains(section)
            {
                image  = UIImage(named:"ic_Group-Up")!
                cell.imgGroup.image = image
                
            }
            else
            {
                image  = UIImage(named:"ic_Group-Down")!
                cell.imgGroup.image = image
                
            }
        }
        
        cell.imgGroup.image = image
        
        //  cell.UIViewTieuDe.layer.borderWidth=1
        
        cell.UiViewTenDuAn.layer.borderColor = myColorBoder.cgColor
        cell.UiViewTenDuAn.layer.borderWidth = 0.5
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(1)
        borderBottom.borderColor =  myColorBoder.cgColor
        borderBottom.borderWidth = borderWidth
        borderBottom.frame = CGRect(x: 0, y: cell.UiViewBDThongTinCT.frame.height, width: cell.UiViewBDThongTinCT.frame.width, height: 1)
        cell.UiViewBDThongTinCT.layer.addSublayer(borderBottom)
        cell.UiViewBDThongTinCT.layer.masksToBounds = true
        
        
        cell.UiViewThongTinChiTiet.layer.borderColor = myColorBoder.cgColor
        cell.UiViewThongTinChiTiet.layer.borderWidth = 0.5
        cell.UiViewBDThongTin.layer.borderColor = myColorBoder.cgColor
        cell.UiViewBDThongTin.layer.borderWidth = 0.5
        
        var eventClick = UITapGestureRecognizer()
        
       
        
        eventClick = UITapGestureRecognizer()
        cell.imgGroup.tag = section
        eventClick.addTarget(self, action:  #selector(DSDA_VC.duAnChaClickGroup(sender: )))
        cell.imgGroup.addGestureRecognizer(eventClick)
        cell.imgGroup.isUserInteractionEnabled = true;
        
        eventClick = UITapGestureRecognizer()
        
        eventClick.addTarget(self, action:  #selector(DSDA_VC.ClickTenDuAn(sender:)))
        cell.lblTenDuAn.tag = (Int)(itemNhomDA.IdDA!)!
        cell.lblTenDuAn.accessibilityLabel = (itemNhomDA.TenDA!)
        cell.lblTenDuAn.addGestureRecognizer(eventClick)
        cell.lblTenDuAn.isUserInteractionEnabled = true;
        
        
        cell.UIViewTieuDe.autoresizingMask = UIViewAutoresizing.flexibleTopMargin
        cell.UIViewTieuDe.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
        
        cell.UIViewTieuDe.autoresizesSubviews = true
        
        cell.UiViewThongTinChiTiet.isHidden = !self.indexTrangThaiDuAnCha.contains(section)
        
        
        return cell
    }
    func duAnChaClickGroup(sender: UITapGestureRecognizer)
    {
        //print(sender.view?.tag)
        let value  = (sender.view?.tag)
        
        if self.indexGroupDuAnCon.contains(value!) {
            self.indexGroupDuAnCon.remove(value!)
        }
        else {
            self.indexGroupDuAnCon.insert(value!)
            
        }
        
        // self.tbDanhSachDuAn.beginUpdates()
        //    self.tbDanhSachDuAn.endUpdates()
        self.tbDanhSachDuAn.reloadData()
    }
    
    func duAnChaClickDetail(sender: UITapGestureRecognizer)
    {
        /*
        //print(sender.view?.tag)
        let value  = (sender.view?.tag)
        
        if self.indexTrangThaiDuAnCha.contains(value!) {
            self.indexTrangThaiDuAnCha.remove(value!)
        }
        else {
            self.indexTrangThaiDuAnCha.insert(value!)
            
        }
        self.tbDanhSachDuAn.beginUpdates()
        self.tbDanhSachDuAn.endUpdates()
        self.tbDanhSachDuAn.reloadData()
 */
    }
    
    
    /*    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.DSDA.count
     }
     */
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    let colorSelectd : UIColor = UIColor.red
    let colorExistsItem : UIColor = UIColor(netHex: 0x0e83d5)
    let colorNotExistsItem : UIColor = UIColor(netHex: 0xcccccc)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell", for: indexPath) as! CustomCellDSDATableViewCell
        let itemNhomDA :DanhSachDA = self.DSDA[indexPath.section]
        let itemDSDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        let itemDuAnCon : DuAn = itemDSDuAnCon[indexPath.row]
        
        //  let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        // cell.lblTenDuAn=label
        cell.lblTenDuAn.text = itemDuAnCon.TenDA!
        cell.lblTenDuAn.numberOfLines = 0
        cell.lblTenDuAn.font = UIFont.italicSystemFont(ofSize: 13)
        
        
        if self.DuAnSelected == itemDuAnCon.IdDA! {
            cell.lblTenDuAn.textColor = colorSelectd
        } else
        
        if self.lstDuAnExists.contains(itemDuAnCon.IdDA!) || itemDuAnCon.IdDA! == "0" {
            cell.lblTenDuAn.textColor = colorExistsItem
        } else {
            cell.lblTenDuAn.textColor = colorNotExistsItem
        }
        //cell.lblTenDuAn.textColor = colorSelectd
        
        
        //  cell.lblTenDuAn.lineBreakMode = wrap
        
        cell.lblNhomDuAn.text = itemDuAnCon.NhomDA!
        cell.lblGiaiDoan.text = itemDuAnCon.GiaiDoan!
        cell.lblGiaTriGiaiNgan.text = itemDuAnCon.GiaTriGiaiNgan!
        cell.lblTongDauTu.text = itemDuAnCon.TongMucDauTu!
        cell.lblThoiGianThucHien.text = itemDuAnCon.ThoiGianThucHien!
        
        cell.UiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.UiViewGroup.layer.borderWidth = 0.5
        
                // if !cell.imgGroup.isHidden
        cell.imgGroup.isHidden=true
        
        //  cell.UIViewTieuDe.layer.borderWidth=1
        
        cell.UiViewTenDuAn.layer.borderColor = myColorBoder.cgColor
        cell.UiViewTenDuAn.layer.borderWidth = 0.5
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(1)
        borderBottom.borderColor =  myColorBoder.cgColor
        borderBottom.borderWidth = borderWidth
        borderBottom.frame = CGRect(x: 0, y: cell.UiViewBDThongTinCT.frame.height, width: cell.UiViewBDThongTinCT.frame.width, height: 1)
        cell.UiViewBDThongTinCT.layer.addSublayer(borderBottom)
        cell.UiViewBDThongTinCT.layer.masksToBounds = true
        
        
        cell.UiViewThongTinChiTiet.layer.borderColor = myColorBoder.cgColor
        cell.UiViewThongTinChiTiet.layer.borderWidth = 0.5
        //   cell.UiViewThongTinChiTiet.layer.masksToBounds=true
        
        cell.UiViewBDThongTin.layer.borderColor = myColorBoder.cgColor
        cell.UiViewBDThongTin.layer.borderWidth = 0.5
        
        //  cell.UiViewContent.layer.borderWidth=1
        /* if let image = feedEntry.image {
         cell.trackAlbumArtworkView.image = image
         } else {
         feedManager.fetchImageAtIndex(index: indexPath.row, completion: { (index) in
         self.handleImageLoadForIndex(index: index)
         })
         }
         
         cell.audioPlaybackView.isHidden = !expandedCellPaths.contains(indexPath)
         */
        
        // cell.imgDetail.addTarget(self, action: #selector(DSDA_VC.tappedMe()))
        var eventClick = UITapGestureRecognizer()
        let value=(String)(indexPath.section)+"-"+(String)(indexPath.row)
      
        
        eventClick.addTarget(self, action:  #selector(DSDA_VC.ClickTenDuAn(sender:)))
        cell.lblTenDuAn.accessibilityLabel = (itemDuAnCon.TenDA!)
        cell.lblTenDuAn.tag = (Int)(itemDuAnCon.IdDA!)!
        cell.lblTenDuAn.addGestureRecognizer(eventClick)
        cell.lblTenDuAn.isUserInteractionEnabled = true;
        
        cell.UiViewThongTinChiTiet.isHidden = !self.indexTrangThaiDuAnCon.contains(value)
        //  print("ssssss")
        return cell
    }
    
    func duAnConClickDetail(sender: UITapGestureRecognizer)
    {
        /*
        //print(sender.view?.tag)
        let value : String = (sender.view?.accessibilityLabel)!
        // print(value)
        
        //  print(self.expandedCellPaths)
        if self.indexTrangThaiDuAnCon.contains(value) {
            self.indexTrangThaiDuAnCon.remove(value)
        }
        else {
            self.indexTrangThaiDuAnCon.insert(value)
            
        }
        self.tbDanhSachDuAn.beginUpdates()
        self.tbDanhSachDuAn.endUpdates()
        self.tbDanhSachDuAn.reloadData()
 */
    }
    func ClickTenDuAn(sender: UITapGestureRecognizer)
    {
         //variableConfig.m_szIdDuAn = (sender.view?.tag)!
        
        /*
        let value : String = (sender.view?.accessibilityLabel)!
        variableConfig.m_szIdDuAn = (sender.view?.tag)!
        variableConfig.m_szTenDuAn = value
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tab_") as! Tab_
        self.navigationController?.pushViewController(vc, animated: true)
 */
        
        //let url = "GetAllFileUploadByID"
        //let param = ""
        
        
        let idDuAn : Int = (sender.view?.tag)!
        if String(idDuAn) == "0" {
            let params : String = "{\"userName\" : \"\(userName)\", \"password\": \"\(password)\"}"
            ApiService.Post(url: ApiUrl, params: params, callback: GetDSHASuccess, errorCallBack:GetDSHAError)
            self.DuAnSelected = String(idDuAn)
        } else
        if self.lstDuAnExists.contains(String(idDuAn)) {
            DuAnSelected = String(idDuAn)
            ApiUrl = "\(UrlPreFix.Camera.rawValue)/GetAllFileUploadByID"
            let params : String = "{\"userName\" : \"\(userName)\", \"password\": \"\(password)\", \"listName\":\"DuAn\", \"IDItem\":\(idDuAn)}"
            ApiService.Post(url: ApiUrl, params: params, callback: GetDSHAByIdSuccess, errorCallBack: GetDSHAError)
            self.DuAnSelected = String(idDuAn)
        } else {
            self.view.makeToast("Dự án không có ảnh!", duration: 3.0, position: .bottom)
            
        }
        let label:UILabel = (sender.view!) as! UILabel
        label.textColor = colorSelectd
       
        MauMacDinh()
        
        
        

        

        
        

        
        //print(params)
        
        //print(sender.view?.tag)
    }
    
    // hết hiển thị danh sách dự án

    func MauMacDinh() {
        /*
        print(tbDanhSachDuAn.numberOfSections)
        //for item in tbDanhSachDuAn.row
        
        for section in 0..<tbDanhSachDuAn.numberOfSections {
            let header = tbDanhSachDuAn.headerView(forSection: section)
            tbDanhSachDuAn.section
            
            
            print(header)
            for row in 0..<tbDanhSachDuAn.numberOfRows(inSection: section) {
                
                let indexPath = IndexPath(row: row, section: section)
                let cell = tbDanhSachDuAn.cellForRow(at: indexPath)
                print(cell)
                // do what you want with the cell
                
            }
        }
        
        
        for cell in tbDanhSachDuAn.visibleCells {
            print(cell)
        }
 */
        tbDanhSachDuAn.reloadData()
    }
    
}

extension QuanLyHinhAnh_VC: GalleryItemsDatasource {
    
    func itemCount() -> Int {
        
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        let imageName = items[index].ImageName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let urlImage = "http://harmonysoft.vn:8089/UploadFile/DuAn/\(items[index].ItemId)/Image/\(imageName!)"
        
        let url = URL(string: urlImage)
        let data = try? Data(contentsOf: url!)
        let image : UIImage? = UIImage(data: data!)
        
        return GalleryItem.image{$0(image)}
    }
}
