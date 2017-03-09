//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import SwiftR
import UserNotifications

class ChatMain_VC: Base_VC , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var btnCreateGroup: UIButton!
    
    @IBOutlet weak var aivLoad: UIActivityIndicatorView!
    @IBOutlet weak var tblListContact: UITableView!
    @IBOutlet weak var txtText: UITextField!
    //var service = ApiService()
    
    @IBOutlet weak var searchContact: UISearchBar!
    var arrayMenu = [Dictionary<String,String>]()
    var listContact = [UserContact]()
    
    var passContactID:Int!
    var passContactType:Int32!
    var passContactName:String!
    var passIsRead : Bool!
    var passLastInboxID : Int64!
    
    //var chatHub: Hub = Hub("chatHub")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ChatHub.connection.connect()
        //ChatHub.addChatHub(hub: ChatHub.chatHub)
        
        self.initEnvetChatHub()
        
        btnCreateGroup.layer.cornerRadius = 25
        btnCreateGroup.setImage(#imageLiteral(resourceName: "ic_createGroup"), for: UIControlState.normal)
        btnCreateGroup.imageEdgeInsets = UIEdgeInsetsMake(40,40,40,40)
        
        aivLoad.startAnimating()
        tblListContact.isHidden = true
        tblListContact.tableFooterView = UIView(frame: .zero)
        
        self.listContact = ChatCommon.listContact
        self.aivLoad.isHidden = true
        self.tblListContact.isHidden = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    
    @IBAction func goToChat(_ sender: Any) {
        //let vc = storyboard?.instantiateViewController(withIdentifier: "Chat") as! Chat_VC
        //self.navigationController?.pushViewController(vc, animated: true)
        //vc.passData = "122"
    }
    
    var searchActive : Bool = false
    var filtered = [UserContact]()
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tblListContact.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tblListContact.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tblListContact.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        self.tblListContact.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*filtered = data.filter({ (text) -> Bool in
         let tmp: NSString = text
         let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
         return range.location != NSNotFound
         })*/
        filtered = listContact.filter() {         
            if let name = ($0 as UserContact).Name?.toUnsign() as String! {
                var key : String = searchText
                return name.contains(key.toUnsign())
            } else {
                return false
            }
        }
        
        if(searchText.characters.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
 
        self.tblListContact.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ChatMain_Cell = tableView.dequeueReusableCell(withIdentifier: "cellContact") as! ChatMain_Cell
        //cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        var contact : UserContact
        if(searchActive){
            contact = filtered[indexPath.row]
        }
        else{
            contact = listContact[indexPath.row]
        }

        cell.lblBadge.layer.borderColor = UIColor.clear.cgColor
        cell.lblBadge.layer.borderWidth = 2
        cell.lblBadge.layer.cornerRadius = cell.lblBadge.bounds.size.height / 2
        cell.lblBadge.layer.masksToBounds = true
        
        if contact.NumberOfNewMessage! > 0{
            cell.lblBadge.isHidden = false
            cell.lblBadge.text = "\(contact.NumberOfNewMessage!)"
        }
        else{
            cell.lblBadge.isHidden = true
            cell.lblBadge.text = ""
        }
        
       
        cell.imgContact.maskCircle(anyImage: contact.Picture!)
        cell.lblContactName.text = contact.Name
        cell.lblLastMessage.text = contact.LatestMessage
        if(!contact.Online!){
            cell.imgOnline.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact : UserContact = listContact[indexPath.row]
        
        passContactID = contact.ContactID
        passContactType = contact.TypeOfContact
        passContactName = contact.Name
        passLastInboxID = contact.LatestMessageID
        if contact.NumberOfNewMessage! > 0{
            passIsRead = false
        }
        else{
            passIsRead = true
        }
        //makeReadMsg(contactID: contact.ContactID!, contactType: contact.TypeOfContact!, lastInboxID: contact.LatestMessageID!)
        performSegue(withIdentifier: "GoToChat", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return listContact.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToChat") {
            if let chatVC = segue.destination as? Chat_VC{
                chatVC.contactID = passContactID
                chatVC.contactType = passContactType
                chatVC.contactName = passContactName
                chatVC.isRead = passIsRead
                chatVC.lastInboxID = passLastInboxID
            }
        }
    }
    
    
    // Chat hub
    func initEnvetChatHub(){
        
        
        ChatHub.chatHub.on("onConnected") {args in
            let userID = args?[0] as? Int
            ChatCommon.updateOnConnect(userID: userID!)
            self.reloadData()
        }
        
        ChatHub.chatHub.on("onDisconnected") {args in
            let userID = args?[0] as? Int
            ChatCommon.updateOnDisconnect(userID: userID!)
            self.reloadData()
        }
        ChatHub.chatHub.on("receivePrivateMessage") {args in
            ChatCommon.updateReceiveMessage(args: args, contactType: 1)
            self.reloadData()
        }
        ChatHub.chatHub.on("receiveGroupMessage") {args in
            ChatCommon.updateReceiveMessage(args: args, contactType: 2)
            self.reloadData()
        }
        ChatHub.chatHub.on("receiveChatGroup") {args in
           
            ChatCommon.updateCreateGroup(args: args)
            self.reloadData()
        }
        
        ChatHub.chatHub.on("makeReadMessage"){args in
            ChatCommon.updateMakeReadMessage(args: args)
            self.reloadData()
        }
        ChatHub.chatHub.on("removeUserFromGroup"){args in
            ChatCommon.removedFromGroup(args: args)
            self.reloadData()
            
        }
    }
    
    func reloadData(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.listContact = ChatCommon.listContact
                self.tblListContact.reloadData()
            }
        }
    }
    
    func makeReadMsg(contactID : Int, contactType : Int, lastInboxID: Int64){
        if let hub = ChatHub.chatHub {
            do {
                print(ChatHub.userID, contactID, contactType, lastInboxID)
                try hub.invoke("MakeReadMessage", arguments: [ChatHub.userID, contactID, contactType, lastInboxID])
            } catch {
                print(error)
            }
        }
        
    }
}

class ChatMain_Cell: UITableViewCell{
    
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var viewImageContact: UIView!
    @IBOutlet weak var imgContact : UIImageView!
    @IBOutlet weak var lblContactName : UILabel!
    @IBOutlet weak var lblLastMessage : UILabel!
    @IBOutlet weak var imgOnline : UIImageView!
}

