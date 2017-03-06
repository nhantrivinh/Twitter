//
//  TweetTVC.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/6/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import SDWebImage
import NSDate_TimeAgo

class TweetTVC: UITableViewCell {

    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTimestamp: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var btnRetweet: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgViewProfile.layer.borderWidth = 0.5
        imgViewProfile.layer.cornerRadius = 3.0
        imgViewProfile.layer.borderColor = UIColor.lightGray.cgColor
        imgViewProfile.clipsToBounds = true
    }
    
    func configureCell(tweet: Tweet) {
        lblDisplayName.text = tweet.displayName
        lblUsername.text = "@\(tweet.username!)"
        lblDesc.text = tweet.text
        
        if let profileImgUrl = tweet.profileImgUrl {
            imgViewProfile.sd_setImage(with: profileImgUrl)
        }
        
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
            
            if time.lowercased() == "a" {
                time = "1"
            }
            
            lblTimestamp.text = "\(time) \(timeUnit)"
            
        } else {
            lblTimestamp.text = "0 Hr"
        }
    }

    @IBAction func btnReplyDidTouch(_ sender: Any) {
    }
    
    @IBAction func btnRetweetDidTouch(_ sender: Any) {
    }
    
    @IBAction func btnFavoriteDidTouch(_ sender: Any) {
    }
}
