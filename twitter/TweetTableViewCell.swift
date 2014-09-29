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
    
    var _tweet: Tweet?
    var tweet: Tweet? {
        get {
            return _tweet
        }
        set {
            _tweet = newValue
            updateControls()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateControls() {
        nameLabel.text = tweet!.user.name
        screenNameLabel.text = "@\(tweet!.user.screenName)"
        messageLabel.text = tweet!.text
        profileImage.setImageWithURL(tweet!.user.profileImageUrl)
        timeLabel.text = tweet!.createdAt.timeAgo()
    }

}
