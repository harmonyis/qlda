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
    static var profifePictureUrl = ""
    static var profilePicture : UIImage? = nil
    static var loginName : String = ""
    static var nTotalNotificationNotRead : Int32 = 0
    static var bCheckRead : Bool = false
    
    static func InitApp(){
        SelectMenuIndex = 0
        userID = 0
        userName = ""
        passWord = ""
        profifePictureUrl = ""
        profilePicture = nil
        loginName = ""
        nTotalNotificationNotRead = 0
        bCheckRead = false
        
        ChatHub.stopHub()        
        ChatCommon.reset()
        
        variableConfig.m_szIdDuAn = 0
        variableConfig.m_szTenDuAn = ""
        variableConfig.m_szUserName = ""
        variableConfig.m_szPassWord = ""
    }
    
    static func GetCurrentUser(){
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetUser/\(userID)"
        print(apiUrl)
        ApiService.Get(url: apiUrl, callback: callbackGetUser, errorCallBack: { (error) in
            print("error")
            print(error.localizedDescription)
        })
    }
    private static func callbackGetUser(data : Data){
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let item = json as? [String:Any] {
            loginName = item["LoginName"] as! String
            profifePictureUrl = item["PictureUrl"] as! String
            
            if let url = NSURL(string: UrlPreFix.Root.rawValue + profifePictureUrl) {
                if let data = NSData(contentsOf: url as URL) {
                    if let pic : UIImage =  UIImage(data: data as Data){
                        profilePicture = pic                        
                    }
                }
            }
        }
    }
}

