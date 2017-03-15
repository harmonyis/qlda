//
//  Config.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
import UIKit
class Config{
    static var SelectMenuIndex : Int32 = 0
    static var userID : Int = 0
    static var userName : String = ""
    static var passWord : String = ""
    
    static func InitApp(){
        SelectMenuIndex = 0
        userID = 0
        userName = ""
        passWord = ""        
        
        ChatHub.stopHub()        
        ChatCommon.reset()
        
        variableConfig.m_szIdDuAn = 0
        variableConfig.m_szTenDuAn = ""
        variableConfig.m_szUserName = ""
        variableConfig.m_szPassWord = ""
    }
}

