//
//  Base.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/22/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
public class Base : UIViewController {
    
    func noConnectToServer(errorEntity:ErrorEntity) {
        let error = errorEntity.error
        print(error!.localizedDescription)
        let message = "Vui lòng bật 3G/Wifi để sử dụng phần mềm!"
        let alert = UIAlertController(title: "Lỗi kết nối!", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Thử lại", style: .default, handler: { (action: UIAlertAction!) in
       
    }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func alertAction(alert: UIAlertController) {
        
            let message = "Vui lòng bật 3G/Wifi để sử dụng phần mềm!"
            let alert = UIAlertController(title: "Lỗi kết nối!", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Thử lại", style: .default, handler: { (action: UIAlertAction!) in
              self.viewDidLoad()
            }))
        
            self.present(alert, animated: true, completion: nil)
        }
    
    func serverError(success:SuccessEntity) {
        
        let message = "Server đang bảo trì hoặc gặp vấn đề. Xin vui lòng liên lạc đơn vị quản lý để nhận hỗ trợ"
        let alert = UIAlertController(title: "Xin lỗi!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Thử lại", style: .default, handler: { (action: UIAlertAction!) in
         self.viewDidLoad()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
