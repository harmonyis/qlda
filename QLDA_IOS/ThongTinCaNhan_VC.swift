//
//  ThongTinCaNhan_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class ThongTinCaNhan_VC: Base_VC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnProfile: UIButton!
    //@IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var txtCurrentPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnChangePass: UIButton!
    
    var newPass : String?
    var imagePicker = UIImagePickerController()
    
    var imageTemp : UIImage?
    
    @IBAction func btnChangePassTouch(_ sender: UIButton) {
        if txtCurrentPass.text != Config.passWord{
            lblMsg.text = "Mật khẩu hiện tại không chính xác!"
            return
        }
        if txtNewPass.text != txtConfirmPass.text{
            lblMsg.text = "Hai mật khẩu mới không trùng nhau!"
            return
        }
        newPass = txtConfirmPass.text!
        let apiUrl : String = "\(UrlPreFix.QLDA.rawValue)/ThayDoiMatKhau"

        let params : String = "{\"szUsername\" : \"\(Config.userName)\", \"szPassword\": \"\(Config.passWord)\",\"szNewPass\" : \"\(newPass!)\"}"

        ApiService.Post(url: apiUrl, params: params, callback: callbackChangePass, errorCallBack: { (error) in
            print("error")
            print(error.localizedDescription)
        })
    }
    
    func callbackChangePass(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])

        if let dic = json as? [String:Any] {
            let msg = dic["ThayDoiMatKhauResult"] as! String
            print(msg)
            if(msg == "Thay đổi mật khẩu thành công!"){
                Config.passWord = newPass!
            }
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                     self.lblMsg.text = msg
                }
            }
           
        }

    }
    @IBAction func btnProfileTouch(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageTemp = resizeImage(image: image, newWidth: 540)
            //btnProfile.setBackgroundImage(newImg, for: .normal)

            let data = UIImageJPEGRepresentation(imageTemp!, 1.0)
            let array = [UInt8](data!)
            
            let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_ChangeUserPicture"
            
            let params : String = "{\"userID\": \"\(String(Config.userID))\", \"imageData\":\(array)}"
            //let params : String = "{\"groupID\" : \"\(String(groupID!))\", \"userID\": \"\(String(ChatHub.userID))\"}"
            ApiService.Post(url: apiUrl, params: params, callback: callbackChagePicture, errorCallBack: { (error) in
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
    
    func callbackChagePicture(data : Data) {
        Config.profilePicture = imageTemp
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.btnProfile.setImage(self.imageTemp, for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //btnProfile.maskCircle()
        lblUserName.text = Config.userName
        lblMsg.text = ""
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if(Config.profilePicture != nil){
                    //self.imgProfile.image = Config.profilePicture
                    self.btnProfile.setImage(Config.profilePicture, for: .normal)
                }
            }
        }
    }
}
