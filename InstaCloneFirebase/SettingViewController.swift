//
//  SettingViewController.swift
//  InstaCloneFirebase
//
//  Created by MAKAN on 2.05.2020.
//  Copyright © 2020 YUNUS MAKAN. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        // singout metodu bize hata cevirebilecegi icin do try catch yapisi icinde yazdik.
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toVC", sender: nil)
        } catch  {
            print("error")
        }
    }
    
    
    
}
