//
//  BDNVDT_.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import Charts

class BDNVDT_VC: Base_VC{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    @IBOutlet weak var pieCharNV: PieChartView!

    
    @IBOutlet weak var scView: UIScrollView!
    @IBOutlet weak var viewLegend: UIView!
    
    var arrNguonVons : [String] = []
    var arrGiaTris : [Double] = []
    let arrColors = [0x3399FF,0xFF33FF,0x996666,0xFF9900,0x00CC99,0xfe6400,0x73b751,
                     0x00a3c2,0xadacad,0xffc603,0xf8c7b6,0xfeff01,0xffe4d7,0xcddbed]
    
    var ApiUrl : String = ""
    var params : String = ""
    
    var refreshControl: UIRefreshControl!
    var bcheck = true
    
    @IBOutlet weak var constraintWidthChart: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightChart: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomChart: NSLayoutConstraint!
    @IBOutlet weak var constraintRightChart: NSLayoutConstraint!
    
    @IBOutlet weak var constraintWidthScrollLegend: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightScrollLegend: NSLayoutConstraint!
    
    @IBOutlet weak var constraintWidthLegend: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightLegend: NSLayoutConstraint!
    
    func setConstraint(height : CGFloat, width : CGFloat){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                let hBar = UIApplication.shared.statusBarFrame.height +
                    self.navigationController!.navigationBar.frame.height
                let w = width
                var h = height
                // 34: height header
                h = h - hBar - 34
                if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
                    self.constraintWidthChart.constant = w
                    self.constraintHeightChart.constant = 310
                    self.constraintBottomChart.constant = h - 310 + 1
                    self.constraintRightChart.constant = 0
                    
                    self.constraintWidthScrollLegend.constant = w
                    self.constraintHeightScrollLegend.constant = h - 310
                }
                if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
                    self.constraintWidthChart.constant = w * 5.5/10
                    self.constraintHeightChart.constant = h
                    self.constraintBottomChart.constant = 1
                    self.constraintRightChart.constant = w * 4.5/10
                    
                    self.constraintWidthScrollLegend.constant = w * 4.5/10
                    self.constraintHeightScrollLegend.constant = h + 1
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setConstraint(height: size.height, width: size.width)
        //setLegend()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint(height: view.frame.height, width: view.frame.width)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        pieCharNV.isHidden = true
        viewLegend.isHidden = true
        
        for item in scView.subviews {
            if item.tag == 101 {
                bcheck = false
            }
        }
        if bcheck == true {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:  #selector(DSDA_VC.refresh(sender: )), for: UIControlEvents.valueChanged)
            refreshControl.tintColor = UIColor(netHex: 0x21AFFA)
            refreshControl.tag = 101
            self.scView.addSubview(refreshControl)
        }
        
         ApiUrl  = "\(UrlPreFix.QLDA.rawValue)/GetBieuDoNguonVon"
         params  = "{\"szUsername\" : \"demo1\", \"szPassword\": \"abc@123\"}"
      ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: getDataBieuDoNguonVon, errorCallBack: alertAction)
     //   ApiService.Post(url: ApiUrl, params: params, callback: getDataBieuDoNguonVon, errorCallBack: getDataBieuDoNguonVonError)
    }

    func refresh(sender:AnyObject) {
         ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: getDataBieuDoNguonVon, errorCallBack: alertAction)
    }
    func getDataBieuDoNguonVon(data : SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }

        
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        if let dic = json as? [String:Any] {
            if let items = dic["GetBieuDoNguonVonResult"] as? [[String]] {
                //for item in items{
                self.arrNguonVons = items[0]
                self.arrGiaTris = items[1].flatMap{Double($0)}
                //}
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating() 
                self.pieCharNV.isHidden = false
                self.viewLegend.isHidden = false
                self.setChart()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    func getDataBieuDoNguonVonError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart() {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<arrNguonVons.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: self.arrGiaTris[i], data: arrNguonVons[i] as AnyObject? ))
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.drawValuesEnabled = false
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieCharNV.data = pieChartData
        pieCharNV.legend.enabled = false
        pieCharNV.usePercentValuesEnabled = true
        pieCharNV.chartDescription?.enabled = false
        pieCharNV.minOffset=0
        
        let colors: [UIColor] = [UIColor.init(netHex:0x3399FF),
                                 UIColor.init(netHex:0xFF33FF),
                                 UIColor.init(netHex:0x996666),
                                 UIColor.init(netHex:0xFFFF33),
                                 UIColor.init(netHex:0xFF3366),
                                 UIColor.init(netHex:0xFF9900),
                                 UIColor.init(netHex:0x00CC99)]
        pieChartDataSet.colors = colors
        //let screenSize:CGRect = UIScreen.main.bounds
    
        // tao Legend Custom: dua legend vao 2 View  duoi bieu do
        var yA = 10
        var maxWidth : CGFloat = 0
        let size = CGSize(width: 1000, height: 20)
        for i in 0..<arrNguonVons.count {
            // tao o vuong mau sac ung voi mau tren bieu do
            let dynamicSquare = UIView()
            dynamicSquare.draw(CGRect(x: 0, y: 0, width: 15, height: 15))
            dynamicSquare.backgroundColor = UIColor.init(netHex:arrColors[i])
            
            // tao Label ten cac co cau tong muc dau tu
            let dynamicLabel: UILabel = UILabel()
            dynamicLabel.textColor = UIColor.black
            dynamicLabel.font = UIFont(name: dynamicLabel.font.fontName, size: 13)
            dynamicLabel.textAlignment = NSTextAlignment.left
            
            dynamicLabel.text = arrNguonVons[i] + ": " + String(arrGiaTris[i].doubleToString)
            
            // dua cac thong tin vao view
            
            dynamicSquare.frame = CGRect(x: 5, y: yA + 3, width: 15, height: 15)
            dynamicLabel.frame = CGRect(x: 22, y: yA, width: Int(view.frame.width), height: 20)
            
            let temp = (dynamicLabel.text?.computeTextSize(size: size, font: dynamicLabel.font).width)! + 22 + 4
            maxWidth = max(maxWidth, temp)
            viewLegend.addSubview(dynamicSquare)
            viewLegend.addSubview(dynamicLabel)
            yA = yA + 20
        }
        constraintHeightLegend.constant = CGFloat(yA)
        constraintWidthLegend.constant = maxWidth
    }
}

