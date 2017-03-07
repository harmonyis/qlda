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

class Tab_QDDT: UIViewController, IndicatorInfoProvider {
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "Quyết định đầu tư")
    var totalHeight : CGFloat = 0
    
    @IBOutlet weak var UiViewQDDC: UIView!
    @IBOutlet weak var UiViewQDDT: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //  self.ViewData.autoresizesSubviews = true
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetQuyetDinhDauTu"
        let params : String = "{\"szIdDuAn\" : \""+(String)(variableConfig.m_szIdDuAn)+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: GetDataQDDT, errorCallBack: Error)
    }
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    func GetDataQDDT(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            print(dic)
            if var arrTTDA = dic["GetQuyetDinhDauTuResult"] as? [String] {
                if arrTTDA.count<1 {
                    arrTTDA = ["","","","",""]
                }
                let arrlblTTDA = ["Số văn bản","Ngày phê duyệt","Cơ quan phê duyệt","Tổng giá trị phê duyệt","Xây lắp","Thiết bị","GPMB","QLDA","Tư vấn","Khác","Dự phòng"]
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        var icount = 0
                        let style = NSMutableParagraphStyle()
                        style.alignment = NSTextAlignment.right
                        
                        // phần tổng mức đầu tư
                        // tạo cái lable tổng mức đâu tư
                        var ViewQDDT = UIView()
                        var lableQDDT:UILabel = UILabel()
                        lableQDDT.textColor = UIColor.white
                        lableQDDT.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lableQDDT.text = "Tổng mức đầu tư"
                        
                        lableQDDT.frame = CGRect(x: 10, y: 5 , width: self.UiViewQDDT.frame.width, height: 30)
                        lableQDDT.numberOfLines = 0
                        lableQDDT.sizeToFit()
                        ViewQDDT.addSubview(lableQDDT)
                        ViewQDDT.backgroundColor = UIColor(netHex: 0x0e83d5)
                        ViewQDDT.frame = CGRect(x: 3,y: self.totalHeight + 5,width: self.UiViewQDDT.frame.width , height: 25)
                        self.totalHeight = self.totalHeight + ViewQDDT.frame.height
                        self.totalHeight = self.totalHeight + 30
                        self.UiViewQDDT.addSubview(ViewQDDT)
                        
                        var ViewGroupTTCQDDT = UIView()
                        // dùng vong for để tạo giao diện và bind dữ liệu
                        for itemTTDA in arrTTDA {
                            //tạo giao diện phần đầu tiên của tổng mức đầu tư
                            if icount > 0 ,icount < 4 {
                                var uiView = UIView()
                                var lable:UILabel = UILabel()
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
                                //self.uiViewThongTin.addSubview(uiView)
                                print(lable.frame.height)
                                var lblTenDuAn:UILabel = UILabel()
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
                                borderBottom.frame = CGRect(x: 0, y: calHeight, width: self.UiViewQDDT.frame.width, height: 1)
                                uiView.layer.addSublayer(borderBottom)
                                uiView.layer.masksToBounds = true
                                
                                self.UiViewQDDT.addSubview(uiView)
                            }
                            // tạo giao diện phần tổng giá trị
                            if icount == 4 {
                                var uiView = UIView()
                                var lable:UILabel = UILabel()
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
                                //self.uiViewThongTin.addSubview(uiView)
                                print(lable.frame.height)
                                var lblTenDuAn:UILabel = UILabel()
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
                                
                                var calHeight : CGFloat = 30
                                uiView.frame = CGRect(x: 0,y: self.totalHeight ,width: self.UiViewQDDT.frame.width, height: calHeight + 4)
                                
                                self.totalHeight = self.totalHeight + uiView.frame.height
                                
                                let borderBottom = CALayer()
                                let borderWidth = CGFloat(1)
                                borderBottom.borderColor =  self.myColorBoder.cgColor
                                borderBottom.borderWidth = borderWidth
                                borderBottom.frame = CGRect(x: 0, y: calHeight, width: self.UiViewQDDT.frame.width, height: 1)
                                uiView.layer.addSublayer(borderBottom)
                                uiView.layer.masksToBounds = true
                                
                                self.UiViewQDDT.addSubview(uiView)
                            }
                            // tạo giao diện phần group
                            if icount > 4 {
                                
                                var uiView = UIView()
                                var lable:UILabel = UILabel()
                                lable.textColor = UIColor.black
                                lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                                lable.text = arrlblTTDA[icount-1]
                                
                                lable.frame = CGRect(x: 10, y: 0 , width: (self.UiViewQDDT.frame.width - 10)/2, height: 25)
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
                                print(lable.frame.height)
                                var lblTenDuAn:UILabel = UILabel()
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
                                
                                var calHeight : CGFloat = 26
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
                        if arrTTDA.count%2==0 {
                            var uiView = UIView()
                            uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                             uiView.frame = CGRect(x: 0 + (self.UiViewQDDT.frame.width)/2 , y: self.totalHeight ,width: (self.UiViewQDDT.frame.width)/2 - 5, height: 50)
                            ViewGroupTTCQDDT.addSubview(uiView)
                            self.totalHeight = self.totalHeight + 50
                        }
                        self.UiViewQDDT.addSubview(ViewGroupTTCQDDT)
                        //     let heightConstraint = self.UiViewQDDT.heightAnchor.constraint(equalToConstant: 1600)
                        //      self.UiViewQDDT.isUserInteractionEnabled = true
                        //        NSLayoutConstraint.activate([heightConstraint])
                        // gọi hàm lấy dữ liệu về tổng dự toán từ service
                        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetTongDuToan"
                        //let szUser=lblName.
                        let params : String = "{\"szIdDuAn\" : \""+(String)(variableConfig.m_szIdDuAn)+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
                        // gọi hàm lấy dự liệu tổng dự toán
                        ApiService.Post(url: ApiUrl, params: params, callback: self.GetDataTDT, errorCallBack: self.Error)
                        
                    }
                }                }
        }
    }
    
    
    func GetDataTDT(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            print(dic)
            if var arrTTDA = dic["GetTongDuToanResult"] as? [String] {
                if arrTTDA.count<1 {
                    arrTTDA = ["","","","",""]
                }
                let arrlblTTDA = ["Số văn bản","Ngày phê duyệt","Cơ quan phê duyệt","Tổng giá trị phê duyệt","Xây dựng","Thiết bị","GPMB","QLDA","Tư vấn","Khác","Dự phòng"]
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        
                        
                        var icount = 0
                        // phần tổng dự toán
                        // tạo lable tổng dự toán
                        var ViewQDDT = UIView()
                        var lableQDDT:UILabel = UILabel()
                        lableQDDT.textColor = UIColor.white
                        lableQDDT.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lableQDDT.text = "Tổng dự toán"
                        
                        
                        
                        lableQDDT.frame = CGRect(x: 10, y: 5 , width: self.UiViewQDDT.frame.width, height: 30)
                        lableQDDT.numberOfLines = 0
                        lableQDDT.sizeToFit()
                        ViewQDDT.addSubview(lableQDDT)
                        ViewQDDT.backgroundColor = UIColor(netHex: 0x0e83d5)
                        ViewQDDT.frame = CGRect(x: 3,y: self.totalHeight + 5,width: self.UiViewQDDT.frame.width , height: 25)
                        self.totalHeight = self.totalHeight + ViewQDDT.frame.height
                        self.totalHeight = self.totalHeight + 30
                        self.UiViewQDDT.addSubview(ViewQDDT)
                        
                        var ViewGroupTTCQDDT = UIView()
                        
                        // dùng vòng for để tạo giao diện và bind dữ liệu
                        for itemTTDA in arrTTDA {
                            // tạo dữ liệu phần đầu
                            if icount > 0 ,icount < 4 {
                                var uiView = UIView()
                                var lable:UILabel = UILabel()
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
                                //self.uiViewThongTin.addSubview(uiView)
                                print(lable.frame.height)
                                var lblTenDuAn:UILabel = UILabel()
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
                                borderBottom.frame = CGRect(x: 0, y: calHeight, width: self.UiViewQDDT.frame.width, height: 1)
                                uiView.layer.addSublayer(borderBottom)
                                uiView.layer.masksToBounds = true
                                
                                self.UiViewQDDT.addSubview(uiView)
                            }
                            // tạo dữ liệu phần tổng giá trị
                            if icount == 4 {
                                var uiView = UIView()
                                var lable:UILabel = UILabel()
                                lable.textColor = UIColor.black
                                lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                                lable.text = arrlblTTDA[icount-1]
                                
                                lable.frame = CGRect(x: 10, y: 5 , width: self.UiViewQDDT.frame.width, height: CGFloat.greatestFiniteMagnitude)
                                lable.numberOfLines = 0
                                lable.sizeToFit()
                                
                                self.UiViewQDDT.addSubview(uiView)
                                uiView = UIView()
                                //self.uiViewThongTin.addSubview(uiView)
                                print(lable.frame.height)
                                var lblTenDuAn:UILabel = UILabel()
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
                                
                                var calHeight : CGFloat = 30
                                uiView.frame = CGRect(x: 0,y: self.totalHeight ,width: self.UiViewQDDT.frame.width, height: calHeight + 4)
                                
                                self.totalHeight = self.totalHeight + uiView.frame.height
                                
                                let borderBottom = CALayer()
                                let borderWidth = CGFloat(1)
                                borderBottom.borderColor =  self.myColorBoder.cgColor
                                borderBottom.borderWidth = borderWidth
                                borderBottom.frame = CGRect(x: 0, y: calHeight, width: self.UiViewQDDT.frame.width, height: 1)
                                uiView.layer.addSublayer(borderBottom)
                                uiView.layer.masksToBounds = true
                                
                                self.UiViewQDDT.addSubview(uiView)
                            }
                            // tạo dữ liệu phần group tổng dự toán
                            if icount > 4 {
                                
                                var uiView = UIView()
                                var lable:UILabel = UILabel()
                                  uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                                lable.textColor = UIColor.black
                                lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                                lable.text = arrlblTTDA[icount-1]
                                
                                lable.frame = CGRect(x: 10, y: 0 , width: (self.UiViewQDDT.frame.width - 10)/2, height: 25)
                                lable.numberOfLines = 0
                                lable.sizeToFit()
                                uiView.addSubview(lable)
                                var haftWidth : CGFloat = (self.UiViewQDDT.frame.width - 10)/2
                                if !(icount%2==0){
                                    haftWidth = 0
                                }
                                uiView.frame = CGRect(x: 5 + haftWidth,y: self.totalHeight ,width: (self.UiViewQDDT.frame.width - 10)/2 , height: 25)
                                self.totalHeight = self.totalHeight + 25
                                ViewGroupTTCQDDT.addSubview(uiView)
                                
                                
                                uiView = UIView()
                                  uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                                //self.uiViewThongTin.addSubview(uiView)
                                print(lable.frame.height)
                                var lblTenDuAn:UILabel = UILabel()
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
                                uiView.frame = CGRect(x: 5 + haftWidth,y: self.totalHeight ,width: (self.UiViewQDDT.frame.width - 10)/2, height: 25)
                                
                                var calHeight : CGFloat = 26
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
                        if arrTTDA.count%2==0 {
                            var uiView = UIView()
                            uiView.backgroundColor = UIColor(netHex: 0xdddddd)
                            uiView.frame = CGRect(x: 0 + (self.UiViewQDDT.frame.width)/2 , y: self.totalHeight ,width: (self.UiViewQDDT.frame.width)/2 - 5, height: 50)
                            ViewGroupTTCQDDT.addSubview(uiView)
                            self.totalHeight = self.totalHeight + 50
                        }
                        self.UiViewQDDT.addSubview(ViewGroupTTCQDDT)
                        // đặt lại giá trị constrain cho view
                        let heightConstraint = self.UiViewQDDT.heightAnchor.constraint(equalToConstant:  self.totalHeight )
                        //        self.UiViewQDDT.isUserInteractionEnabled = true
                        NSLayoutConstraint.activate([heightConstraint])
                        
                    }
                }
            }
        }
    }
    
    func Error(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
