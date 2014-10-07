//
//  TweetTableViewCell.swift
//  twitter
//
//  Created by Dan Schultz on 9/25/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var profileImageTapRecognizer: UITapGestureRecognizer!
    
    var delegate: TweetTableViewCellDelegate?
    
    var twitterClient = TwitterClient.sharedInstance
    
    var _tweet: Tweet!
    var tweet: Tweet! {
        get {
            return _tweet
        }
        set {
            _tweet = newValue
            updateControls()
        }
    }
    
    var user: User {
        get {
            var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            return appDelegate.applicationModel.signedInUser!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.preferredMaxLayoutWidth = 280;
        
        profileImageTapRecognizer = UITapGestureRecognizer(target: self, action: "handleProfileImageTap:")
        profileImageTapRecognizer.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(profileImageTapRecognizer)
    }
    
    private func updateControls() {
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName)"
        messageLabel.text = tweet.text
        profileImage.setImageWithURL(tweet.user.profileImageUrl)
        timeLabel.text = tweet.timeAgo
        
        retweetButton.enabled = tweet.user.screenName != user.screenName
        updateRetweetButton(tweet.retweeted)
        if (tweet.hasRetweets) {
            retweetCountLabel.text = "\(tweet.retweetCount)"
        } else {
            retweetCountLabel.text = ""
        }
        
        updateFavoriteButton(tweet.favorited)
        if (tweet.hasFavorites) {
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
        } else {
            favoriteCountLabel.text = ""
        }
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
    
    @IBAction func handleRetweetTap(sender: AnyObject) {
        tweet.retweet(twitterClient) { (tweet, error) in
            if (error == nil) {
                self.updateControls()
            } else {
                println("error retweeting tweet")
            }
        }
    }
    
    func handleProfileImageTap(sender: AnyObject) {
        delegate?.tweetTableViewCellDidTapProfileImage?(tweet.user)
    }
}
