//
//  NhomHopDong.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 16/03/2017.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class NhomHopDong{
    init() {
        SoPhanLoai = 0
        LoaiHopDong = ""
        GiaTriHopDong = ""
        GiaTriLK = ""
        NhomHopDong = [HopDong]()
    }
    var SoPhanLoai : Int?
    var LoaiHopDong : String?
    var GiaTriHopDong : String?
    var GiaTriLK : String?
    var NhomHopDong : [HopDong]?
}
