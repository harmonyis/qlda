//
//  VanBanEntity.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class VanBanEntity {
    var tenVanBan : String = ""
    var soVanBan : String = ""
    var ngayBanHanh : String = ""
    var coQuanBanHanh : String = ""
    var tenFileVanBan : String = ""
    var duongDan : String = ""
    init (tenVanBan : String, soVanBan : String, ngayBanHanh : String, coQuanBanHanh : String, tenFileVanBan : String, duongDan : String) {
        self.tenVanBan = tenVanBan
        self.soVanBan = soVanBan
        self.ngayBanHanh = ngayBanHanh
        self.coQuanBanHanh = coQuanBanHanh
        self.tenFileVanBan = tenFileVanBan
        self.duongDan = duongDan
    }
}
