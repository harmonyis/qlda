//
//  Base.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/22/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class Base : UIViewController {
    func printError() {
        print("out")
    }
    
    func noConnectToServer(errorEntity:ErrorEntity) {
        let error = errorEntity.error
        print(error!.localizedDescription)
        let message = "Vui lòng bật 3G/Wifi để sử dụng phần mềm!"
        let alert = UIAlertController(title: "Lỗi kết nối!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func serverError(success:SuccessEntity) {
        print("Lỗi kết nối server")
        
        let message = "Server đang bảo trì hoặc gặp vấn đề. Xin vui lòng liên lạc đơn vị quản lý để nhận hỗ trợ"
        let alert = UIAlertController(title: "Xin lỗi!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
