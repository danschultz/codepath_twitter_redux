//
//  Tweet.swift
//  twitter
//
//  Created by Dan Schultz on 9/28/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int
    var user: User
    var text: String
    var createdAt: NSDate
    dynamic var retweetCount: Int
    dynamic var favoriteCount: Int
    
    var hasFavorites: Bool {
        get {
            return favoriteCount > 0
        }
    }
    
    var hasRetweets: Bool {
        get {
            return retweetCount > 0
        }
    }
    
    var timeAgo: String {
        get {
            return createdAt.timeAgo()
        }
    }
    
    init(values: NSDictionary) {
        id = values["id"] as Int
        user = User(values: values["user"] as NSDictionary)
        text = values["text"] as String
        retweetCount = values["retweet_count"] as Int
        favoriteCount = values["favorite_count"] as Int
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y";
        createdAt = formatter.dateFromString(values["created_at"] as String)!
    }
}
