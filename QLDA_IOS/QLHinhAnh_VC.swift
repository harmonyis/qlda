//
//  QLHA_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import ImageViewer
import XLPagerTabStrip

class QLHinhAnh_VC: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, IndicatorInfoProvider, UIGestureRecognizerDelegate  {
    
    @IBOutlet weak var clv: UICollectionView!
    var imagePicker = UIImagePickerController()
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items : [ImageEntity] = []
    var itemInfo = IndicatorInfo(title: "Quản lý hình ảnh")
    let ApiUrl : String = "\(UrlPreFix.Camera.rawValue)/GetAllFileUpload"
    
    var idDuAn : Int = 0
    var listName : String = ""
    var userName : String = ""
    var password : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Danh sách hình ảnh"
        self.idDuAn = variableConfig.m_szIdDuAn
        self.listName = "DuAn"
        self.userName = variableConfig.m_szUserName
        self.password = variableConfig.m_szPassWord
        
        let ApiUrl = "\(UrlPreFix.Camera.rawValue)/GetAllFileUploadByID"
        let params : String = "{\"userName\" : \"\(userName)\", \"password\": \"\(password)\", \"listName\":\"DuAn\", \"IDItem\":\(idDuAn)}"
        ApiService.Post(url: ApiUrl, params: params, callback: GetDSHAByIdSuccess, errorCallBack: GetDSHAError)
        
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
        let lpgr = UILongPressGestureRecognizer(target: self, action:  #selector(QuanLyHinhAnh_VC.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = false
        lpgr.delegate = self
        lpgr.allowableMovement = CGFloat(600)
        self.clv!.addGestureRecognizer(lpgr)
        //activityIndicatorStart()
        print("aaaaa")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGallery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let newImg = resizeImage(image: image, newWidth: 540)
            //imageView.image = image
            let data = UIImageJPEGRepresentation(newImg, 1.0)
            let array = [UInt8](data!)
            
            //let jsonResult = JSONSerializer.toJson(dataImage)
            
            let uuid = UUID().uuidString
            
            let jsonResult = "{\"ImageName\":\"\(uuid).jpg\",\"ListName\":\"\(listName)\",\"IDItem\":\(idDuAn),\"ImageData\":\(array)}"
            
            let params : String = "{\"userName\" : \"\(userName)\", \"password\": \"\(password)\", \"data\":\(jsonResult)}"
            
            
            //print(params)
            
            
            let ApiUrl : String = "\(UrlPreFix.Camera.rawValue)/UploadImage"
            
            ApiService.Post(url: ApiUrl, params: params, callback: PostImageSuccess, errorCallBack: { (error) in
                print("error")
                print(error.localizedDescription)
            })
            
            
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func PostImageSuccess(data:Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let methodResult = json as? [String:Any] {
            if let uploadImageResult = methodResult["UploadImageResult"] as? [String: Any] {
                if let dataResult = uploadImageResult["DataResult"] as? [String : Any] {
                    //print(dataResult)
                    DispatchQueue.global(qos: .userInitiated).async {
                        // Bounce back to the main thread to update the UI
                        DispatchQueue.main.async {
                            let imgEntity = ImageEntity()
                            imgEntity.ImageName = dataResult["ImageName"] as! String
                            imgEntity.ItemId = String(self.idDuAn)
                            imgEntity.ListName = self.listName
                            self.items.insert(imgEntity, at: 0)
                            //self.items.append(imgEntity)
                            
                            self.clv.reloadData()
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect( x: 0, y : 0,width: newWidth,height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
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
        if UIDevice.current.orientation.isPortrait {
            print(collectionView.frame.size.width/4.08)
            return CGSize(width: collectionView.frame.size.width/4.08, height: collectionView.frame.size.width/4.08)
        } else {
            print(collectionView.frame.size.width/7.25)
            return CGSize(width: collectionView.frame.size.width/7.2, height: collectionView.frame.size.width/7.2)
        }
        
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
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.clv.reloadData()
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
    
    
    
    
    // long click 
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        
        if gestureReconizer.state != UIGestureRecognizerState.began {
            return
        }
        print("đã đc")
        
        let point = gestureReconizer.location(in: self.clv)
        let indexPath = self.clv.indexPathForItem(at: point)
        
        if let index = indexPath {
            var cell = self.clv.cellForItem(at: index)
            // do stuff with your cell, for example print the indexPath
            print(index.row)
            showMenu(index: index.row)
            
        } else {
            print("Could not find index path")
        }
        
    }
    
    func showMenu(index:Int) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let detailAction = UIAlertAction(title: "Chi tiết", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            var obj = self.items[index]
            var message = ""
            
            let ApiUrlDetail = "\(UrlPreFix.Camera.rawValue)/GetImageDetail"
            let params : String = "{\"userName\" : \"\(self.userName)\", \"password\": \"\(self.password)\", \"listName\":\"DuAn\", \"IDItem\":\(obj.ItemId), \"fileName\":\"\(obj.ImageName)\"}"
            ApiService.Post(url: ApiUrlDetail, params: params, callback: {(data) in
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                if let dic = json as? [String:Any] {
                    if let dataResult = dic["GetImageDetailResult"] as? [String:Any] {
                        if let array = dataResult["DataResult"] as? [String:Any] {
                            message = "Dự án: \(array["DuAn"] as! String) \nTên ảnh: \(array["Name"] as! String) \nNgười tạo: \(array["CreatedBy"] as! String) \nNgày tạo: \(array["Created"] as! String) \nKích thước: \(array["Size"] as! String) \nĐộ phân giải:\(array["Dimensions"] as! String)"
                            

                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = NSTextAlignment.left
                            
                            let alert = UIAlertController(title: "Chi tiết:", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default, handler: nil))
                            
                            let messageText = NSMutableAttributedString(
                                string: message,
                                attributes: [
                                    NSParagraphStyleAttributeName: paragraphStyle,
                                    NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
                                    NSForegroundColorAttributeName : UIColor.black
                                ]
                            )
                            
                            alert.setValue(messageText, forKey: "attributedMessage")
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
                
            }, errorCallBack: self.GetDSHAError)
            
        })
        
        
        let deleteAction = UIAlertAction(title: "Xoá ảnh", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let alert = UIAlertController(title: "Xác nhận xóa ?", message: "Bạn có chắc chắn muốn xóa ?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Xác nhận", style: UIAlertActionStyle.default, handler: {(action) -> Void in
                var obj = self.items[index]
                let ApiUrlDetail = "\(UrlPreFix.Camera.rawValue)/DeleteFileUpload"
                let params : String = "{\"userName\" : \"\(self.userName)\", \"password\": \"\(self.password)\", \"listName\":\"DuAn\", \"IDItem\":\(obj.ItemId), \"fileName\":\"\(obj.ImageName)\"}"
                ApiService.Post(url: ApiUrlDetail, params: params, callback: {(data) in
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    self.items.remove(at: index)
                    DispatchQueue.global(qos: .userInitiated).async {
                        // Bounce back to the main thread to update the UI
                        DispatchQueue.main.async {
                            
                            self.clv.reloadData()
                        }
                        
                    }
                    
                    
                }, errorCallBack: self.GetDSHAError)
 

                
            }))
            self.present(alert, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Đóng", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
       
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(detailAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    func activityIndicatorStart() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

extension QLHinhAnh_VC: GalleryItemsDatasource {
    
    func itemCount() -> Int {
        
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        let imageName = items[index].ImageName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let urlImage = "http://harmonysoft.vn:8089/UploadFile/DuAn/\(items[index].ItemId)/Image/\(imageName!)"
        
        //let urlImage : String = "http://harmonysoft.vn:8089/UploadFile/DuAn/93/Icon/Topic%20Images_Smokestack_a01gRms.jpg"
        let url = URL(string: urlImage)
        let data = try? Data(contentsOf: url!)
        let image : UIImage? = UIImage(data: data!)
        
        return GalleryItem.image{$0(image)}
    }
    
}
