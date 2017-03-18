//
//  CanhBaoEntity.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/13/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class CanhBaoEntity {
    var titleSection : String = ""
    var arrSection : [Section] = []
}
class Section {
    var type : Int
    init( type:Int ) {
        self.type = type
    }
}
class CTHHDSection : Section {
    var title : String = ""
    init(type: Int, title: String){
        super.init(type: type)
        self.title = title
    }
}
class TTHopDong : Section {
    var tenHD : String = ""
    var ngayBD : String = ""
    var thoiGianTH  : String = ""
    var ngayKT : String = ""
    var ngayCham : String = ""
    
    init (type:Int,tenHD : String, ngayBD : String, thoiGianTH  :String, ngayKT : String, ngayCham:String) {
        //self.type = type
        //type = type
        self.tenHD = tenHD
        self.ngayBD = ngayBD
        self.thoiGianTH = thoiGianTH
        self.ngayKT = ngayKT
        self.ngayCham = ngayCham
        super.init(type: type)
    }
}

class ChamNHSQT : Section {
    var ngayKyBB : String = ""
    var thoiGianQD : String = ""
    var ngayDuKienTrinh : String = ""
    var ngayCham : String = ""
    var ghiChu : String = ""
    init(type : Int, ngayKyBB : String, thoiGianQD : String, ngayDuKienTrinh : String, ngayCham : String, ghiChu : String) {
        super.init(type: type)
        self.ngayKyBB = ngayKyBB
        self.thoiGianQD = thoiGianQD
        self.ngayDuKienTrinh = ngayDuKienTrinh
        self.ngayCham = ngayCham
        self.ghiChu = ghiChu
    }
}

class ChamPDHSQT : Section {
    var ngayNhanDuHS : String = ""
    var thoiGianQD : String = ""
    var ngayDuKienPD : String = ""
    var ngayCham : String = ""
    var ghiChu : String = ""
    init(type : Int, ngayNhanDuHS : String, thoiGianQD : String,ngayDuKienPD : String,ngayCham : String,ghiChu : String) {
        super.init(type: type)
        self.ngayNhanDuHS = ngayNhanDuHS
        self.thoiGianQD = thoiGianQD
        self.ngayDuKienPD = ngayDuKienPD
        self.ngayCham = ngayCham
        self.ghiChu = ghiChu
    }
}
