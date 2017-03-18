//
//  NotificationItem.swift
//  QLDA_IOS
//
//  Created by namos on 3/16/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import Foundation
class NotificationItem {
    
    init() {
        NotificationID = 0
        NotificationProID = 0
        NotificationTitle = ""
        NotificationCreated = nil
        NotificationisRead = false
    }
    
    var NotificationID : Int?
    var NotificationTitle :String?
    var NotificationisRead : Bool?
    var NotificationCreated :Date?
    var NotificationProID :Int?
    
}
