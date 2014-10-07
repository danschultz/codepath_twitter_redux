//
//  TweetTableViewCellDelegate.swift
//  twitter
//
//  Created by Dan Schultz on 10/7/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

@objc protocol TweetTableViewCellDelegate : NSObjectProtocol {
    optional func tweetTableViewCellDidTapProfileImage(user: User)
}
