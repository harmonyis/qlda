

import UIKit
import Charts

class BDTMDT_VC: Base_VC {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var viewBDTMDT: UIView!
    @IBOutlet weak var pieChartTMDT: PieChartView!
    
    @IBOutlet weak var viewLegendRight: UIView!
    
    @IBOutlet weak var viewLegendLeft: UIView!
    
    
    @IBOutlet weak var scView: UIScrollView!
    var ApiUrl : String = ""
    var params : String = ""
    
    var refreshControl: UIRefreshControl!
    var bcheck = true
    
    let arrCoCaus = ["Xây lắp", "Thiết bị", "GPMB", "QLDA", "Tư vấn", "Khác", "Dự phòng"]
    var arrGiaTris : [Double] = []
    let arrColors = [0x3399FF,0xFF33FF,0x996666,0xFFFF33,0xFF3366,0xFF9900,0x00CC99]
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        pieChartTMDT.isHidden = true
        viewLegendRight.isHidden = true
        viewLegendLeft.isHidden = true
        
        
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
         ApiUrl  = "\(UrlPreFix.QLDA.rawValue)/GetBieuDoTMDT"
        //let szUser=lblName.
         params = "{\"szUsername\" : \"demo1\", \"szPassword\": \"abc@123\"}"
        
        ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: getDataTMDT, errorCallBack: alertAction)
        
        // ApiService.Post(url: ApiUrl, params: params, callback: getDataTMDT, errorCallBack: getDataTMDTError)
        
    }
    func refresh(sender:AnyObject) {
          ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: getDataTMDT, errorCallBack: alertAction)
        
    }
    
    func getDataTMDT(data : SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }
        
        
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        if let dic = json as? [String:Any] {
            if let items = dic["GetBieuDoTMDTResult"] as? [Double] {
                for item in items{
                    self.arrGiaTris.append(item)
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.pieChartTMDT.isHidden = false
                self.viewLegendRight.isHidden = false
                self.viewLegendLeft.isHidden = false
                self.setChart()
                  self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func getDataTMDTError(error : Error) {
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
        
        for i in 0..<arrCoCaus.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: self.arrGiaTris[i], data: arrCoCaus[i] as AnyObject? ))
        }
        print(arrGiaTris)
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.drawValuesEnabled = false
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartTMDT.data = pieChartData
        pieChartTMDT.legend.enabled = false
        pieChartTMDT.usePercentValuesEnabled = true
        pieChartTMDT.chartDescription?.enabled = false
        pieChartTMDT.minOffset=0
        
        let colors: [UIColor] = [UIColor.init(netHex:0x3399FF),
                                 UIColor.init(netHex:0xFF33FF),
                                 UIColor.init(netHex:0x996666),
                                 UIColor.init(netHex:0xFFFF33),
                                 UIColor.init(netHex:0xFF3366),
                                 UIColor.init(netHex:0xFF9900),
                                 UIColor.init(netHex:0x00CC99)]
        pieChartDataSet.colors = colors
        let screenSize:CGRect = UIScreen.main.bounds
        viewLegendLeft.frame.size.width	 = screenSize.width / 2
        viewLegendRight.frame.size.width = screenSize.width / 2
        
        
        // tao Legend Custom: dua legend vao 2 View  duoi bieu do
        var yAL = 20
        var yAR = 20
        for i in 0..<arrCoCaus.count {
            var yA = 0
            var uiView = UIView()
            // tao o vuong mau sac ung voi mau tren bieu do
            let dynamicSquare = UIView()
            dynamicSquare.draw(CGRect(x: 0, y: 0, width: 15, height: 15))
            dynamicSquare.backgroundColor = UIColor.init(netHex:arrColors[i])
            
            // tao Label ten cac co cau tong muc dau tu
            let dynamicLabel: UILabel = UILabel()
            dynamicLabel.textColor = UIColor.black
            dynamicLabel.font = UIFont(name: dynamicLabel.font.fontName, size: 13)
            dynamicLabel.textAlignment = NSTextAlignment.left
            dynamicLabel.text = arrCoCaus[i] + ": " + String(arrGiaTris[i].doubleToString)
            
            // dua cac thong tin vao view
            if i % 2 != 0{
                uiView = viewLegendRight
                yA = yAR
                yAR = yAR + 20
            }
            else{
                uiView = viewLegendLeft
                
                yA = yAL
                yAL = yAL + 20
            }
            dynamicSquare.frame = CGRect(x: 5, y: yA, width: 15, height: 15)
            dynamicLabel.frame = CGRect(x: 22, y: yA, width: Int(view.frame.width), height: 21)
            
            
            uiView.addSubview(dynamicSquare)
            uiView.addSubview(dynamicLabel)
        }
        
        /*let l : Legend = pieChartTMDT.legend
         l.verticalAlignment = Legend.VerticalAlignment.top
         l.horizontalAlignment = Legend.HorizontalAlignment.left
         l.orientation  = Legend.Orientation.vertical
         l.setCustom(colors: [UIColor.init(netHex:0x3399FF),
         UIColor.init(netHex:0xFF33FF),
         UIColor.init(netHex:0x996666),
         UIColor.init(netHex:0xFFFF33),
         UIColor.init(netHex:0xFF3366),
         UIColor.init(netHex:0xFF9900),
         UIColor.init(netHex:0x00CC99)],
         labels: ["Xây lắp", "Thiết bị", "GPMB", "QLDA", "Tư vấn", "Khác", "Dự phòng"])
         l.wordWrapEnabled = true
         */
        
    }
    
}

