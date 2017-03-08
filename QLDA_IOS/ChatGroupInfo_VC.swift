//
//  ChatGroupInfo_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/7/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ChatGroupInfo_VC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var btnAddUsers: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgGroup: UIImageView!
    //@IBOutlet weak var lblGroupName: UILabel!
    
    @IBOutlet weak var btnGroupName: UIButton!
    @IBOutlet weak var tblListUser: UITableView!
    var groupID : Int!
    var listUser : [UserContact] = [UserContact]()
    var arrUser : [Int]? = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAddUsers.layer.cornerRadius = 25
        btnAddUsers.setImage(#imageLiteral(resourceName: "ic_addUser"), for: UIControlState.normal)
        btnAddUsers.imageEdgeInsets = UIEdgeInsetsMake(40,40,40,40)
        
        tblListUser.tableFooterView = UIView(frame: .zero)
        getInfoGroup()
        
        initEnvetChatHub()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        return " "
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor(netHex: 0x25A9FE)
        
        let label : UILabel = UILabel()
        label.text = "Thành viên"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.frame = CGRect(x: 8, y: 7, width: view.frame.width, height: 15)
        
        vw.addSubview(label)
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ChatGroupInfo_Cell = tableView.dequeueReusableCell(withIdentifier: "cellGroupInfo") as! ChatGroupInfo_Cell
        var contact : UserContact
        contact = listUser[indexPath.row]
        
        cell.imgContact.maskCircle(anyImage: contact.Picture!)
        cell.lblContactName.text = contact.Name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let alert = UIAlertController(title: "Thông báo", message: "Bạn muốn xóa người dùng \"\(self.listUser[indexPath.row].Name!)\" khỏi nhóm?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Huỷ", style: UIAlertActionStyle.default, handler: nil))
            
            let action = UIAlertAction(title: "Ok", style: .default) { action in
                self.removeUserFromGroup(userID: self.listUser[indexPath.row].ContactID!, groupID: self.groupID!)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listUser.count
    }
    
    
    func loadUsers(){
       // ChatCommon.listContact = [UserContact]()
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetUserIDInGroup/\(groupID!)"
        print(apiUrl)
        ApiService.Get(url: apiUrl, callback: callbackGetUsers, errorCallBack: errorGetUsers)
    }
    
    func callbackGetUsers(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dic = json as? [Int] {
            arrUser = dic
            listUser = ChatCommon.listContact.filter() {
                if let user = ($0 as UserContact) as UserContact! {
                    if dic.contains(user.ContactID!) && user.TypeOfContact == 1{
                        return true
                    }
                    else {
                        return false
                    }
                } else {
                    return false
                }
            }
            
        }
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tblListUser.reloadData()
            }
        }
        
    }
    
    func errorGetUsers(error : Error) {
    }
    

    @IBAction func leaveGroup(_ sender: Any) {       

        let alert = UIAlertController(title: "Thông báo", message: "Bạn thực sự muốn rời nhóm?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: UIAlertActionStyle.default, handler: nil))

        let action = UIAlertAction(title: "Ok", style: .default) { action in
            self.removeUserFromGroup(userID: ChatHub.userID, groupID: self.groupID!)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addUserToGroup(_ sender: UIButton) {
        performSegue(withIdentifier: "addUserToGroup", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addUserToGroup") {
            if let vc = segue.destination as? ChatAddUser_VC{
                vc.exceptUser = arrUser
            }
        }
    }
    func removeUserFromGroup(userID : Int, groupID : Int){
        do {
            try ChatHub.chatHub.invoke("RemoveUserFromGroup", arguments: [userID, groupID])
        } catch {
            print(error)
        }
    }
    
    func getInfoGroup(){
        let group = ChatCommon.listContact.filter(){
            if $0.ContactID == groupID! && $0.TypeOfContact == 2{
                return true
            }
            return false
            }.first
        
        imgGroup.maskCircle(anyImage: (group?.Picture)!)
        //lblGroupName.text = group?.Name
        btnGroupName.setTitle(group?.Name, for: .normal)
    }
    
    // Chat hub
    func initEnvetChatHub(){
        ChatHub.addChatHub(hub: ChatHub.chatHub)
        ChatHub.chatHub.on("changeGroupNameSuccess"){args in
            
        }
        
        ChatHub.chatHub.on("changeGroupName"){args in
            
        }
        
        ChatHub.chatHub.on("removeUserFromGroup"){args in
            let userID = args?[0] as! Int
            let groupID = args?[1] as! Int
            
            if(userID == ChatHub.userID && groupID == self.groupID)
            {
                //khi user hiện tại bị bị xoá khỏi nhóm
            }
            else{
                self.loadUsers()
            }
            
        }
        
        ChatHub.chatHub.on("addUserToGroup"){args in
            //self.loadUsers()
        }
        
        ChatHub.chatHub.on("changeGroupPicture"){args in
            
        }
    }
}

class ChatGroupInfo_Cell: UITableViewCell{
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var btnRight: UIButton!
}
