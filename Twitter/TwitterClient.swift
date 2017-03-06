//
//  TwitterClient.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/5/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import BDBOAuth1Manager
import UIKit

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "450hIdYbuO8NkcYu34ND0theZ", consumerSecret: "HDI8Ay9k1377cGsbc3kPVptgQY8j3ur1vuMbMoo0ZKalPybyRU")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccoun(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { task, error in
            failure(error)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterDemoJayven://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            if let requestToken = requestToken {
                print("I got a token")
                print(requestToken)
                
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
                UIApplication.shared.openURL(url)
            }
        }, failure: { (error) in
            error.debugDescription
            print(error?.localizedDescription)
            print("Error:", error)
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogOutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {

        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccoun(success: { (user) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error) in
                self.loginFailure?(error)
            })
            
        }, failure: { error in
            print("Error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func newTweet(tweet: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance.post("1.1/statuses/update.json", parameters: ["status": tweet], progress: nil, success: { (task, response) in
            success()
            print(response)
        }) { (task, error) in
            failure(error)
            print(error.localizedDescription)
        }
    }
    
    func retweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance.post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task, response) in
            success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func favorite(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance.post("1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: { (task, response) in
            success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func reply(tweet: String, id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        print("Reply ID:", id)
        TwitterClient.sharedInstance.post("1.1/statuses/update.json", parameters: ["status": "@\(id) \(tweet)"], progress: nil, success: { (task, response) in
            print(response)
            success()
        }) { (task, error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
}
