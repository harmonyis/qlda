//
//  ChatAddUser_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ChatAddUser_VC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var btnAddBar: UIBarButtonItem!
    @IBOutlet weak var tblListUser: UITableView!
    
    var exceptUser : [Int]? = []
    var listContact : [UserContact] = [UserContact]()
    var listUserChecked : [Int] = []
    var groupID : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddBar.isEnabled = false
        //self.title = "Thêm người dùng vào nhóm"
        tblListUser.tableFooterView = UIView(frame: .zero)
        
        listContact = ChatCommon.listContact.filter(){
            if($0.ContactID == groupID && $0.TypeOfContact == 2){
                self.title = $0.Name
            }
            if $0.TypeOfContact! == 1 && !(exceptUser?.contains($0.ContactID!))!{
                return true
            }
            else{
                return false
            }
        }
        tblListUser.reloadData()
    }
    
    @IBAction func addUser(_ sender: Any) {
        //print(listUserChecked.count)
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_AddUserToGroup"
        
        let params : String = "{\"lstUser\" : \""+getListUser()+"\", \"groupID\": \""+String(groupID)+"\"}"
        ApiService.Post(url: apiUrl, params: params, callback: callbackAddUser, errorCallBack: errorAddUser)
        
    }
    
    func callbackAddUser(data : Data) {
        
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        
    }
    
    func getListUser() -> String{
        var userIDs : String = ""
        var i : Int = 0
        for ctID in listUserChecked{
            userIDs += String(ctID)
            if(i < listUserChecked.count - 1){
                userIDs += ","
            }
            i += 1
        }
        return userIDs
    }
    
    
    func errorAddUser(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    var searchActive : Bool = false
    var filtered = [UserContact]()
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tblListUser.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tblListUser.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tblListUser.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        self.tblListUser.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = listContact.filter() {
            var name = ($0 as UserContact).Name! as String
            var key : String = searchText
            let s1 : String = name.toUnsign()
            let s2 : String = key.toUnsign()
            if s1.contains(s2) {
                return true
            }
            else{
                return false
            }
           // return name.toUnsign().contains(key.toUnsign())
        }
        if(searchText.characters.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tblListUser.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ChatAddUser_Cell = tableView.dequeueReusableCell(withIdentifier: "cellContact") as! ChatAddUser_Cell
        var contact : UserContact
        if(searchActive){
            contact = filtered[indexPath.row]
        }
        else{
            contact = listContact[indexPath.row]
        }
        //cell.btnCheck.layer.cornerRadius = 12
        if(listUserChecked.contains(contact.ContactID!)){
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_check"), for: UIControlState.normal)
            cell.btnCheck.tintColor = UIColor.init(netHex: 0xFDB813)
        }
        else{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: UIControlState.normal)
            cell.btnCheck.tintColor = UIColor.darkGray
        }
        cell.btnCheck.imageEdgeInsets = UIEdgeInsetsMake(30,30,30,30)
        
        cell.imgContact.maskCircle(anyImage: contact.Picture!)
        cell.lblContactName.text = contact.Name
        cell.btnCheck.tag = contact.ContactID!
        
        //cell.target(forAction: #selector(ChatCreateGroup_VC.selectUser(sender:)), withSender: self)
        cell.btnCheck.addTarget(self, action: #selector(ChatAddUser_VC.selectUser(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
    
    func selectUser(sender: UIButton!)
    {
        let value = sender.tag;
        
        if let index : Int = listUserChecked.index(of: value){
            listUserChecked.remove(at: index)
        }
        else{
            listUserChecked.append(value)
        }
        self.tblListUser.reloadData()
        if listUserChecked.count == 0{
            btnAddBar.isEnabled = false
        }
        else{
            btnAddBar.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


class ChatAddUser_Cell: UITableViewCell{
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
}
