//
//  ReplyVC.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/6/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit

class ReplyVC: UIViewController {
    
    @IBOutlet weak var tvInput: UITextView!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        tvInput.text = ""
        tvInput.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resignFirstResponder()
    }
    
    @IBAction func btnTweetDidTouch(_ sender: Any) {
        let tweetText = tvInput.text!
        if tweetText == "" {
            return
        }
        
        TwitterClient.sharedInstance.reply(tweet: tweetText, id: tweet.username!, success: {
            print("Reply success")
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            print("Reply error")
        }
        
//        TwitterClient.sharedInstance.newTweet(tweet: tweet, success: {
//            print("success")
//            self.dismiss(animated: true, completion: nil)
//        }) { (error) in
//            print(error)
//        }
    }
    
    @IBAction func btnCancelDidTouch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
