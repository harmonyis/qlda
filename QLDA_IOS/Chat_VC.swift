//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import SwiftR
import FileBrowser

class Chat_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    fileprivate let cellId = "cellId"
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var txtMessage: UITextField!
    var messages: [ChatMessage] = [ChatMessage]()
    var contactID : Int!
    var contactType : Int32!
    var contactName : String!
    var isRead : Bool!
    var lastInboxID : Int64!
    
    var isClose : Bool! = false
    
    var bottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if(contactType == 2){
            addRightBar()
        }
        self.title = contactName
        self.initEnvetChatHub()
        //makeReadMsg()
        collectionView.backgroundColor = UIColor.white
        collectionView.register(Chat_Cell.self, forCellWithReuseIdentifier: cellId)
        getMessage()
        
        
        //toggle bàn phím và hiện thị ô chat
        bottomConstraint = NSLayoutConstraint(item: viewBottom, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            //print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            

            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    self.scrollToBottom(animate: true)
                    //let indexPath = IndexPath(item: self.txtMessage!.count - 1, section: 0)
                    //self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
                
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        
        makeReadMsg()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async() { () -> Void in
            self.collectionView.reloadData()
           // self.scrollToBottom(animate: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ChatCommon.currentChatID = contactID
        ChatCommon.currentChatType = contactType
        
        if(ChatCommon.checkCloseView){
            self.navigationController?.popViewController(animated: true)
            ChatCommon.checkCloseView = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ChatCommon.currentChatID = nil
        ChatCommon.currentChatType = nil
        //self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ChatCommon.currentChatID = nil
        ChatCommon.currentChatType = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! Chat_Cell
        let msg = messages[indexPath.item]
        
        if let messageText = msg.Message {
            
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            switch msg.MessageType!{
            case 0 :
                cell.messageImageView.isHidden = true
                cell.messageTextView.isHidden = false
                cell.messageTextView.text = msg.Message
                let w : Int = Int(view.frame.width * 6 / 10)
                let size = CGSize(width: w, height: 1000)
                let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
                
                cell.contactNameLabel.isHidden = true
                cell.contactNameLabel.text = ""
                if (msg.IsMe)!{
                    cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 8 - 8 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                    
                    cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 8, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                    
                    cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                    //cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                    //cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                    cell.messageTextView.textColor = UIColor.white
                    
                } else {
                    
                    if msg.ContactType == 1{
                        
                        cell.messageTextView.frame = CGRect(x: 8 + 4, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                        
                        cell.textBubbleView.frame = CGRect(x: 4, y: 0, width: estimatedFrame.width + 8 + 8 + 16, height: estimatedFrame.height + 20)
                    }
                    else{
                        cell.contactNameLabel.isHidden = false
                        cell.contactNameLabel.text = msg.SenderName
                        
                        let estimatedFrameContactName = NSString(string: msg.SenderName!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10)], context: nil)
                        
                        cell.contactNameLabel.frame = CGRect(x: 4, y: 0, width: estimatedFrameContactName.width + 16, height: 10)
                        
                        cell.messageTextView.frame = CGRect(x: 8 + 4, y: 0 + 10, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                        
                        cell.textBubbleView.frame = CGRect(x: 4, y: 0 + 10, width: estimatedFrame.width + 8 + 8 + 16, height: estimatedFrame.height + 20)
                    }
                    
                    cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                    //cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                    //cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                    cell.messageTextView.textColor = UIColor.black
                }
            case 1 :
                cell.messageImageView.isHidden = false
                cell.messageTextView.isHidden = true

                
                //cell.messageImageView.downloadImage(url: UrlPreFix.Root.rawValue + messageText)
                if(msg.ImageMsg != nil){
                    cell.messageImageView.image = msg.ImageMsg
                    var h = msg.ImageMsg?.size.height
                    var w = msg.ImageMsg?.size.width
                    let wView = view.frame.width * 6 / 10
                    let wOld = w
                    if(w! > wView){
                        w = wView
                        h = h! * w! / wOld!
                    }
                    let size = CGSize(width: wView, height: 1000)
                    if(msg.IsMe)!{
                        cell.messageImageView.frame = CGRect(x: view.frame.width - w! - 16 - 16 - 6, y: 0 + 12, width: w! + 16, height: h! + 20)
                        
                        cell.textBubbleView.frame = CGRect(x: view.frame.width - w! - 16 - 16 - 8 - 10, y: 0, width: w! + 8 + 8 + 16 + 8, height: h! + 20 + 24)
                        cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                    }
                    else{
                        if msg.ContactType == 1{
                            cell.messageImageView.frame = CGRect(x: 8 + 4 + 4, y: 0 + 12, width: w! + 16, height: h! + 20)
                            
                            cell.textBubbleView.frame = CGRect(x: 4, y: 0, width: w! + 8 + 8 + 16 + 8, height: h! + 20 + 24)
                        }
                        else{
                            cell.contactNameLabel.isHidden = false
                            cell.contactNameLabel.text = msg.SenderName
                            
                            let estimatedFrameContactName = NSString(string: msg.SenderName!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10)], context: nil)
                            
                            cell.contactNameLabel.frame = CGRect(x: 4, y: 0, width: estimatedFrameContactName.width + 16, height: 10)
                            cell.messageImageView.frame = CGRect(x: 8 + 4 + 4, y: 0 + 12 + 10, width: w! + 16, height: h! + 20)
                            
                            cell.textBubbleView.frame = CGRect(x: 4, y: 0 + 10, width: w! + 8 + 8 + 16 + 8, height: h! + 20 + 24)
                        }
                        cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                    }
                }
       
            //case 2 :
            default:
                print("none")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let msg = messages[indexPath.item]
        
        let w : Int = Int(view.frame.width * 6 / 10)
        if let messageText = msg.Message {
            switch msg.MessageType!{
            case 0 :
                let size = CGSize(width: w, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
                
                if msg.IsMe!{
                    return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
                }
                else{
                    if msg.ContactType == 1{
                        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
                    }
                    else{
                        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20 + 10)
                    }
                }
            case 1 :
                if(msg.ImageMsg != nil){
                    var h = msg.ImageMsg?.size.height
                    var w = msg.ImageMsg?.size.width
                    let wView = view.frame.width * 6 / 10
                    let wOld = w
                    if(w! > wView){
                        w = wView
                        h = h! * w! / wOld!
                    }

                    if(msg.IsMe)!{
                        return CGSize(width: view.frame.width, height: h! + 20 + 24)
                    }
                    else{
                        if msg.ContactType == 1{
                            return CGSize(width: view.frame.width, height: h! + 20 + 24)
                        }
                        else{
                            return CGSize(width: view.frame.width, height: h! + 20 + 10 + 24)
                        }
                    }
                }
                
            default :
                print("none")
            }
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
    func getMessage(){
        print("data: ", contactID, contactName, contactType)
        if contactType == 1 {
            let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetPrivateMessage?senderID=\(ChatHub.userID)&receiverID=\(String(contactID))"
            ApiService.Get(url: apiUrl, callback: callbackGetMsg, errorCallBack: errorGetMsg)
        }
        else{
            let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetGroupMessage/\(String(contactID))"
            ApiService.Get(url: apiUrl, callback: callbackGetMsg, errorCallBack: errorGetMsg)
        }
    }
    func callbackGetMsg(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [[String:Any]] {
            for item in dic{
                let msg = ChatMessage()
                msg.ID =  item["InboxID"] as? Int64
                msg.Message = item["Message"] as? String
                msg.MessageType = item["TypeMessage"] as? Int
                msg.ContactType = item["Type"] as? Int
                msg.SenderID = item["SenderID"] as? Int
                if msg.SenderID == ChatHub.userID {
                    msg.IsMe = true
                    msg.SenderName = ChatHub.userName
                }
                else{
                    msg.IsMe = false
                    msg.SenderName = ChatCommon.listContact.filter(){
                        if($0.TypeOfContact == 1 && msg.SenderID == $0.ContactID){
                            return true
                        }else{
                            return false
                        }
                        }.first?.Name
                }
                msg.Created = Date(jsonDate: item["Created"] as! String)
                msg.setImageMsg()
                self.messages.append(msg)

            }
        }
        DispatchQueue.main.async() { () -> Void in
            self.collectionView.reloadData()
            self.scrollToBottom(animate: false)
        }
    }
    
    func errorGetMsg(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendMessage(){
        do {
            var funcName = "SendPrivateMessage"
            if(contactType == 2){
                funcName = "SendGroupMessage"
            }
            //print(ChatHub.userID, ChatHub.userName, contactID, contactName, txtMessage.text!)
            try ChatHub.chatHub.invoke(funcName, arguments: [ChatHub.userID, ChatHub.userName, contactID, contactName, txtMessage.text!])
            txtMessage.text = ""
        } catch {
            print(error)
        }
    }
    
    @IBAction func btnSendTouchUpInside(_ sender: UIButton) {
        sendMessage()
    }
    
    @IBAction func txtMessageEditingChanged(_ sender: UITextField) {
        makeReadMsg()
    }

    @IBAction func txtMessageTouchDown(_ sender: UITextField) {
        makeReadMsg()
    }
    func initEnvetChatHub(){
        ChatHub.addChatHub(hub: ChatHub.chatHub)
        if contactType == 1{
            ChatHub.chatHub.on("receivePrivateMessage") { args in
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
                
                if ((receiverID == ChatHub.userID && senderID == self.contactID) || (receiverID == self.contactID && senderID == ChatHub.userID )){
                    
                    self.receiveMessage(senderID: senderID, senderName: senderName, receiverID: receiverID, receiverName: receiverName, message: msg, messageType: msgType, inboxID: inboxID, contactType: 1)
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.scrollToBottom(animate: true)
                        }
                    }
                    self.isRead = false
                }
            }
        }
        else{
            ChatHub.chatHub.on("receiveGroupMessage") {args in
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
                
                if(receiverID == self.contactID){
                    self.receiveMessage(senderID: senderID, senderName: senderName, receiverID: receiverID, receiverName: receiverName, message: msg, messageType: msgType, inboxID: inboxID, contactType: 2)
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.scrollToBottom(animate: true)
                        }
                    }
                    self.isRead = false
                }                
            }
        }
        
        ChatHub.chatHub.on("changeGroupNameSuccess"){args in
            let newName : String = args?[1] as! String
            ChatCommon.chageGroupName(args: args)
            self.title = newName
        }
        
        ChatHub.chatHub.on("changeGroupName"){args in
            let newName : String = args?[1] as! String
            ChatCommon.chageGroupName(args: args)
            self.title = newName
        }
    }
    
    func receiveMessage(senderID : Int, senderName : String, receiverID : Int, receiverName : String, message : String, messageType : Int, inboxID : Int64, contactType : Int){
        let newChat : ChatMessage = ChatMessage()
        newChat.ContactType = contactType
        newChat.ID = inboxID
        if ChatHub.userID == senderID{
            newChat.IsMe = true
        }
        else {
            newChat.IsMe = false
        }
        newChat.Message = message
        newChat.MessageType = messageType
        newChat.SenderID = senderID
        newChat.SenderName = senderName
        newChat.setImageMsg()
        messages.append(newChat)
    }
    
    
    func scrollToBottom(animate : Bool){
        if(self.messages.count > 0){
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animate)
            //self.tblConversation.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func makeReadMsg(){
        if !self.isRead{
            if self.lastInboxID != nil{
                do {
                    print(ChatHub.userID, self.contactID!, self.contactType!, self.lastInboxID!)
                    try ChatHub.chatHub.invoke("MakeReadMessage", arguments: [ChatHub.userID, self.contactID!, self.contactType!, self.lastInboxID!])
                } catch {
                    print(error)
                }
            }
            self.isRead = true;
        }
        
    }
    
    func addRightBar(){
        let btnInfoMenu = UIButton(type: UIButtonType.system)
        btnInfoMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnInfoMenu.addTarget(self, action: #selector(Chat_VC.onInfoBarPressed(_:)), for: UIControlEvents.touchUpInside)
        btnInfoMenu.setImage(UIImage(named: "HomeIcon"), for: UIControlState())
        btnInfoMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let custoInfoBarItem = UIBarButtonItem(customView: btnInfoMenu)
        self.navigationItem.rightBarButtonItem = custoInfoBarItem
    }
    
    func onInfoBarPressed(_ sender : UIButton){
        Config.SelectMenuIndex = -1
        let vc = storyboard?.instantiateViewController(withIdentifier: "GroupInfo") as! ChatGroupInfo_VC
        vc.groupID = contactID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let newImg = resizeImage(image: image, newWidth: 540)
            //imageView.image = image
            let data = UIImageJPEGRepresentation(newImg, 1.0)
            let array = [UInt8](data!)
            
            if contactType == 1{
                let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_SendPrivateImage"
                print(String(ChatHub.userID), ChatHub.userName, String(contactID), contactName!)
                let params : String = "{\"senderID\" : \"\(String(ChatHub.userID))\", \"senderName\": \"\(ChatHub.userName)\",\"receiverID\" : \"\(String(contactID))\", \"receiverName\": \"\(contactName!)\", \"imageData\":\(array)}"
            
                ApiService.Post(url: apiUrl, params: params, callback: callbackSendImage, errorCallBack: { (error) in
                    print("error")
                    print(error.localizedDescription)
                })
            }
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func callbackSendImage(data : Data) {
        print("success")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
    }
    
    @IBAction func btnOpenImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnOpenFile(_ sender: Any) {
        let fileBrowser = FileBrowser()
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
       
            print(file.displayName)
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
}

class Chat_Cell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let contactNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.text = ""
        lbl.backgroundColor = UIColor.clear
        return lbl
    }()
    
    let messageImageView: UIImageView = {
        let view = UIImageView()
        view.image = ChatCommon.downLoadImage("http://harmonysoft.vn:8089/QLDA_Services/ImageMessage/12577.jpg")
        //view.backgroundColor = UIColor.clear
        //view.backgroundColor = UIColor.black
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(contactNameLabel)
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(messageImageView)
    }
    
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}
