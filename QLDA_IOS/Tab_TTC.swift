//
//  Tab_TTC.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 02/03/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip

class Tab_TTC: Base, IndicatorInfoProvider {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "Thông tin chung")
    var m_arrTTDA : [String] = [String]()
    @IBOutlet weak var uiViewThongTin: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        uiViewThongTin.isHidden = true
        //  self.ViewData.autoresizesSubviews = true
        uiViewThongTin.layer.borderColor = myColorBoder.cgColor
        uiViewThongTin.layer.borderWidth = 1
        
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetThongTinDuAn"
        //let szUser=lblName.
        let params : String = "{\"szIdDuAn\" : \""+(String)(variableConfig.m_szIdDuAn)+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        
        ApiService.PostAsyncAc(url: ApiUrl, params: params,  callback: loadDataSuccess, errorCallBack: alertAction)
        
    }
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    func loadDataSuccess(data : SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        if let dic = json as? [String:Any] {
            
            if let arrTTDA = dic["GetThongTinDuAnResult"] as? [String] {
                m_arrTTDA = arrTTDA
            }
            LoadDataTTC()
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        for item in uiViewThongTin.subviews {
            
            item.removeFromSuperview()
            
        }
        LoadDataTTC()
        
    }
    
    func LoadDataTTC(){
        let arrlblTTDA = ["Tên dự án","Chủ đầu tư","Mục tiêu","Quy mô","Thời gian thực hiện","Lĩnh vực","Nhóm dự án","Hình thức đầu tư","Hình thức quản lý dự án","Giai đoạn dự án","Tình trạng dự án","Nguồn vốn"]
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                
                self.uiViewThongTin.isHidden = false
                
                var icount = 0
                var totalHeight : CGFloat = 5
                for itemTTDA in self.m_arrTTDA {
                    var uiView = UIView()
                    let lable:UILabel = UILabel()
                    
                    if icount > 0 {
                        lable.textColor = UIColor.black
                        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                        lable.text = arrlblTTDA[icount]
                        
                        lable.frame = CGRect(x: 10, y: 5 , width: self.uiViewThongTin.frame.width, height: CGFloat.greatestFiniteMagnitude)
                        lable.numberOfLines = 0
                        lable.sizeToFit()
                        uiView.addSubview(lable)
                        
                        uiView.frame = CGRect(x: 0,y: totalHeight ,width: self.uiViewThongTin.frame.width - 10 , height: lable.frame.height + 4)
                        totalHeight = totalHeight + uiView.frame.height
                        
                        self.uiViewThongTin.addSubview(uiView)
                        uiView = UIView()
                        
                        
                        let lblTenDuAn:UILabel = UILabel()
                        lblTenDuAn.textColor = UIColor.black
                        lblTenDuAn.font = UIFont(name:"HelveticaNeue", size: 13.0)
                        lblTenDuAn.text = itemTTDA
                        lblTenDuAn.frame = CGRect(x: 10, y: 30 , width: self.uiViewThongTin.frame.width - 10,  height: CGFloat.greatestFiniteMagnitude)
                        
                        lblTenDuAn.numberOfLines = 0
                        lblTenDuAn.sizeToFit()
                        
                        
                        uiView.addSubview(lblTenDuAn)
                        var calHeight : CGFloat = 27
                        if lblTenDuAn.frame.height > 20 {
                            calHeight = lblTenDuAn.frame.height + 7
                        }
                        uiView.frame = CGRect(x: 5,y: totalHeight ,width: self.uiViewThongTin.frame.width - 10, height: calHeight + 4)
                        totalHeight = totalHeight + uiView.frame.height
                        
                        let borderBottom = CALayer()
                        let borderWidth = CGFloat(1)
                        borderBottom.borderColor =  self.myColorBoder.cgColor
                        borderBottom.borderWidth = borderWidth
                        borderBottom.frame = CGRect(x: 0, y: calHeight, width: self.uiViewThongTin.frame.width, height: 1)
                        uiView.layer.addSublayer(borderBottom)
                        uiView.layer.masksToBounds = true
                        
                        self.uiViewThongTin.addSubview(uiView)
                    }
                    icount = 1 + icount
                }
                
                let heightConstraint = self.uiViewThongTin.heightAnchor.constraint(equalToConstant: totalHeight + 5 )
                
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
