//
//  Tab_QDDT.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 06/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip

class Tab_QDDT: Base, IndicatorInfoProvider {
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "Quyết định đầu tư")
    var totalHeight : CGFloat = 0
    var m_arrTTDA : [String] = [String]()
    var m_arrTDT : [String] = [String]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var UiViewQDDT: UIView!
    var refreshControl: UIRefreshControl!
    var bcheck = true
    var params : String = ""
    var ApiUrl : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        UiViewQDDT.isHidden = true
        //  self.ViewData.autoresizesSubviews = true
         ApiUrl = "\(UrlPreFix.QLDA.rawValue)/GetQuyetDinhDauTu"
         params = "{\"szIdDuAn\" : \""+(String)(variableConfig.m_szIdDuAn)+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        UiViewQDDT.layer.borderColor = myColorBoder.cgColor
        UiViewQDDT.layer.borderWidth = 1
        
        for item in UiViewQDDT.subviews {
            if item.tag == 101 {
                bcheck = false
            }
        }
        if bcheck == true {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:  #selector(Tab_QDDT.refresh(sender: )), for: UIControlEvents.valueChanged)
            refreshControl.tintColor = UIColor(netHex: 0x21AFFA)
            refreshControl.tag = 101
            self.UiViewQDDT.addSubview(refreshControl)
        }

          totalHeight = 0
        
        ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: GetDataQDDT, errorCallBack: alertAction)
        // ApiService.Post(url: ApiUrl, params: params, callback: , errorCallBack: Error)
    }
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    func GetDataQDDT(data : SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }
        
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        if let dic = json as? [String:Any] {
            
            if var arrTTDA = dic["GetQuyetDinhDauTuResult"] as? [String] {
                if arrTTDA.count<1 {
                    arrTTDA = ["","","","",""]
                    
                }
                m_arrTTDA = arrTTDA
                LoadDataQDDT()
            }
        }
    }
    
    func LoadDataQDDT(){
        let arrlblTTDA = ["Số văn bản","Ngày phê duyệt","Cơ quan phê duyệt","Tổng giá trị phê duyệt","Xây lắp","Thiết bị","GPMB","QLDA","Tư vấn","Khác","Dự phòng"]
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                
                self.UiViewQDDT.isHidden = false
                
                
                var icount = 0
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.right
                
                // phần tổng mức đầu tư
                // tạo cái lable tổng mức đâu tư
                let ViewQDDT = UIView()
                let lableQDDT:UILabel = UILabel()
                lableQDDT.textColor = UIColor.white
                lableQDDT.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                lableQDDT.text = "Tổng mức đầu tư"
                
                lableQDDT.frame = CGRect(x: 10, y: 5 , width: self.UiViewQDDT.frame.width, height: 30)
                lableQDDT.numberOfLines = 0
                lableQDDT.sizeToFit()
                ViewQDDT.addSubview(lableQDDT)
                ViewQDDT.backgroundColor = UIColor(netHex: 0x21AFFA)
                ViewQDDT.frame = CGRect(x: 5,y: self.totalHeight + 5,width: self.UiViewQDDT.frame.width - 10 , height: 25)
                self.totalHeight = self.totalHeight + ViewQDDT.frame.height
                self.totalHeight = self.totalHeight + 10
                self.UiViewQDDT.addSubview(ViewQDDT)
                
                let ViewGroupTTCQDDT = UIView()
                // dùng vong for để tạo giao diện và bind dữ liệu
                for itemTTDA in self.m_arrTTDA {
                    //tạo giao diện phần đầu tiên của tổng mức đầu tư
                    if icount > 0 ,icount < 4 {
                        var uiView = UIView()
                        let lable:UILabel = UILabel()
                        lable.textColor = UIColor.black
                        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lable.text = arrlblTTDA[icount-1]
                        
                        lable.frame = CGRect(x: 10, y: 0 , width: self.UiViewQDDT.frame.width, height: CGFloat.greatestFiniteMagnitude)
                        lable.numberOfLines = 0
                        lable.sizeToFit()
                        uiView.addSubview(lable)
                        
                        uiView.frame = CGRect(x: 0,y: self.totalHeight ,width: self.UiViewQDDT.frame.width - 10 , height: lable.frame.height + 4)
                        self.totalHeight = self.totalHeight + uiView.frame.height
                        
                        self.UiViewQDDT.addSubview(uiView)
                        uiView = UIView()
                        
                        let lblTenDuAn:UILabel = UILabel()
                        lblTenDuAn.textColor = UIColor.black
                        lblTenDuAn.font = UIFont(name:"HelveticaNeue", size: 13.0)
                        lblTenDuAn.text = itemTTDA
                        lblTenDuAn.frame = CGRect(x: 10, y: 30 , width: self.UiViewQDDT.frame.width - 10,  height: CGFloat.greatestFiniteMagnitude)
                        
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        
                        uiView.addSubview(lblTenDuAn)
                        var calHeight : CGFloat = 27
                        if lblTenDuAn.frame.height > 20 {
                            calHeight = lblTenDuAn.frame.height + 7
                        }
                        uiView.frame = CGRect(x: 0,y: self.totalHeight ,width: self.UiViewQDDT.frame.width, height: calHeight + 4)
                        self.totalHeight = self.totalHeight + uiView.frame.height
                        
                        let borderBottom = CALayer()
                        let borderWidth = CGFloat(1)
                        borderBottom.borderColor =  self.myColorBoder.cgColor
                        borderBottom.borderWidth = borderWidth
                        borderBottom.frame = CGRect(x: 5, y: calHeight, width: self.UiViewQDDT.frame.width - 10, height: 1)
                        uiView.layer.addSublayer(borderBottom)
                        uiView.layer.masksToBounds = true
                        
                        self.UiViewQDDT.addSubview(uiView)
                    }
                    // tạo giao diện phần tổng giá trị
                    if icount == 4 {
                        var uiView = UIView()
                        let lable:UILabel = UILabel()
                        lable.textColor = UIColor.black
                        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lable.text = arrlblTTDA[icount-1]
                        
                        lable.frame = CGRect(x: 10, y: 5 , width: self.UiViewQDDT.frame.width, height: CGFloat.greatestFiniteMagnitude)
                        lable.numberOfLines = 0
                        lable.sizeToFit()
                        
                        
                        /* uiView.frame = CGRect(x: 0,y: totalHeight ,width: (self.UiViewQDDT.frame.width - 10)/2, height: lable.frame.height + 4)
                         totalHeight = totalHeight + uiView.frame.height
                         */
                        self.UiViewQDDT.addSubview(uiView)
                        uiView = UIView()
                        
                        
                        let lblTenDuAn:UILabel = UILabel()
                        lblTenDuAn.textColor = UIColor.black
                        lblTenDuAn.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lblTenDuAn.text =  variableConfig.convert(itemTTDA)
                        
                        lblTenDuAn.frame = CGRect(x: 10, y: 25 , width: (self.UiViewQDDT.frame.width - 10), height: CGFloat.greatestFiniteMagnitude)
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        lblTenDuAn.frame = CGRect(x:  self.UiViewQDDT.frame.width - lblTenDuAn.frame.width - 10, y: 25 , width: (self.UiViewQDDT.frame.width - 10)/2, height: CGFloat.greatestFiniteMagnitude)
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        uiView.addSubview(lable)
                        uiView.addSubview(lblTenDuAn)
                        lblTenDuAn.widthAnchor.constraint(equalToConstant: 160).isActive = true
                        
                        let calHeight : CGFloat = 30
                        uiView.frame = CGRect(x: 0,y: self.totalHeight ,width: self.UiViewQDDT.frame.width, height: calHeight + 4)
                        
                        self.totalHeight = self.totalHeight + uiView.frame.height
                        
                        let borderBottom = CALayer()
                        let borderWidth = CGFloat(1)
                        borderBottom.borderColor =  self.myColorBoder.cgColor
                        borderBottom.borderWidth = borderWidth
                        borderBottom.frame = CGRect(x: 5, y: calHeight, width: self.UiViewQDDT.frame.width - 10, height: 1)
                        uiView.layer.addSublayer(borderBottom)
                        uiView.layer.masksToBounds = true
                        
                        self.UiViewQDDT.addSubview(uiView)
                    }
                    // tạo giao diện phần group
                    if icount > 4 , icount < 12 {
                        
                        var uiView = UIView()
                        let lable:UILabel = UILabel()
                        lable.textColor = UIColor.black
                        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lable.text = arrlblTTDA[icount-1]
                        
                        lable.frame = CGRect(x: 10, y: 3 , width: (self.UiViewQDDT.frame.width - 10)/2, height: 25)
                        lable.numberOfLines = 0
                        lable.sizeToFit()
                        uiView.addSubview(lable)
                        var haftWidth : CGFloat = (self.UiViewQDDT.frame.width - 10)/2
                        if !(icount%2==0){
                            haftWidth = 0
                        }
                        uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                        uiView.frame = CGRect(x: 5 + haftWidth,y: self.totalHeight ,width: (self.UiViewQDDT.frame.width - 10)/2 , height: 25)
                        self.totalHeight = self.totalHeight + 25
                        ViewGroupTTCQDDT.addSubview(uiView)
                        
                        uiView = UIView()
                        uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                        //self.uiViewThongTin.addSubview(uiView)
                        let lblTenDuAn:UILabel = UILabel()
                        lblTenDuAn.textColor = UIColor.black
                        lblTenDuAn.font = UIFont(name:"HelveticaNeue", size: 13.0)
                        lblTenDuAn.text = variableConfig.convert(itemTTDA)
                        
                        lblTenDuAn.frame = CGRect(x: 10, y: 25 , width: (self.UiViewQDDT.frame.width)/2, height: CGFloat.greatestFiniteMagnitude)
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        lblTenDuAn.frame = CGRect(x:  self.UiViewQDDT.frame.width/2 - lblTenDuAn.frame.width - 10, y: 25 , width: (self.UiViewQDDT.frame.width - 10)/2, height: CGFloat.greatestFiniteMagnitude)
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        lblTenDuAn.textAlignment = NSTextAlignment.right
                        
                        uiView.addSubview(lblTenDuAn)
                        uiView.frame = CGRect(x: 5 + haftWidth,y: self.totalHeight ,width: (self.UiViewQDDT.frame.width - 10)/2, height: 25)
                        
                        
                        let borderBottom = CALayer()
                        let borderWidth = CGFloat(1)
                        borderBottom.borderColor =  self.myColorBoder.cgColor
                        borderBottom.borderWidth = borderWidth
                        borderBottom.frame = CGRect(x:3 , y:24, width: (self.UiViewQDDT.frame.width)/2, height: 1)
                        uiView.layer.addSublayer(borderBottom)
                        uiView.layer.masksToBounds = true
                        if (icount%2==0) {
                            self.totalHeight = self.totalHeight + 25
                        }
                        else{
                            self.totalHeight = self.totalHeight - 25
                            
                        }
                        ViewGroupTTCQDDT.addSubview(uiView)
                        
                    }
                    
                    
                    icount = 1 + icount
                }
                if self.m_arrTTDA.count%2==0 {
                    let uiView = UIView()
                    uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                    uiView.frame = CGRect(x: 0 + (self.UiViewQDDT.frame.width)/2 , y: self.totalHeight ,width: (self.UiViewQDDT.frame.width)/2 - 5, height: 50)
                    ViewGroupTTCQDDT.addSubview(uiView)
                    self.totalHeight = self.totalHeight + 50
                }
                self.UiViewQDDT.addSubview(ViewGroupTTCQDDT)
                self.GetTDT()
            }
        }
    }
    
    func GetTDT(){
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetTongDuToan"
        let params : String = "{\"szIdDuAn\" : \""+(String)(variableConfig.m_szIdDuAn)+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        // gọi hàm lấy dự liệu tổng dự toán
        ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: GetDataTDT, errorCallBack: alertAction)
        
    }
    func GetDataTDT(data : SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }
        
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        if let dic = json as? [String:Any] {
            
            if var arrTTDA = dic["GetTongDuToanResult"] as? [String] {
                if arrTTDA.count<1 {
                    arrTTDA = ["","","","",""]
                }
                m_arrTDT = arrTTDA
                LoadDataTDT()
            }
        }
    }
    func refresh(sender:AnyObject) {
        m_arrTTDA = [String]()
        for item in UiViewQDDT.subviews {
            if item.tag == 101 {
                bcheck = false
            }
            else {
                item.removeFromSuperview()
            }
        }
          totalHeight = 0
         ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: GetDataQDDT, errorCallBack: alertAction)
        
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        for item in UiViewQDDT.subviews {
           
                if item.tag == 101 {
                    bcheck = false
                }
                else {

            item.removeFromSuperview()
                    
            }
        }
        totalHeight = 0
        LoadDataQDDT()
        
    }
    
    func LoadDataTDT(){
        let arrlblTTDA = ["Số văn bản","Ngày phê duyệt","Cơ quan phê duyệt","Tổng giá trị phê duyệt","Xây dựng","Thiết bị","GPMB","QLDA","Tư vấn","Khác","Dự phòng"]
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                
                
                var icount = 0
                // phần tổng dự toán
                // tạo lable tổng dự toán
                let ViewQDDT = UIView()
                let lableQDDT:UILabel = UILabel()
                lableQDDT.textColor = UIColor.white
                lableQDDT.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                lableQDDT.text = "Tổng dự toán"
                
                
                
                lableQDDT.frame = CGRect(x: 10, y: 5 , width: self.UiViewQDDT.frame.width - 10, height: 30)
                lableQDDT.numberOfLines = 0
                lableQDDT.sizeToFit()
                ViewQDDT.addSubview(lableQDDT)
                ViewQDDT.backgroundColor = UIColor(netHex: 0x21AFFA)
                ViewQDDT.frame = CGRect(x: 5,y: self.totalHeight + 5,width: self.UiViewQDDT.frame.width - 10, height: 25)
                self.totalHeight = self.totalHeight + ViewQDDT.frame.height
                self.totalHeight = self.totalHeight + 10
                self.UiViewQDDT.addSubview(ViewQDDT)
                
                let ViewGroupTTCQDDT = UIView()
                
                // dùng vòng for để tạo giao diện và bind dữ liệu
                for itemTTDA in self.m_arrTDT {
                    // tạo dữ liệu phần đầu
                    if icount > 0 ,icount < 4 {
                        var uiView = UIView()
                        let lable:UILabel = UILabel()
                        lable.textColor = UIColor.black
                        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lable.text = arrlblTTDA[icount-1]
                        
                        lable.frame = CGRect(x: 10, y: 0 , width: self.UiViewQDDT.frame.width, height: CGFloat.greatestFiniteMagnitude)
                        lable.numberOfLines = 0
                        lable.sizeToFit()
                        uiView.addSubview(lable)
                        
                        uiView.frame = CGRect(x: 0,y: self.totalHeight ,width: self.UiViewQDDT.frame.width - 10 , height: lable.frame.height + 4)
                        self.totalHeight = self.totalHeight + uiView.frame.height
                        
                        self.UiViewQDDT.addSubview(uiView)
                        uiView = UIView()
                        
                        
                        let lblTenDuAn:UILabel = UILabel()
                        lblTenDuAn.textColor = UIColor.black
                        lblTenDuAn.font = UIFont(name:"HelveticaNeue", size: 13.0)
                        lblTenDuAn.text = itemTTDA
                        lblTenDuAn.frame = CGRect(x: 10, y: 30 , width: self.UiViewQDDT.frame.width - 10,  height: CGFloat.greatestFiniteMagnitude)
                        
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        
                        uiView.addSubview(lblTenDuAn)
                        var calHeight : CGFloat = 27
                        if lblTenDuAn.frame.height > 20 {
                            calHeight = lblTenDuAn.frame.height + 7
                        }
                        uiView.frame = CGRect(x: 0,y: self.totalHeight ,width: self.UiViewQDDT.frame.width, height: calHeight + 4)
                        self.totalHeight = self.totalHeight + uiView.frame.height
                        
                        let borderBottom = CALayer()
                        let borderWidth = CGFloat(1)
                        borderBottom.borderColor =  self.myColorBoder.cgColor
                        borderBottom.borderWidth = borderWidth
                        borderBottom.frame = CGRect(x: 5, y: calHeight, width: self.UiViewQDDT.frame.width - 10, height: 1)
                        uiView.layer.addSublayer(borderBottom)
                        uiView.layer.masksToBounds = true
                        
                        self.UiViewQDDT.addSubview(uiView)
                    }
                    // tạo dữ liệu phần tổng giá trị
                    if icount == 4 {
                        var uiView = UIView()
                        let lable:UILabel = UILabel()
                        lable.textColor = UIColor.black
                        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lable.text = arrlblTTDA[icount-1]
                        
                        lable.frame = CGRect(x: 10, y: 5 , width: self.UiViewQDDT.frame.width, height: CGFloat.greatestFiniteMagnitude)
                        lable.numberOfLines = 0
                        lable.sizeToFit()
                        
                        self.UiViewQDDT.addSubview(uiView)
                        uiView = UIView()
                        
                        
                        let lblTenDuAn:UILabel = UILabel()
                        lblTenDuAn.textColor = UIColor.black
                        lblTenDuAn.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lblTenDuAn.text = variableConfig.convert(itemTTDA)
                        lblTenDuAn.textAlignment = NSTextAlignment.right
                        
                        lblTenDuAn.frame = CGRect(x: 10, y: 25 , width: (self.UiViewQDDT.frame.width - 10), height: CGFloat.greatestFiniteMagnitude)
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        lblTenDuAn.frame = CGRect(x:  self.UiViewQDDT.frame.width - lblTenDuAn.frame.width - 10, y: 25 , width: (self.UiViewQDDT.frame.width - 10)/2, height: CGFloat.greatestFiniteMagnitude)
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        uiView.addSubview(lable)
                        uiView.addSubview(lblTenDuAn)
                        
                        let calHeight : CGFloat = 30
                        uiView.frame = CGRect(x: 0,y: self.totalHeight ,width: self.UiViewQDDT.frame.width, height: calHeight + 4)
                        
                        self.totalHeight = self.totalHeight + uiView.frame.height
                        
                        let borderBottom = CALayer()
                        let borderWidth = CGFloat(1)
                        borderBottom.borderColor =  self.myColorBoder.cgColor
                        borderBottom.borderWidth = borderWidth
                        borderBottom.frame = CGRect(x: 5, y: calHeight, width: self.UiViewQDDT.frame.width - 10, height: 1)
                        uiView.layer.addSublayer(borderBottom)
                        uiView.layer.masksToBounds = true
                        
                        self.UiViewQDDT.addSubview(uiView)
                    }
                    // tạo dữ liệu phần group tổng dự toán
                    if icount > 4 , icount < 12{
                        
                        var uiView = UIView()
                        let lable:UILabel = UILabel()
                        uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                        lable.textColor = UIColor.black
                        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lable.text = arrlblTTDA[icount-1]
                        
                        lable.frame = CGRect(x: 10, y: 0 , width: (self.UiViewQDDT.frame.width - 10)/2, height: 25)
                        lable.numberOfLines = 0
                        lable.sizeToFit()
                        uiView.addSubview(lable)
                        // tao biến để vẽ loại giao diện chiếm 1 nửa màn hình
                        var haftWidth : CGFloat = (self.UiViewQDDT.frame.width - 10)/2
                        if !(icount%2==0){
                            haftWidth = 0
                        }
                        uiView.frame = CGRect(x: 5 + haftWidth,y: self.totalHeight ,width: (self.UiViewQDDT.frame.width - 10 )/2 , height: 25)
                        self.totalHeight = self.totalHeight + 25
                        ViewGroupTTCQDDT.addSubview(uiView)
                        
                        
                        uiView = UIView()
                        uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                        //self.uiViewThongTin.addSubview(uiView)
                        
                        
                        
                        let lblTenDuAn:UILabel = UILabel()
                        lblTenDuAn.textColor = UIColor.black
                        lblTenDuAn.font = UIFont(name:"HelveticaNeue", size: 13.0)
                        lblTenDuAn.text = variableConfig.convert(itemTTDA)
                        
                        lblTenDuAn.frame = CGRect(x: 10, y: 25 , width: (self.UiViewQDDT.frame.width - 10)/2, height: CGFloat.greatestFiniteMagnitude)
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        lblTenDuAn.frame = CGRect(x:  self.UiViewQDDT.frame.width/2 - lblTenDuAn.frame.width - 10, y: 25 , width: (self.UiViewQDDT.frame.width - 10)/2, height: CGFloat.greatestFiniteMagnitude)
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        lblTenDuAn.textAlignment = NSTextAlignment.right
                        
                        uiView.addSubview(lblTenDuAn)
                        uiView.frame = CGRect(x: 5 + haftWidth,y: self.totalHeight ,width: (self.UiViewQDDT.frame.width - 10 )/2, height: 25)
                        
                        
                        let borderBottom = CALayer()
                        let borderWidth = CGFloat(1)
                        borderBottom.borderColor =  self.myColorBoder.cgColor
                        borderBottom.borderWidth = borderWidth
                        borderBottom.frame = CGRect(x:3 , y:24, width: (self.UiViewQDDT.frame.width)/2, height: 1)
                        uiView.layer.addSublayer(borderBottom)
                        uiView.layer.masksToBounds = true
                        if (icount%2==0) {
                            self.totalHeight = self.totalHeight + 25
                        }
                        else{
                            self.totalHeight = self.totalHeight - 25
                            
                        }
                        ViewGroupTTCQDDT.addSubview(uiView)
                        
                    }
                    
                    
                    icount = 1 + icount
                }
                if self.m_arrTDT.count%2==0 {
                    let uiView = UIView()
                    uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                    uiView.frame = CGRect(x: 0 + (self.UiViewQDDT.frame.width)/2 , y: self.totalHeight ,width: (self.UiViewQDDT.frame.width)/2 - 5, height: 50)
                    ViewGroupTTCQDDT.addSubview(uiView)
                    self.totalHeight = self.totalHeight + 50
                }
                self.UiViewQDDT.addSubview(ViewGroupTTCQDDT)
                // đặt lại giá trị constrain cho view
                let heightConstraint = self.UiViewQDDT.heightAnchor.constraint(equalToConstant:  self.totalHeight + 5 )
                 self.refreshControl?.endRefreshing()
                NSLayoutConstraint.activate([heightConstraint])
                
            }
        }
    }
    
    func Error(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
}
