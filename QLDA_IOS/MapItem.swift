//
//  MapItem.swift
//  QLDA_IOS
//
//  Created by MinhHieu on 3/2/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
class MapItem {
    
    init() {
         DuAnID = 0
         DuAnChaID = 0
         DiaDiemXayDung = ""
         KinhDo = 0
         ViDo = 0
         TenDuAn = ""
         isDuAnCon = false
        TMDT = 0
        GiaiNgan = 0
        ThoiGian = ""
    }
    var DuAnID : Int?
    var DuAnChaID : Int?
    var DiaDiemXayDung : String?
    var KinhDo : Double?
    var ViDo : Double?
    var TenDuAn : String?
    var isDuAnCon : Bool?
    var TMDT : Double?
    var GiaiNgan : Double?
    var ThoiGian : String?
}
