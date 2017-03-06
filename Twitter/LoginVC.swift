//
//  LoginVC.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/4/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginDidTouch(_ sender: Any) {
        TwitterClient.sharedInstance.login(success: {
            print("I've logged in!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error) in
            print("Error: \(error.localizedDescription)")
        }
    }

}
