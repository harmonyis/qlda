//
//  ChatAddUser_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ChatAddUser_VC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tblListUser: UITableView!
    
    var exceptUser : [Int]? = []
    var listContact : [UserContact] = [UserContact]()
    var listUserChecked : [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thêm người dùng vào nhóm"
        tblListUser.tableFooterView = UIView(frame: .zero)
        
        listContact = ChatCommon.listContact.filter(){
            if $0.TypeOfContact! == 1 && !(exceptUser?.contains($0.ContactID!))!{
                return true
            }
            else{
                return false
            }
        }
        tblListUser.reloadData()
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
        self.tblListUser.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ChatAddUser_Cell = tableView.dequeueReusableCell(withIdentifier: "cellContact") as! ChatAddUser_Cell
        var contact : UserContact
        contact = listContact[indexPath.row]
        //cell.btnCheck.layer.cornerRadius = 12
        if(listUserChecked.contains(contact.ContactID!)){
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_check"), for: UIControlState.normal)
            cell.btnCheck.tintColor = UIColor.green
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
