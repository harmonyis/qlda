
import UIKit

class Base_VC: Base {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Config.bCheckRead == false){
            getTotalNofiticationNotRead()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                ChatHub.addChatHub(hub: ChatHub.chatHub)
                self.initEnvent()
            }
        }
        
        // Do any additional setup after loading the view.
        self.addLeftBarButton()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.addRightBarButton()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLeftBarButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //btnShowMenu.target = self.revealViewController()
        //btnShowMenu.action = Selector("revealToggle:")
        //btnShowMenu.addTarget(self, action: Selector("revealToggle:")), for: UIControlEvents.touchUpInside)
        
        btnShowMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func addRightBarButton(){
        let btnNotiMenu = UIButton(type: UIButtonType.custom)
        btnNotiMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnNotiMenu.addTarget(self, action: #selector(Base_VC.onNotiBarPressesd(_:)), for: UIControlEvents.touchUpInside)
        btnNotiMenu.setImage(#imageLiteral(resourceName: "ic_noti"), for: UIControlState())
        btnNotiMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let frameNoti = CGRect(x: 18, y: -4, width: 15, height: 15)
        createBadge(parent: btnNotiMenu, tag: 200, number: 0, frame: frameNoti)
        let customNotiBarItem = UIBarButtonItem(customView: btnNotiMenu)
        
        let btnChatMenu = UIButton(type: UIButtonType.custom)
        btnChatMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnChatMenu.addTarget(self, action: #selector(Base_VC.onChatBarPressesd(_:)), for: UIControlEvents.touchUpInside)
        btnChatMenu.setImage(#imageLiteral(resourceName: "ic_chat"), for: UIControlState())
        btnChatMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let frame = CGRect(x: 18, y: -4, width: 15, height: 15)
        createBadge(parent: btnChatMenu, tag: 200, number: 0, frame: frame)
        //btnChatMenu.createBadge(tag: 200, number: 0, frame: frame)
        let customChatBarItem = UIBarButtonItem(customView: btnChatMenu)
        
        let btnMapMenu = UIButton(type: UIButtonType.custom)
        btnMapMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnMapMenu.addTarget(self, action: #selector(Base_VC.onMapBarPressesd(_:)), for: UIControlEvents.touchUpInside)
        btnMapMenu.setImage(#imageLiteral(resourceName: "ic_map"), for: UIControlState())
        btnMapMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        let customMapBarItem = UIBarButtonItem(customView: btnMapMenu)
        
        
        //self.navigationItem.rightBarButtonItems = [customNotiBarItem, customChatBarItem, customMapBarItem]
        self.navigationItem.setRightBarButtonItems([customNotiBarItem, customChatBarItem, customMapBarItem], animated: true)
        
        updateBadgeChat()
        
        updateBadgeNotification()
    }
    
    func onChatBarPressesd(_ sender : UIButton){
        Config.SelectMenuIndex = -1
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatMain") as! ChatMain_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onMapBarPressesd(_ sender : UIButton){
        Config.SelectMenuIndex = -1
        let vc = storyboard?.instantiateViewController(withIdentifier: "Map") as! Map_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onNotiBarPressesd(_ sender : UIButton){
        Config.SelectMenuIndex = -1
        let vc = storyboard?.instantiateViewController(withIdentifier: "Noti") as! Notification_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initEnvent(){
        //ChatHub.addChatHub(hub:  ChatHub.chatHub)

        ChatHub.chatHub.on("receivePrivateMessage") {args in         
            ChatCommon.updateReceiveMessage(args: args, contactType: 1)
            self.updateBadgeChat()
        }
        ChatHub.chatHub.on("receiveGroupMessage") {args in
            ChatCommon.updateReceiveMessage(args: args, contactType: 2)
            self.updateBadgeChat()
        }
        ChatHub.chatHub.on("receiveChatGroup") {args in
            ChatCommon.updateCreateGroup(args: args)
            self.updateBadgeChat()
        }
        ChatHub.chatHub.on("makeReadMessage"){args in
            ChatCommon.updateMakeReadMessage(args: args)
            self.updateBadgeChat()
        }
        
        ChatHub.chatHub.on("notification") {args in
            ChatCommon.notification(args: args)
            self.updateBadgeNotification()
            //Config.nTotalNotificationNotRead = Config.nTotalNotificationNotRead + 1
        }
        ChatHub.chatHub.on("makeReadAllNotification") {args in
            ChatCommon.makeReadAllNotification()
            self.updateBadgeNotification()
            //Config.nTotalNotificationNotRead = 0
        }
        
        ChatHub.chatHub.on("makeReadNotification") {args in
            ChatCommon.makeReadNotification(args: args)
            self.updateBadgeNotification()
            //Config.nTotalNotificationNotRead = Config.nTotalNotificationNotRead - 1
        }
    }
    func getTotalNofiticationNotRead(){
        //// lay tong so notification chua doc
        //let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getTotalNotificationsNotRead"
        
        // lay list notification chua doc
        let apiUrl : String = "\(UrlPreFix.Map.rawValue)/getListNotificationsNotRead"
        let params : String = "{\"nUserID\" : \(Config.userID)}"
        ApiService.Post(url: apiUrl, params: params, callback: callbackGetTotalNotiNotRead, errorCallBack: errorGetTotalNotiNotRead)
    }
    
    func callbackGetTotalNotiNotRead(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String : Any] {
            /*let nCount = dic["getTotalNotificationsNotReadResult"] as? String
            Config.nTotalNotificationNotRead = Int32(nCount!)!
            Config.bCheckRead = true
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.updateBadgeNotification()
                }
            }*/
            
            Config.bCheckRead = true
            Config.listNotificationNotRead = [Int]()
            let items = dic["getListNotificationsNotReadResult"] as? [Int]
            for item in items!{
                Config.listNotificationNotRead.append(item)
            }
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.updateBadgeNotification()
                }
            }
        }
    }
    
    func errorGetTotalNotiNotRead(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func updateBadgeChat(){
        let btn : UIBarButtonItem = (self.navigationItem.rightBarButtonItems?[1])! as UIBarButtonItem
    
        let label : UILabel = btn.customView?.viewWithTag(200) as! UILabel
        let count = getNumberBadgeChat()
        if(count > 0){
            label.text = String(count)
            label.isHidden = false
        }
        else{
            label.text = ""
            label.isHidden = true
        }
    }
    
    func updateBadgeNotification(){
        let btn : UIBarButtonItem = (self.navigationItem.rightBarButtonItems?[0])! as UIBarButtonItem
        let label : UILabel = btn.customView?.viewWithTag(200) as! UILabel
        let count = getNumberBadgeNotification()
        if(count > 0){
            label.text = String(count)
            label.isHidden = false
        }
        else{
            label.text = ""
            label.isHidden = true
        }
    }
    
    private func getNumberBadgeChat() -> Int{
        let list = ChatCommon.listContact.filter(){
            if $0.NumberOfNewMessage! > 0 {
                return true
            } else {
                return false
            }
        }
        return list.count
    }
    
    private func getNumberBadgeNotification() -> Int{
        //let nCount = Config.nTotalNotificationNotRead
        //return Int(nCount)
        return Config.listNotificationNotRead.count
    }
    
    func createBadge(parent : UIView, tag : Int, number : Int, frame : CGRect){
        let label = UILabel(frame: frame)
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.backgroundColor = .red
        label.tag = tag
        
        if(number > 0){
            label.text = String(number)
            label.isHidden = false
        }
        else{
            label.text = ""
            label.isHidden = true
        }
        parent.addSubview(label)
    }
}
