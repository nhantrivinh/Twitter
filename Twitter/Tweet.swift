//
//  Tweet.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/5/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import Foundation

class Tweet {

    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var displayName: String?
    var username: String?
    var profileImgUrl: URL?
    var id: String?
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        text = dictionary["text"] as? String
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoriteCount = dictionary["favourites_count"] as? Int ?? 0
        displayName = dictionary.value(forKeyPath: "user.name") as? String ?? "Display Name"
        username = dictionary.value(forKeyPath: "user.screen_name") as? String ?? "Username"
        id = dictionary.value(forKeyPath: "id_str") as? String
        
        if let imgUrl = dictionary.value(forKeyPath: "user.profile_image_url_https") as? String {
            profileImgUrl = URL(string: imgUrl)
        }
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
}
