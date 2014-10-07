//
//  User.swift
//  twitter
//
//  Created by Dan Schultz on 9/28/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String
    var screenName: String
    var profileBannerUrl: NSURL?
    var profileImageUrl: NSURL
    var tagline: String?
    var followersCount: Int
    var friendsCount: Int
    var statusesCount: Int
    
    var userTimeline: [Tweet]?
    
    // TODO(Dan): need to rename to home timeline
    var timeline: [Tweet]
    
    init(values: NSDictionary) {
        name = values["name"] as String
        screenName = values["screen_name"] as String
        profileImageUrl = NSURL(string: values["profile_image_url"] as String)
        tagline = values["tagline"] as? String
        followersCount = values["followers_count"] as Int
        friendsCount = values["friends_count"] as Int
        statusesCount = values["statuses_count"] as Int
        
        if let suppliedProfileBannerUrl = values["profile_banner_url"] as? String {
            profileBannerUrl = NSURL(string: suppliedProfileBannerUrl)
        }
        
        timeline = []
    }
    
    func reloadTimeline(client: TwitterClient, handler: ([Tweet]!, NSError!) -> Void) {
        client.homeTimeline() { (tweets, error) in
            if (error == nil) {
                self.timeline.removeAll(keepCapacity: false)
                self.timeline += tweets
            }
            handler(tweets, error)
        }
    }
    
    func reloadUserTimeline(client: TwitterClient, handler: ([Tweet]!, NSError!) -> Void) {
        client.userTimeline(screenName) { (tweets, error) in
            if (error == nil) {
                self.userTimeline = tweets
            }
            handler(tweets, error)
        }
    }
}
