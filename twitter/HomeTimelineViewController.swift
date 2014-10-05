//
//  ViewController.swift
//  twitter
//
//  Created by Dan Schultz on 9/25/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UITableViewController, ComposeTweetViewControllerDelegate {

    var tweets: [Tweet]!
    
    private var selectedTweet: Tweet?
    
    private var twitterClient = TwitterClient.sharedInstance
    
    var applicationModel: Application {
        get {
            var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            return appDelegate.applicationModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweets = applicationModel.signedInUser?.timeline
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefreshRequest:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func reloadTweets() {
        if let lastTweet = tweets?.first {
            twitterClient.homeTimelineAfterTweetWithId(lastTweet.id!) { (tweets, error) in
                if (tweets != nil) {
                    for tweet in tweets.reverse() {
                        self.tweets?.insert(tweet, atIndex: 0)
                    }
                    
                    self.tableView.reloadData()
                }
                
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Actions
    func handleRefreshRequest(sender: UIRefreshControl) {
        reloadTweets()
    }

    // MARK: - Table View Shiz
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets != nil ? tweets!.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetTableViewCell
        if let loadedTweets = tweets {
            cell.tweet = loadedTweets[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let loadedTweets = tweets {
            selectedTweet = loadedTweets[indexPath.row]
            performSegueWithIdentifier("HomeTimelineToTweet", sender: self)
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Compose Delegate Shiznizz
    func composeTweetViewControllerDidTweet(message: String, isRetweet: Bool, isReply: Bool) {
        if (!isReply || !isRetweet) {
            var pendingTweet = Tweet(values: ["text": message, "user": applicationModel.signedInUser!])
            tweets?.insert(pendingTweet, atIndex: 0)
            tableView.reloadData()
            
            pendingTweet.save(twitterClient) { (error) in
                if (error != nil) {
                    println("error saving tweet")
                }
            }
        }
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "HomeTimelineToTweet") {
            var tweetViewController = segue.destinationViewController as TweetViewController
            tweetViewController.tweet = selectedTweet
        } else if (segue.identifier == "HomeTimelineToCompose") {
            var navigationController = segue.destinationViewController as UINavigationController
            var composeTweetController = navigationController.childViewControllers[0] as ComposeTweetViewController
            composeTweetController.delegate = self
        }
    }
}

