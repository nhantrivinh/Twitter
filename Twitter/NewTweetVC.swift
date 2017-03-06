//
//  NewTweetVC.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/6/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit

protocol NewTweetVCDelegate {
    func didFinishUpdate()
}

class NewTweetVC: UIViewController {
    
    var delegate: NewTweetVCDelegate!
    
    @IBOutlet weak var tvInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvInput.text = ""
        tvInput.becomeFirstResponder()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelDidTouch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnTweetDidTouch(_ sender: Any) {
        let tweet = tvInput.text!
        if tweet == "" {
            return
        }
        
        TwitterClient.sharedInstance.newTweet(tweet: tweet, success: {
            print("success")
            self.delegate.didFinishUpdate()
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            print(error)
        }
    }

}
