//
//  ProfileCounterTableViewCell.swift
//  twitter
//
//  Created by Dan Schultz on 10/6/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class ProfileCounterTableViewCell: UITableViewCell {

    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    
    var _user: User!
    var user: User! {
        get {
            return _user
        }
        set {
            _user = newValue
            updateControls()
        }
    }
    
    private func updateControls() {
        followersCountLabel.text = "\(user.followersCount)"
        followingCountLabel.text = "\(user.friendsCount)"
        tweetsCountLabel.text = "\(user.statusesCount)"
    }

}
