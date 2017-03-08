//
//  ChatChangeGroupName_.swift
//  QLDA_IOS
//
//  Created by datlh on 3/8/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit

class ChatChangeGroupName_Modal: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overCurrentContext
        // Do any additional setup after loading the view.
    }


    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
