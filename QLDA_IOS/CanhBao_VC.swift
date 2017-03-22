//
//  CanhBao_.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class CanhBao_VC: Base {

    @IBOutlet weak var tbCanhBao: UITableView!
    
    
    @IBOutlet weak var lblHeader: UILabel!

    var datasource : CanhBaoDatasource?
    var datasourceLand : CanhBaoLandDatasource?
    var userName = variableConfig.m_szUserName
    var password = variableConfig.m_szPassWord
    var arrData : [CanhBaoEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printError()
        
        print("reload")
        var nib = UINib(nibName: "CanhBaoTableViewCell", bundle: nil)
        self.tbCanhBao.register(nib, forCellReuseIdentifier: "cell")
        nib = UINib(nibName: "CellHopDongTableViewCell", bundle: nil)
        self.tbCanhBao.register(nib, forCellReuseIdentifier: "cellHD")
        self.tbCanhBao.register(UINib(nibName: "CellHopDongHiddenTableViewCell", bundle: nil), forCellReuseIdentifier: "cellHDHidden")
        

        
        //CBChamQTTableViewCell
        nib = UINib(nibName: "CBHeaderTableViewCell", bundle: nil)
        self.tbCanhBao.register(nib, forCellReuseIdentifier: "cellHeader")
        nib = UINib(nibName: "CBChamQTTableViewCell", bundle: nil)
        self.tbCanhBao.register(nib, forCellReuseIdentifier: "cellChamQT")
        self.tbCanhBao.register(UINib(nibName: "CBChamQTHiddenTableViewCell", bundle: nil), forCellReuseIdentifier: "cellChamQTHidden")
        
        self.tbCanhBao.register(UINib(nibName: "CellHopDongLandTableViewCell", bundle: nil), forCellReuseIdentifier: "cellHDLand")
        self.tbCanhBao.register(UINib(nibName: "CellChamQTLandTableViewCell", bundle: nil), forCellReuseIdentifier: "cellChamQTLand")
        self.tbCanhBao.register(UINib(nibName: "CellHopDongTitleLandTableViewCell", bundle: nil), forCellReuseIdentifier: "cellHDTitleLand")
        
        self.tbCanhBao.rowHeight = UITableViewAutomaticDimension
        self.tbCanhBao.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tbCanhBao.separatorColor = UIColor.clear
        self.tbCanhBao.estimatedRowHeight = 300
        self.tbCanhBao.estimatedSectionHeaderHeight = 100
        loadData()
        
        //print(addMonth(date: "20/11/2016",month: "2"))
        //self.datasource = CanhBaoDatascource()
        //let nib = UINib(nibName: "CanhBaoTableViewCell", bundle: nil)
        //self.tbCanhBao.register(nib, forCellReuseIdentifier: "cell")
        //self.tbCanhBao.dataSource = self.datasource
        //self.tbCanhBao.delegate = self.datasource
        //self.tbCanhBao.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let apiUrl = "\(UrlPreFix.QLDA.rawValue)/GetHopDongCham"
        let params = "{\"szUsername\":\"\(self.userName)\",\"szPassword\":\"\(self.password)\"}"
        ApiService.PostAsync(url: apiUrl, params: params, callback: loadDataSuccess, errorCallBack: loadDataError)
    }
    
    func loadDataSuccess(data : SuccessEntity) {
        //print("data")
        let json = try? JSONSerialization.jsonObject(with: data.data! , options: [])
        if let dic = json as? [String:Any] {
            if let jsonResult = dic["GetHopDongChamResult"] as? [[String]] {
                var canhBao : CanhBaoEntity = CanhBaoEntity()
                for item in jsonResult {
                    if arrData.contains(where: { (canhBaoEntity) -> Bool in
                        if (canhBaoEntity.titleSection == item[1]) {
                            canhBao = canhBaoEntity
                            return true
                        } else {
                            return false
                        }
                    }) {
                        //print(canhBao.titleSection)
                        if item[0] == "0" {
                            canhBao.arrSection.append(TTHopDong(type: 0, tenHD: item[2], ngayBD: item[3], thoiGianTH: item[4], ngayKT: item[5], ngayCham: item[6]))
                        } else if item[0] == "1" {
                            canhBao.arrSection.append(ChamNHSQT(type: 1, ngayKyBB: item[2], thoiGianQD: item[4], ngayDuKienTrinh: addMonth(date: item[2], month: item[4]), ngayCham: item[5], ghiChu: "Dự án chưa phê duyệt HSQT"))
                        } else if item[0] == "2" {
                            canhBao.arrSection.append(ChamNHSQT(type: 2, ngayKyBB: item[2], thoiGianQD: item[4], ngayDuKienTrinh: addMonth(date: item[2], month: item[4]), ngayCham: item[5], ghiChu: "Ngày phê duyệt: \(item[3]) chậm so với quy định"))
                        } else if item[0] == "3" {
                            canhBao.arrSection.append(ChamPDHSQT(type: 4, ngayNhanDuHS: item[2], thoiGianQD: item[4], ngayDuKienPD: addMonth(date: item[2], month: item[4]), ngayCham: item[5], ghiChu: "Dự án chưa phê duyệt HSQT"))
                        } else {
                            canhBao.arrSection.append(ChamPDHSQT(type: 4, ngayNhanDuHS: item[2], thoiGianQD: item[4], ngayDuKienPD: addMonth(date: item[2], month: item[4]), ngayCham: item[5], ghiChu: "Ngày phê duyệt: \(item[3]) chậm so với quy định"))
                        }
                    } else {
                        canhBao = CanhBaoEntity()
                        canhBao.titleSection = item[1]
                        var arrSection : [Section] = []
                        if item[0] == "0" {
                            arrSection.append(CTHHDSection(type: -1, title: "Chậm thực hiện hợp đồng"))
                            arrSection.append(TTHopDong(type: 0, tenHD: item[2], ngayBD: item[3], thoiGianTH: item[4], ngayKT: item[5], ngayCham: item[6]))
                        } else if item[0] == "1" {
                            arrSection.append(ChamNHSQT(type: 1, ngayKyBB: item[2], thoiGianQD: item[4], ngayDuKienTrinh: addMonth(date: item[2], month: item[4]), ngayCham: item[5], ghiChu: "Dự án chưa phê duyệt HSQT"))
                        } else if item[0] == "2" {
                            arrSection.append(ChamNHSQT(type: 2, ngayKyBB: item[2], thoiGianQD: item[4], ngayDuKienTrinh: addMonth(date: item[2], month: item[4]), ngayCham: item[5], ghiChu: "Ngày phê duyệt: \(item[3]) chậm so với quy định"))
                        } else if item[0] == "3" {
                            arrSection.append(ChamPDHSQT(type: 3, ngayNhanDuHS: item[2], thoiGianQD: item[4], ngayDuKienPD: addMonth(date: item[2], month: item[4]), ngayCham: item[5], ghiChu: "Dự án chưa phê duyệt HSQT"))
                        } else {
                            arrSection.append(ChamPDHSQT(type: 4, ngayNhanDuHS: item[2], thoiGianQD: item[4], ngayDuKienPD: addMonth(date: item[2], month: item[4]), ngayCham: item[5], ghiChu: "Ngày phê duyệt: \(item[3]) chậm so với quy định"))
                        }
                        canhBao.arrSection = arrSection
                        
                        arrData.append(canhBao)
                    }
                }
                
                
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.lblHeader.text = "Danh sách dự án cảnh báo (\(self.arrData.count) dự án)"
                        if UIDevice.current.orientation.isLandscape {
                            
                            self.datasourceLand = CanhBaoLandDatasource(arrData: self.arrData, table : self.tbCanhBao)
                            self.tbCanhBao.dataSource = self.datasourceLand
                            self.tbCanhBao.delegate = self.datasourceLand
                            self.tbCanhBao.reloadData()
                            //self.lblHeader.text = "Danh sách dự án cảnh báo (\(self.arrData.count) dự án)"
                            
                            
                        } else {
                            self.datasource = CanhBaoDatasource(arr: self.arrData, table : self.tbCanhBao)
                            self.tbCanhBao.dataSource = self.datasource
                            self.tbCanhBao.delegate = self.datasource
                            self.tbCanhBao.reloadData()
                        }

                    }
                }
                
            }
        }

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.datasourceLand = CanhBaoLandDatasource(arrData: self.arrData, table : self.tbCanhBao)
            self.tbCanhBao.dataSource = self.datasourceLand
            self.tbCanhBao.delegate = self.datasourceLand
            self.tbCanhBao.reloadData()
            //self.lblHeader.text = "Danh sách dự án cảnh báo (\(self.arrData.count) dự án)"
 
            
        } else {
            self.datasource = CanhBaoDatasource(arr: self.arrData, table : self.tbCanhBao)
            self.tbCanhBao.dataSource = self.datasource
            self.tbCanhBao.delegate = self.datasource
            self.tbCanhBao.reloadData()
        }
    }
    
    func addMonth(date:String, month : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateTime = dateFormatter.date(from: date)
        let dateTimeAdded = Calendar.current.date(byAdding: .month, value: Int(month)!, to: dateTime!)
        return dateFormatter.string(from: dateTimeAdded!)
    }
    func loadDataError(error : ErrorEntity) {
        print(error.error!.localizedDescription)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
