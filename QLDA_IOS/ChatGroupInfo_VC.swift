//
//  ChatGroupInfo_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/7/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ChatGroupInfo_VC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var btnAddUsers: UIButton!
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var btnGroupPicture: UIButton!
    //@IBOutlet weak var imgGroup: UIImageView!

    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var btnGroupName: UIButton!
    @IBOutlet weak var tblListUser: UITableView!
    var groupID : Int!
    var listUser : [UserContact] = [UserContact]()
    var arrUser : [Int]? = []
   
    var imageTemp : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Thông tin nhóm"
        //self.navigationItem.backBarButtonItem?.title = ""
        //self.navigationController?.navigationItem.backBarButtonItem?.title=""
        
        btnAddUsers.layer.cornerRadius = 25
        btnAddUsers.setImage(#imageLiteral(resourceName: "ic_addUser"), for: UIControlState.normal)
        btnAddUsers.imageEdgeInsets = UIEdgeInsetsMake(40,40,40,40)
        
        tblListUser.tableFooterView = UIView(frame: .zero)
        getInfoGroup()
        
        initEnvetChatHub()
        
        imagePicker.delegate = self
        
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGroupPictureTouchUp(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageTemp = resizeImage(image: image, newWidth: 540)
            
            //imageView.image = image
            let data = UIImageJPEGRepresentation(imageTemp!, 1.0)
            let array = [UInt8](data!)            
            
            let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_ChangeGroupPicture"
            
            let params : String = "{\"groupID\" : \"\(String(groupID!))\", \"userID\": \"\(String(Config.userID))\", \"imageData\":\(array)}"
            //let params : String = "{\"groupID\" : \"\(String(groupID!))\", \"userID\": \"\(String(ChatHub.userID))\"}"
            ApiService.Post(url: apiUrl, params: params, callback: callbackChagePictureGroup, errorCallBack: { (error) in
                print("error")
                print(error.localizedDescription)
            })

        } else{
            //print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
    }
    
    func callbackChagePictureGroup(data : Data) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.btnGroupPicture.setBackgroundImage(self.imageTemp, for: .normal)
            }
        }
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect( x: 0, y : 0,width: newWidth,height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
            
            let action = UIAlertAction(title: "OK", style: .destructive) { action in
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
    
    @IBAction func chageGroupName(_ sender: UIButton) {
        performSegue(withIdentifier: "changeGroupNameModal", sender: self)
    }

    @IBAction func leaveGroup(_ sender: Any) {       

        let alert = UIAlertController(title: "Thông báo", message: "Bạn thực sự muốn rời nhóm?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: UIAlertActionStyle.default, handler: nil))

        let action = UIAlertAction(title: "Ok", style: .destructive) { action in
            self.removeUserFromGroup(userID: Config.userID, groupID: self.groupID!)
            ChatCommon.checkCloseView = true
            self.navigationController?.popViewController(animated: true)
            /*
            guard let parent = self.navigationController?.presentingViewController else{
                return
            }
            //presented by parent view controller 1
            if parent.isKind(of: Chat_VC.self){
                 let vc = parent as! Chat_VC
                vc.isClose = true
                self.navigationController?.popViewController(animated: true)
                // do something
            }else{
                //presented by parent view controller 2
            }
            */
            
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
                vc.groupID = groupID
            }
        }
        if(segue.identifier == "changeGroupNameModal"){
            if let vc = segue.destination as? ChatChangeGroupName_Modal{
                vc.groupID = self.groupID
                vc.groupName = self.btnGroupName.titleLabel?.text
                segue.destination.modalPresentationStyle = .overCurrentContext
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
        
        //imgGroup.maskCircle(anyImage: (group?.Picture)!)
        btnGroupPicture.setBackgroundImage(group?.Picture, for: .normal)
        //lblGroupName.text = group?.Name
        btnGroupName.setTitle(group?.Name, for: .normal)
    }
    
    // Chat hub
    func initEnvetChatHub(){
        ChatHub.addChatHub(hub: ChatHub.chatHub)
        ChatHub.chatHub.on("changeGroupNameSuccess"){args in
            let newName : String = args?[1] as! String
            self.btnGroupName.setTitle(newName, for: .normal)
        }
        
        ChatHub.chatHub.on("changeGroupName"){args in
            let newName : String = args?[1] as! String
            self.btnGroupName.setTitle(newName, for: .normal)
        }
        
        ChatHub.chatHub.on("removeUserFromGroup"){args in
            let userID = args?[0] as! Int
            let groupID = args?[1] as! Int
            
            if(userID == Config.userID && groupID == self.groupID)
            {
                //khi user hiện tại bị bị xoá khỏi nhóm
            }
            else{
                ChatCommon.removedFromGroup(args: args)
                self.loadUsers()
            }
            
        }
        
        ChatHub.chatHub.on("addUserToGroup"){args in
            self.loadUsers()
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
