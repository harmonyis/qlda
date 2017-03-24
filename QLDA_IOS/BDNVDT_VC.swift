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

    
    @IBOutlet weak var viewLegend: UIView!
    
    var arrNguonVons : [String] = []
    var arrGiaTris : [Double] = []
    let arrColors = [0x3399FF,0xFF33FF,0x996666,0xFF9900,0x00CC99,0xfe6400,0x73b751,
                     0x00a3c2,0xadacad,0xffc603,0xf8c7b6,0xfeff01,0xffe4d7,0xcddbed]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        pieCharNV.isHidden = true
        viewLegend.isHidden = true
        
        
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetBieuDoNguonVon"
        let params : String = "{\"szUsername\" : \"demo1\", \"szPassword\": \"abc@123\"}"
      ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: getDataBieuDoNguonVon, errorCallBack: alertAction)
     //   ApiService.Post(url: ApiUrl, params: params, callback: getDataBieuDoNguonVon, errorCallBack: getDataBieuDoNguonVonError)
    }

    func getDataBieuDoNguonVon(data : SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }

        
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        if let dic = json as? [String:Any] {
            print(dic)
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
        var yA = 20
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
            dynamicSquare.frame = CGRect(x: 5, y: yA, width: 15, height: 15)
            dynamicLabel.frame = CGRect(x: 22, y: yA, width: Int(view.frame.width), height: 21)
            
            viewLegend.addSubview(dynamicSquare)
            viewLegend.addSubview(dynamicLabel)
            yA = yA + 20
        }
        
    }
   

}

