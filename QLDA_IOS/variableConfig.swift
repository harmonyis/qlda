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
        var doubleRound = (Double)(sztext)!/1000000

        var arrDouble = String(doubleRound).components(separatedBy: ".")
        var dou = Double(arrDouble[0])
        var doubleFormat = Number.formatterWithSeparator.string(from: NSNumber(value: dou!)) ?? ""
        if arrDouble[1] != "0" && arrDouble[1] != ""{
            if arrDouble[1].characters.count<4 {
            doubleFormat = doubleFormat + "," + arrDouble[1]
            }
            else
            {
            doubleFormat = doubleFormat + "," + arrDouble[1][0]  + arrDouble[1][1]  + arrDouble[1][2]
            }
        }
        return doubleFormat
      }
      else
      {
        return "0"
        }
        
    }
}

