//
//  TweetViewController.swift
//  twitter
//
//  Created by Dan Schultz on 9/25/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateControls()
    }
    
    @IBAction func handleFavoriteTap(sender: AnyObject) {
        tweet.toggleFavorite(TwitterClient.sharedInstance) { (error) in
            if (error == nil) {
                self.updateControls()
            } else {
                println("error favoriting tweet")
            }
        }
    }
    
    private func updateControls() {
        profileImage.setImageWithURL(tweet.user.profileImageUrl)
        nameLabel.text = tweet.user.name
        screenNameLabel.text = tweet.user.screenName
        messageLabel.text = tweet.text
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favoriteCount)"
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/yyyy h:mm a"
        dateLabel.text = dateFormatter.stringFromDate(tweet.createdAt)
        
        updateFavoriteButton(tweet.favorited)
    }
    
    private func updateFavoriteButton(value: Bool) {
        var image = UIImage(named: value ? "Favorited" : "Favorite")
        favoriteButton.setImage(image, forState: UIControlState.Normal)
    }
    
    private func favoriteButtonImageForValue(value: Bool) -> UIImage {
        return UIImage(named: value ? "Favorited" : "Favorite")
    }
}
