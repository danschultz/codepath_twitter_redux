//
//  TweetViewController.swift
//  twitter
//
//  Created by Dan Schultz on 9/25/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, ComposeTweetViewControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet!
    
    var twitterClient = TwitterClient.sharedInstance
    
    var user: User {
        get {
            var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            return appDelegate.applicationModel.signedInUser!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateControls()
    }
    
    private func updateControls() {
        profileImage.setImageWithURL(tweet.user.profileImageUrl)
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName)"
        messageLabel.text = tweet.text
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favoriteCount)"
        retweetButton.enabled = tweet.user.screenName != user.screenName
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/yyyy h:mm a"
        dateLabel.text = dateFormatter.stringFromDate(tweet.createdAt)
        
        updateFavoriteButton(tweet.favorited)
        updateRetweetButton(tweet.retweeted)
    }
    
    private func updateFavoriteButton(value: Bool) {
        var image = UIImage(named: value ? "Favorited" : "Favorite")
        favoriteButton.setImage(image, forState: UIControlState.Normal)
    }
    
    private func updateRetweetButton(value: Bool) {
        var image = UIImage(named: value ? "Retweeted" : "Retweet")
        retweetButton.setImage(image, forState: UIControlState.Normal)
    }
    
    // - MARK: Actions
    @IBAction func handleFavoriteTap(sender: AnyObject) {
        tweet.toggleFavorite(twitterClient) { (error) in
            if (error == nil) {
                self.updateControls()
            } else {
                println("error favoriting tweet")
            }
        }
    }
    
    @IBAction func handleReplyTap(sender: AnyObject) {
        performSegueWithIdentifier("TweetToCompose", sender: self)
    }
    
    @IBAction func handleRetweetTap(sender: AnyObject) {
        tweet.retweet(twitterClient) { (tweet, error) in
            if (error == nil) {
                self.updateControls()
            } else {
                println("error retweeting tweet")
            }
        }
    }
    
    // - MARK: Compose delegate
    func composeTweetViewControllerDidTweet(message: String, isRetweet: Bool, isReply: Bool) {
        tweet.reply(message, client: twitterClient) { (tweet, error) in
            if (error != nil) {
                println("error saving reply")
            }
        }
    }
    
    // - MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "TweetToCompose") {
            var navigationController = segue.destinationViewController as UINavigationController
            var composeViewController = navigationController.viewControllers[0] as ComposeTweetViewController
            composeViewController.isReply = true
            composeViewController.delegate = self
            composeViewController.initialMessage = "@\(tweet.user.screenName) "
        }
    }
}
