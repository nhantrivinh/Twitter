//
//  DetailTweetVC.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/6/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import SDWebImage

class DetailTweetVC: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var btnRetweet: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTimestamp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addTargetToBtns()
        setupView()
    }
    
    func setupView() {
        lblDisplayName.text = tweet.displayName
        lblUsername.text = "@\(tweet.username!)"
        lblDesc.text = tweet.text
        
        if let profileImgUrl = tweet.profileImgUrl {
            imgViewProfile.sd_setImage(with: profileImgUrl)
        }
        
        imgViewProfile.layer.borderWidth = 0.5
        imgViewProfile.layer.cornerRadius = 3.0
        imgViewProfile.layer.borderColor = UIColor.lightGray.cgColor
        imgViewProfile.clipsToBounds = true
        
        print(tweet.profileImgUrl)
        
        if let timestamp = tweet.timestamp as? NSDate {
            var ago = timestamp.timeAgo()
            var strings = ago?.components(separatedBy: " ")
            var time = strings![0]
            var timeUnit = strings![1]
            
            switch timeUnit {
            case "hour":
                timeUnit = "hr"
            case "hours":
                timeUnit = "hr"
            case "minute":
                timeUnit = "m"
            case "minutes":
                timeUnit = "m"
            case "second":
                timeUnit = "s"
            case "seconds":
                timeUnit = "s"
            default:
                break
            }
            
            lblTimestamp.text = "\(time) \(timeUnit)"
            
        } else {
            lblTimestamp.text = "0 Hr"
        }
    }
    
    func addTargetToBtns() {
        btnReply.addTarget(self, action: #selector(btnReplyDidTouch), for: .touchUpInside)
        btnRetweet.addTarget(self, action: #selector(btnRetweetDidTouch), for: .touchUpInside)
        btnFavorite.addTarget(self, action: #selector(btnFavoriteDidTouch), for: .touchUpInside)
    }

    func btnReplyDidTouch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "ReplyNavigationController") as! UINavigationController
        let vc = navController.topViewController as! ReplyVC
        vc.tweet = self.tweet
        self.present(navController, animated: true, completion: nil)
    }
    
    func btnRetweetDidTouch() {
        TwitterClient.sharedInstance.retweet(id: tweet.id!, success: { 
            print("Retweet Success")
        }) { (error) in
            print(error)
        }
    }
    
    func btnFavoriteDidTouch() {
        TwitterClient.sharedInstance.favorite(id: tweet.id!, success: { 
            print("Favorite Success")
        }) { (error) in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR SEGUE")
//        if segue.identifier == "ReplyNavigationController" {
//            let navController = segue.destination as! UINavigationController
//            let replyVC = navController.topViewController as! ReplyVC
//            replyVC.tweet = self.tweet
//        }
    }
}
