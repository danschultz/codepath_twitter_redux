//
//  Tweet.swift
//  twitter
//
//  Created by Dan Schultz on 9/28/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User
    var text: String
    var createdAt: NSDate
    
    init(values: NSDictionary) {
        user = User(values: values["user"] as NSDictionary)
        text = values["text"] as String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y";
        createdAt = formatter.dateFromString(values["created_at"] as String)!
    }
}
