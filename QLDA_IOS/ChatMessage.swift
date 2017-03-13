//
//  ChatMessage.swift
//  QLDA_IOS
//
//  Created by datlh on 2/25/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation

class ChatMessage{
    
    init() {
        
        ID = 0
        IsMe = true
        Message = ""
        SenderID = 0
        Created = Date()
        SenderName = ""
        MessageType = 0
        ContactType = 1
        ImageMsg = nil
    }

    var ID : Int64?
    var IsMe : Bool?
    var Message : String?
    var SenderID : Int?
    var Created : Date?
    var SenderName : String?
    var MessageType : Int?
    var ContactType : Int?
    var ImageMsg : UIImage?
    
    deinit{        
        print("Thông báo deinit")
    }
    
    func setImageMsg(){
        if(MessageType == 1){
            if let url = NSURL(string: UrlPreFix.Root.rawValue + self.Message!) {
                if let data = NSData(contentsOf: url as URL) {
                    if let pic : UIImage =  UIImage(data: data as Data){
                        
                        self.ImageMsg = pic
                        
                    }
                }
            }            
        }
    }
}

