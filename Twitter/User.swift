//
//  User.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/5/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var id: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        id = dictionary["id_str"] as? String
        print("User Id: \(id)")
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    static let userDidLogOutNotification = "UserDidLogOut"
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                if let userData = userData {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        } set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                print(user)
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                print(data)
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
}
