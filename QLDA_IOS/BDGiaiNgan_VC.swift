//
//  BDGiaiNgan_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import Charts

class BDGiaiNgan_VC: Base_VC {

    @IBOutlet weak var activityIndicartor: UIActivityIndicatorView!
  
    @IBOutlet weak var barCharGN: BarChartView!
    
    var arrYears = [String]()
    var arrKHs = [Double]()
    var arrGNs = [Double]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicartor.startAnimating()
        activityIndicartor.hidesWhenStopped = true
        barCharGN.isHidden = true

        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetBieuDoGiaiNgan"
        //let szUser=lblName.
        let params : String = "{\"szUsername\" : \"demo1\", \"szPassword\": \"abc@123\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: getDataGN, errorCallBack: getDataGNError)
    }

    func getDataGN(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let items = dic["GetBieuDoGiaiNganResult"] as? [[String]] {
                let itemSorts = items.sorted{
                  $0[0] < $1[0]
                }
                for item in itemSorts{
                   arrYears.append(item[0])
                    arrKHs.append(Double(item[1])!/1000000)
                    arrGNs.append(Double(item[2])!/1000000)
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.activityIndicartor.stopAnimating()
                self.barCharGN.isHidden = false
                self.setChart()
            }
        }
    }
    
    func getDataGNError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setChart() {
        barCharGN.chartDescription?.enabled = false
        
        //legend
        let legend = barCharGN.legend
        legend.enabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        let xaxis = barCharGN.xAxis
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.arrYears)
        xaxis.granularity = 1
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barCharGN.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = true
        yaxis.valueFormatter = YAxisValueFormatted()
        
        barCharGN.rightAxis.enabled = false
        
        
        barCharGN.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<self.arrYears.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.arrKHs[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.self.arrGNs[i])
            dataEntries1.append(dataEntry1)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Kế hoạch vốn")
        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Giải ngân")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [UIColor(red: 103/255, green: 183/255, blue: 220/255, alpha: 1)]
        chartDataSet1.colors = [UIColor(red: 253/255, green: 212/255, blue: 0/255, alpha: 1)]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = self.arrYears.count
        let startYear = 0
        
        
        chartData.barWidth = barWidth;
        barCharGN.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barCharGN.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        barCharGN.notifyDataSetChanged()
        
        barCharGN.data = chartData
        
        //background color
        //barCharGN.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
        barCharGN.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        
    }
    

}
