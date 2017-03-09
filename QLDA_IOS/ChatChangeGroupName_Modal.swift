//
//  ChatChangeGroupName_.swift
//  QLDA_IOS
//
//  Created by datlh on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ChatChangeGroupName_Modal: UIViewController,  UITextFieldDelegate {
    
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var viewModal: UIView!
    @IBOutlet weak var viewOut: UIView!
    var groupName : String!
    var groupID : Int!
    
    var bottomConstraint: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModal.layer.cornerRadius = 10
        
        //var lineView = UIView(frame: CGRectMake(0, 0, viewModal.frame.size.width, 1))
        let lineView = UIView(frame: CGRect(x: 0, y: 77, width: viewModal.frame.width, height: 0.5))
        lineView.backgroundColor=UIColor(netHex: 0xDFDFE3)
        viewModal.addSubview(lineView)
        
        let lineView2 = UIView(frame: CGRect(x: 121, y: 77, width: 0.5, height: 40))
        lineView2.backgroundColor=UIColor(netHex: 0xDFDFE3)
        viewModal.addSubview(lineView2)
        
        //EBEBEB màu button khi focus
        
        txtGroupName.text = groupName
        txtGroupName.becomeFirstResponder()
     
        if(txtGroupName.text?.characters.count == 0){
            btnOK.isEnabled = false
        }
        else{
            btnOK.isEnabled = true
        }
        
        
        bottomConstraint = NSLayoutConstraint(item: viewOut, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            //print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height/2 : 0
            
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    //self.scrollToBottom(animate: true)
                    //let indexPath = IndexPath(item: self.txtMessage!.count - 1, section: 0)
                    //self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
                
            })
            
        }
    }
    
    @IBAction func txtGroupChanged(_ sender: Any) {
        if(txtGroupName.text?.characters.count == 0){
            btnOK.isEnabled = false
        }
        else{
            btnOK.isEnabled = true
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case txtGroupName:
            txtGroupName.selectedTextRange = txtGroupName.textRange(from: txtGroupName.beginningOfDocument, to: txtGroupName.endOfDocument)
            break;
            
        default:
            break;
        }
    }
    
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ok(_ sender: UIButton) {
        do {
            let newName : String = (txtGroupName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            try ChatHub.chatHub.invoke("ChangeGroupName", arguments: [groupID, newName])
        } catch {
            print(error)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancle(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
