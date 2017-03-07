//
//  ChatGroupInfo_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/7/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ChatGroupInfo_VC: UIViewController {
    
    var groupID : Int!
    var listUser : [UserContact] = [UserContact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUsers(){
        ChatCommon.listContact = [UserContact]()
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetUserIDInGroup/\(groupID!)"
        print(apiUrl)
        ApiService.Get(url: apiUrl, callback: callbackGetUsers, errorCallBack: errorGetUsers)
    }
    
    func callbackGetUsers(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dic = json as? [Int] {
            for item in dic{

                let user = ChatCommon.listContact.filter() {
                    if let user = ($0 as UserContact) as UserContact! {
                        return user.TypeOfContact == 1 && user.ContactID == item
                    } else {
                        return false
                    }
                }.first
                listUser.append(user!)
                
            }
        }
        
        print("\(listUser.count)")
    }
    
    func errorGetUsers(error : Error) {
    }
}
