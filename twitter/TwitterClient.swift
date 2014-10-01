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
    
    func verifyAccountCredentials(handler: ((User!, NSError!) -> Void)!) {
        GET("1.1/account/verify_credentials.json", parameters: nil,
            success: { (operation, data) in
                var user = User(values: data as NSDictionary)
                handler(user, nil)
            },
            failure: { (operation, error) in
                handler(nil, error)
        })
    }
    
    func updateStatus(status: String, inReplyToStatusId: Int?, handler: ((Tweet!, NSError!) -> Void)!) {
        var params = ["status": status] as [NSString: AnyObject]
        
        if let suppliedInReplyToStatusId = inReplyToStatusId {
            params["in_reply_to_status_id"] = suppliedInReplyToStatusId
        }
        
        POST("1.1/statuses/update.json", parameters: params,
            success: { (operation, data) in
                var tweet = Tweet(values: data as NSDictionary)
                handler(tweet, nil)
            },
            failure: { (operation, error) in
                handler(nil, error)
        })
    }
    
    func favoriteTweetWithId(id: Int, handler: ((Tweet!, NSError!) -> Void)!) {
        POST("1.1/favorites/create.json", parameters: ["id": id],
            success: { (operation, data) in
                var tweet = Tweet(values: data as NSDictionary)
                handler(tweet, nil)
            },
            failure: { (operation, error) in
                handler(nil, error)
        })
    }
    
    func unfavoriteTweetWithId(id: Int, handler: ((Tweet!, NSError!) -> Void)!) {
        POST("1.1/favorites/destroy.json", parameters: ["id": id],
            success: { (operation, data) in
                var tweet = Tweet(values: data as NSDictionary)
                handler(tweet, nil)
            },
            failure: { (operation, error) in
                handler(nil, error)
        })
    }
}
