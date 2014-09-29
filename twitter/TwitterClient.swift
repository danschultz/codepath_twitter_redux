//
//  TwitterClient.swift
//  twitter
//
//  Created by Dan Schultz on 9/27/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "pPAOHIJmbkjGsnQtCaCAD6rt3", consumerSecret: "9wN5DdJcnuEW2rStz99xLH1XX2Mf6gISpVdShwvYaWXg9FYGHI")
        }
        
        return Static.instance
    }
    
    func homeTimeline(handler: (([Tweet]!, NSError!) -> Void)!) {
        GET("1.1/statuses/home_timeline.json", parameters: nil,
            success: { (operation, data) in
                var tweets = data as [NSDictionary]
                var parsedTweets = tweets.map({ Tweet(values: $0) })
                handler(parsedTweets, nil)
            },
            failure: { (operation, error) in
                handler(nil, error)
            })
    }
    
    func homeTimelineAfterTweetWithId(id: Int, handler: (([Tweet]!, NSError!) -> Void)!) {
        GET("1.1/statuses/home_timeline.json", parameters: ["since_id": id],
            success: { (operation, data) in
                var tweets = data as [NSDictionary]
                var parsedTweets = tweets.map({ Tweet(values: $0) })
                handler(parsedTweets, nil)
            },
            failure: { (operation, error) in
                handler(nil, error)
            })
    }
}
