//
//  Common.swift
//  QLDA_IOS
//
//  Created by datlh on 2/22/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
class ChatCommon{
    
    static var currentChatID : Int?
    static var currentChatType: Int32?
    
    static var listContact : [UserContact] = [UserContact]()
    
    static var checkCloseView : Bool = false
    
    static func getContacts(){
        listContact = [UserContact]()
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_Getcontacts/\(ChatHub.userID)"
        ApiService.Get(url: apiUrl, callback: callbackGetContacts, errorCallBack: errorGetContacts)
    }

    static func callbackGetContacts(data : Data) {
        //let result = String(data: data, encoding: String.Encoding.utf8)
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dic = json as? [[String:Any]] {
            for item in dic{
                let contact = UserContact()
                contact.ContactID =  item["ContactID"] as? Int
                contact.TimeOfLatestMessage = Date(jsonDate: item["TimeOfLatestMessage"] as! String)
                contact.LatestMessage = item["LatestMessage"] as? String
                contact.LatestMessageID = item["LatestMessageID"] as? Int64
                contact.LoginName = item["LoginName"] as? String
                contact.Name = item["Name"] as? String
                contact.NumberOfNewMessage = item["NumberOfNewMessage"] as? Int
                contact.Online = item["Online"] as? Bool
                contact.PictureUrl = item["PictureUrl"] as? String
                contact.ReceiverOfMessage = item["ReceiverOfMessage"] as? Int
                contact.SenderOfMessage = item["SenderOfMessage"] as? Int
                contact.TypeOfContact = item["TypeOfContact"] as? Int32
                contact.TypeOfMessage = item["TypeOfMessage"] as? Int
                
                contact.setPicture()
                listContact.append(contact)
            }
        }
        
    }
    
    static func errorGetContacts(error : Error) {        
    }
    
    
    //function change data chat
    static func updateOnConnect(userID : Int){
        listContact = listContact.filter() {
            let contact = $0 as UserContact
            if contact.ContactID == userID && contact.TypeOfContact == 1{
                contact.Online = true
                
            }
            return true
        }
    }
    
    static func updateOnDisconnect(userID : Int){
        listContact = listContact.filter() {
            let contact = $0 as UserContact
            if contact.ContactID == userID && contact.TypeOfContact == 1{
                contact.Online = false
            }
            return true
        }
    }
    
    static func updateReceiveMessage(args : [Any]?, contactType : Int32){
        
        let sender = args?[0] as? [Any]
        let receiver = args?[1] as? [Any]
        let inbox = args?[2] as? [Any]
        
        let senderID = (sender![0] as? Int)!
        let senderName = (sender![1] as? String)!
        let receiverID = (receiver![0] as? Int)!
        let receiverName = (receiver![1] as? String)!
        let message = (inbox![0] as? String)!
        let messageType = (inbox![1] as? Int)!
        let inboxID = (inbox![2] as? Int64)!
        
        var contactID : Int
        if(contactType == 2){
            contactID = receiverID
        }
        else{
            contactID = senderID
            if senderID == ChatHub.userID{
                contactID = receiverID
            }
        }
        
        let filter = listContact.filter(){
            if $0.ContactID == contactID && $0.TypeOfContact == contactType{
                return true
            }
            return false
        }
        var newContact : UserContact
        if filter.count == 0{
            newContact = UserContact()
            newContact.ContactID = contactID
            newContact.Name = senderName
            newContact.LatestMessage = message
            newContact.TypeOfContact = contactType
            newContact.SenderOfMessage = senderID
            newContact.ReceiverOfMessage = receiverID
            newContact.TypeOfMessage = messageType
            newContact.NumberOfNewMessage = 1
            newContact.LatestMessageID = inboxID
            ChatCommon.listContact.insert(newContact, at: 0)
        }
        else{
            newContact = filter.first!
            
            if(newContact.LatestMessageID == inboxID){
                return
            }
            
            newContact.LatestMessage = message
            newContact.SenderOfMessage = senderID;
            newContact.ReceiverOfMessage = receiverID
            newContact.TypeOfMessage = messageType;
            if senderID == ChatHub.userID{
                  newContact.NumberOfNewMessage = 0
            }else{
                 newContact.NumberOfNewMessage = newContact.NumberOfNewMessage! + 1
            }
           
            newContact.LatestMessageID = inboxID;
            listContact = ChatCommon.listContact.filter() { $0.ContactID != contactID || $0.TypeOfContact != contactType}
            listContact.insert(newContact, at: 0)
        }

    }
    
    static func updateCreateGroup(args : [Any]?){
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
        
        //Kiểm tra đã có tồn tại nhóm này chưa
        let filter = listContact.filter(){
            if $0.ContactID == groupID && $0.TypeOfContact == 2{
                return true
            }
            return false
        }
        if(filter.count == 0){
            let newContact : UserContact = UserContact()
            newContact.ContactID = groupID
            if(host == ChatHub.userID){
                newContact.LatestMessage = "Bạn vừa tạo nhóm"
                newContact.NumberOfNewMessage = 0
            }
            else{
                newContact.LatestMessage = "Bạn vừa được thêm vào nhóm"
                newContact.NumberOfNewMessage = 1
            }
            newContact.LatestMessageID = 0
            newContact.LoginName = ""
            newContact.Name = groupName
            
            newContact.Online = false
            newContact.PictureUrl = pictureUrl
            newContact.ReceiverOfMessage = groupID
            newContact.SenderOfMessage = 0
            newContact.TypeOfContact = 2
            newContact.TypeOfMessage = 0
            newContact.setPicture()
            ChatCommon.listContact.insert(newContact, at: 0)
        }
        
    }
    
    static func updateMakeReadMessage(args : [Any]?){
        let contactID = args?[0] as? Int
        let contactType = args?[1] as? Int32
        let user : UserContact = listContact.filter() {
            let contact = $0 as UserContact
            if contact.ContactID == contactID && contact.TypeOfContact == contactType{
                return true
            }
            return false
            }.first!
        user.NumberOfNewMessage = 0
    }
    
    static func chageGroupName(args : [Any]?){
        let groupID : Int = args?[0] as! Int
        let newName : String = args?[1] as! String
        listContact = listContact.filter(){
            if $0.ContactID == groupID && $0.TypeOfContact == 2 {
                $0.Name = newName
            }
            return true
        }
    }
    
    static func removedFromGroup(args : [Any]?){
        let userID : Int = args?[0] as! Int
        let groupID : Int = args?[1] as! Int
        if userID == ChatHub.userID{
            ChatCommon.listContact = ChatCommon.listContact.filter(){
                if($0.ContactID == groupID && $0.TypeOfContact == 2){
                    return false
                }
                return true
            }
        }      
        
    }
}
