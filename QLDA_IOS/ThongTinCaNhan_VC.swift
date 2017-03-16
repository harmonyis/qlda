//
//  ThongTinCaNhan_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class ThongTinCaNhan_VC: Base_VC {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.maskCircle()
        lblUserName.text = Config.userName
        // Do any additional setup after loading the view.
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
                    self.imgProfile.image = Config.profilePicture
                }
            }
        }
    }
}
