//
//  TweetsVC.swift
//  Twitter
//
//  Created by Jayven Nhan on 3/5/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit

class TweetsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var tweets: [Tweet]?
    var selectedTweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_ :)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchData()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    func fetchData() {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailTweet" {
            let detailTweetVC = segue.destination as! DetailTweetVC
            detailTweetVC.tweet = selectedTweet
        } else if segue.identifier == "newTweetSegue" {
            let navController = segue.destination as! UINavigationController
            let newTweetVC = navController.topViewController as! NewTweetVC
            newTweetVC.delegate = self
        }
    }

    @IBAction func btnLogoutDidTouch(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func btnNewDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "newTweetSegue", sender: nil)
    }
}

extension TweetsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tweets = tweets else { return 0 }
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTVC", for: indexPath) as? TweetTVC {
            let tweet = tweets![indexPath.row]
            cell.configureCell(tweet: tweet)
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        selectedTweet = tweets![indexPath.row]
        performSegue(withIdentifier: "detailTweet", sender: nil)
    }
}

extension TweetsVC: NewTweetVCDelegate {
    
    func didFinishUpdate() {
        fetchData()
    }
    
}
