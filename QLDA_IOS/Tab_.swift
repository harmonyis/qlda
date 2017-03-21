//
//  Tab_.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 02/03/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip

class Tab_:ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var uiViewTenDuAn: UIView!
    let graySpotifyColor = UIColor(netHex: 0xcccccc)
    let darkGraySpotifyColor = UIColor(netHex: 0xcccccc)
    
    override func viewDidLoad() {
        // change selected bar color
        
        settings.style.buttonBarBackgroundColor = graySpotifyColor
        settings.style.buttonBarItemBackgroundColor = graySpotifyColor
        settings.style.selectedBarBackgroundColor = UIColor(netHex: 0x0e83d5)
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Bold", size:14) ?? UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 1.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        
        settings.style.buttonBarLeftContentInset = 5
        settings.style.buttonBarRightContentInset = 5
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(netHex: 0xbbbbbb)
            newCell?.label.textColor = UIColor(netHex: 0x0e83d5)
            
            
        }
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                ChatHub.addChatHub(hub: ChatHub.chatHub)
                self.initEnvent()
            }
        }
        
        let uiView = UIView()
        let lable:UILabel = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
        lable.text = variableConfig.m_szTenDuAn
        lable.frame = CGRect(x: 10, y: 10 , width: self.view.frame.width - 10, height: CGFloat.greatestFiniteMagnitude)
        lable.numberOfLines = 0
        lable.sizeToFit()
        uiView.addSubview(lable)
        
        var calHeight : CGFloat = 37
        if lable.frame.height > 20 {
            calHeight = (CGFloat)((Double)(lable.frame.height*1.5)) + 15
        }
        
        uiView.frame = CGRect(x: 0,y: 5 ,width: self.uiViewTenDuAn.frame.width - 10 , height: calHeight)
        //    self.uiViewTenDA.frame = CGRect(x: 0,y: 70 ,width: self.uiViewTenDA.frame.width - 10 , height: lable.frame.height + 4)
        self.uiViewTenDuAn.addSubview(uiView)
        self.uiViewTenDuAn.heightAnchor.constraint(
            equalTo: uiView.heightAnchor,
            multiplier: 0.65).isActive = true
        
        
        self.addLeftBarButton()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.addRightBarButton()
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
    }
    
    func onChatBarPressesd(_ sender : UIButton){
        Config.SelectMenuIndex = -1
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatMain") as! ChatMain_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_TTC = self.storyboard?.instantiateViewController(withIdentifier: "Tab_TTC") as! Tab_TTC
        child_TTC.blackTheme = true
        let child_QDDT = self.storyboard?.instantiateViewController(withIdentifier: "Tab_QDDT") as! Tab_QDDT
        child_QDDT.blackTheme = true
        let child_KHV = self.storyboard?.instantiateViewController(withIdentifier: "Tab_KHV") as! Tab_KHV
        child_QDDT.blackTheme = true
        let child_KHLCNT = self.storyboard?.instantiateViewController(withIdentifier: "Tab_KHLCNT") as! Tab_KHLCNT
        child_KHLCNT.blackTheme = true
        let child_QLHA = self.storyboard?.instantiateViewController(withIdentifier: "Tab_QLHA") as! QLHinhAnh_VC
        child_QDDT.blackTheme = true
        let child_KHGN = self.storyboard?.instantiateViewController(withIdentifier: "Tab_KHGN") as! Tab_KHGN
        //child_KHGN.blackTheme = true
        let child_VBDA = self.storyboard?.instantiateViewController(withIdentifier: "Tab_VBDA") as! Tab_VanBanDuAnVC
        
        
        return [child_TTC,child_QDDT,child_KHV,child_KHLCNT,child_KHGN,child_VBDA,child_QLHA]
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

