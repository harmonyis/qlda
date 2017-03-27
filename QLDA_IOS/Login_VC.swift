//
//  LoginVC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
class Login_VC: Base {
    
    @IBOutlet weak var lblMesage: UILabel!
    @IBOutlet weak var lblMatKhau: UITextField!
    @IBOutlet weak var lblTenDangNhap: UITextField!
    //var service = ApiService()
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    var szMatKhau : String = ""
    var szTenDangNhap : String = ""

    @IBAction func Login(_ sender: Any) {
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/CheckUser"
        //let szUser=lblName.
        szMatKhau = (lblMatKhau.text)!
        szTenDangNhap = (lblTenDangNhap.text)!
        let params : String = "{\"szUsername\" : \""+szTenDangNhap+"\", \"szPassword\": \""+szMatKhau+"\"}"
        
       ApiService.PostAsyncAc(url: ApiUrl, params: params, callback: loadDataSuccess, errorCallBack: alertAction)
        
    }
    func loadDataSuccess(data : SuccessEntity) {
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        if let dic = json as? [String:Any] {
            let response = data.response as! HTTPURLResponse
            if response.statusCode != 200 {
                serverError(success: data)
                return
            }
            if let idUser = dic["CheckUserResult"] as? String {
                let nIdUser:Int = Int(idUser)!
                if nIdUser > 0 {
                    Config.userID = nIdUser
                    Config.userName = szTenDangNhap
                    Config.passWord = szMatKhau               
                    
                    variableConfig.m_szUserName = self.szTenDangNhap
                    variableConfig.m_szPassWord = self.szMatKhau
                    getContacts()
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.GetCurrentUser()
                        }
                    }
                    
                }
                else {
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.lblMesage.text="Sai tên tài khoản hoặc mật khẩu"
                        }
                    }
                    
                }
            }
        }
    }
     func GetCurrentUser(){
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetUser/\(Config.userID)"
        
    ApiService.GetAsyncAc(url: apiUrl, callback: callbackGetUser, errorCallBack: alertAction)
        // ApiService.Get(url: apiUrl, callback: callbackGetUser, errorCallBack: { (error) in
        
        //   })
    }
     func callbackGetUser(data : SuccessEntity){
        let response = data.response as! HTTPURLResponse
        if response.statusCode != 200 {
            serverError(success: data)
            return
        }
        let json = try? JSONSerialization.jsonObject(with: data.data!, options: [])
        
        if let item = json as? [String:Any] {
            Config.loginName = item["LoginName"] as! String
            Config.profifePictureUrl = item["PictureUrl"] as! String
            
            if let url = NSURL(string: UrlPreFix.Root.rawValue + Config.profifePictureUrl) {
                if let data = NSData(contentsOf: url as URL) {
                    if let pic : UIImage =  UIImage(data: data as Data){
                        Config.profilePicture = pic
                    }
                }
            }
        }
    }
    func AlertError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getContacts(){
        ChatCommon.listContact = [UserContact]()
        
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_Getcontacts/\(Config.userID)"
        print(apiUrl)
        ApiService.Get(url: apiUrl, callback: callbackGetContacts, errorCallBack: errorGetContacts)
    }
    
    func callbackGetContacts(data : Data) {
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
                contact.TypeOfContact = item["TypeOfContact"] as? Int
                contact.TypeOfMessage = item["TypeOfMessage"] as? Int
                
                contact.setPicture()
                ChatCommon.listContact.append(contact)
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                ChatHub.initChatHub()
                ChatHub.initEvent()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DSDA") as! DSDA_VC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func errorGetContacts(error : Error) {
    }
}
