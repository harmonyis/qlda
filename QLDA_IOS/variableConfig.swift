//
//  variableConfig.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 03/03/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation

public class variableConfig {
    static var m_szIdDuAn : Int = 0
    static var m_szTenDuAn : String = ""
    static var m_szUserName : String = ""
    
    static var m_szPassWord : String = ""
    static func convert(_ sztext: String) -> String {
     if !(sztext==""){
        var dValue = (Double)(sztext)
        return String(format:"%.3f",dValue!/1000000)
        }
        else
     {
        return "0"
        }
        
    }
}

