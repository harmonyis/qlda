//
//  ChatHub.swift
//  QLDA_IOS
//
//  Created by datlh on 2/21/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
import SwiftR
import UserNotifications

class ChatHub {
    static var chatHub: Hub!
    static var connection: SignalR!
    static var userID = 59
    static var userName = "demo2"
    static var navicontroller : UINavigationController?
    static func addChatHub(hub : Hub){
        connection.addHub(hub)
        connection.connect()
    }
    
    static func initChatHub(){
        connection = SignalR("http://harmonysoft.vn:8089/QLDA_Services/")
       // connection.useWKWebView = true
        connection.signalRVersion = .v2_2_0
        
        chatHub = Hub("chatHub")
        /*
        chatHub.on("receivePrivateMessage") {
            if let name = args?[0] as? String, let message = args?[1] as? String{
                print("Connection ID\(name + message)")
            }
        }*/
        connection.addHub(chatHub)
        
        // SignalR events
        
        connection.starting = {
            //print("Connection ID")
        }
        
        connection.reconnecting = {
            //print("Connection ID")
        }
        
        connection.connected = {
            //print("Connection ID")
            //DispatchQueue.main.async() { () -> Void in
            ChatHub.conect()
            
            //}
        }
        
        connection.reconnected = {
            //print("Connection ID")
        }
        
        connection.disconnected = {
            //print("Connection ID")
        }
        
        connection.connectionSlow = {
            //print("Connection slow...")
        }
        
        connection.start()
        
    }
    static func conect(){
        if let hub = chatHub {
            
            do {
                try hub.invoke("Connect", arguments: [userID, userName])
            } catch {
                //print(error)
            }
        }
    }
    
    static func initEvent(){
        /*
        chatHub.on("onConnected"){args in
            let userID = args?[0] as? Int
            ChatCommon.listContact.filter() {
                let contact = $0 as UserContact
                if contact.ContactID == userID && contact.TypeOfContact == 1{
                    return true
                }
                return false
            }.first?.Online = true
            
        }
        
        chatHub.on("onDisconnected"){args in
            let userID = args?[0] as? Int
            ChatCommon.listContact.filter() {
                let contact = $0 as UserContact
                if contact.ContactID == userID && contact.TypeOfContact == 1{
                    return true
                }
                return false
                }.first?.Online = false
            
        }*/
        
        chatHub.on("receivePrivateMessage") {args in
            let sender = args?[0] as? [Any]
            let receiver = args?[1] as? [Any]
            let inbox = args?[2] as? [Any]
            
            let senderID = (sender![0] as? Int)!
            let senderName = (sender![1] as? String)!
            let receiverID = (receiver![0] as? Int)!
            let receiverName = (receiver![1] as? String)!
            let msg = (inbox![0] as? String)!
            let msgType = (inbox![1] as? Int)!
            let inboxID = (inbox![2] as? Int64)!
            

            
            if ChatCommon.currentChatID == senderID && ChatHub.userID == receiverID {
                return
            }
            if senderID == ChatHub.userID{
                return
            }
            let identifier = "\(senderID + 1000)"
            
            var body = ""
            switch msgType{
            case 1: body = "Bạn đã nhận một hình ảnh"
            case 2: body = "Bạn đã nhận một tệp tin"
            default: body = msg
            }
            
            UserNotificationManager.share.addNotificationWithTimeIntervalTrigger(identifier: identifier, title: senderName, body: body)
        
        }
        
        chatHub.on("receiveGroupMessage") {args in
            
            let sender = args?[0] as? [Any]
            let receiver = args?[1] as? [Any]
            let inbox = args?[2] as? [Any]
            
            let senderID = (sender![0] as? Int)!
            let senderName = (sender![1] as? String)!
            let receiverID = (receiver![0] as? Int)!
            let receiverName = (receiver![1] as? String)!
            let msg = (inbox![0] as? String)!
            let msgType = (inbox![1] as? Int)!
            let inboxID = (inbox![2] as? Int64)!
            
            /*
            let list = ChatCommon.listContact.filter(){
                if $0.NumberOfNewMessage! > 0 {
                    return true
                } else {
                    return false
                }
            }*/
            
            
            if ChatCommon.currentChatID == receiverID {
                return
            }
            if senderID == ChatHub.userID{
                return
            }
            var body = ""
            switch msgType{
            case 1: body = "Bạn đã nhận một hình ảnh"
            case 2: body = "Bạn đã nhận một tệp tin"
            default: body = "\(senderName) : \(msg)"
            }
            let identifier = "\(-receiverID - 1000)"
            UserNotificationManager.share.addNotificationWithTimeIntervalTrigger(identifier: identifier, title: receiverName, body: body)
        }
        
        chatHub.on("receiveChatGroup") {args in
            var groupID : Int = 0
            var host : Int = 0
            var groupName : String = ""
            var pictureUrl : String = ""
            if let temp = args?[0] as? Int{
                 groupID = temp
            }
            if let temp = args?[1] as? String{
                groupName = temp
            }
            
            if let temp = args?[2] as? Int{
                host = temp
            }
            if let temp = args?[3] as? String{
                pictureUrl = temp
            }
            
            let identifier = "\(-groupID - 1000)"
            if host != ChatHub.userID{
                UserNotificationManager.share.addNotificationWithTimeIntervalTrigger(identifier: identifier, title: groupName, body: "Bạn vừa được thêm vào nhóm")
            }
           
            
        }

    }
    
    static func pushView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Chat") as! Chat_VC
        navicontroller?.pushViewController(controller, animated: true)
    }
    
    
    static func notification(){
        let content = UNMutableNotificationContent()
        content.title = "Thông báo"
        content.subtitle = "subsite"
        content.body = "Đây là thông báo"
        content.badge = 2
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
