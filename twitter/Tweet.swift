//
//  Tweet.swift
//  twitter
//
//  Created by Dan Schultz on 9/28/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var user: User!
    var text: String!
    var createdAt: NSDate!
    var favorited: Bool!
    var favoriteCount: Int!
    var retweeted: Bool!
    var retweetCount: Int!
    
    var hasFavorites: Bool! {
        get {
            return favoriteCount > 0
        }
    }
    
    var hasRetweets: Bool! {
        get {
            return retweetCount > 0
        }
    }
    
    var timeAgo: String! {
        get {
            return createdAt.timeAgo()
        }
    }
    
    init(values: NSDictionary) {
        // Required fields, for creating a new tweet
        text = values["text"] as String
        user = values["user"] is User ? values["user"] as User : User(values: values["user"] as NSDictionary)
        
        if (values["created_at"] != nil) {
            var formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y";
            createdAt = formatter.dateFromString(values["created_at"] as String)!
        } else {
            createdAt = NSDate()
        }
        
        // Optional fields
        id = values["id"] as? Int
        favorited = values["favorited"] as? Bool
        favoriteCount = values["favorite_count"] as? Int
        retweeted = values["retweeted"] as? Bool
        retweetCount = values["retweet_count"] as? Int
    }
    
    func toggleFavorite(client: TwitterClient, handler: (error: NSError!) -> Void) {
        if (!favorited) {
            client.favoriteTweetWithId(id!) { (tweet, error) in
                if (tweet != nil) {
                    self.copyValuesFromTweet(tweet)
                }
                handler(error: error)
            }
        } else {
            client.unfavoriteTweetWithId(id!) { (tweet, error) in
                if (tweet != nil) {
                    self.copyValuesFromTweet(tweet)
                }
                handler(error: error)
            }
        }
    }
    
    func save(client: TwitterClient, handler: (error: NSError!) -> Void) {
        if (id == nil) {
            client.updateStatus(text, inReplyToStatusId: nil) { (tweet, error) in
                if (error == nil) {
                    self.copyValuesFromTweet(tweet)
                }
                handler(error: error)
            }
        } else {
            println("editing a tweet is unhandled for now")
        }
    }
    
    func reply(message: String, client: TwitterClient, handler: (Tweet!, NSError!) -> Void) {
        assert(id != nil, "replying to a unsaved tweet is not supported yet")
        
        client.updateStatus(message, inReplyToStatusId: id) { (tweet, error) in
            handler(tweet, error)
        }
    }
    
    func retweet(client: TwitterClient, handler: (Tweet!, NSError!) -> Void) {
        assert(id != nil, "retweeting an unsaved tweet is not supported yet")
        
        client.retweetTweetWithId(id!) { (tweet, error) in
            if (error == nil) {
                self.retweeted = true
                self.retweetCount = self.retweetCount + 1
            }
            handler(tweet, error)
        }
    }
    
    private func copyValuesFromTweet(tweet: Tweet) {
        id = tweet.id
        user = tweet.user
        text = tweet.text
        retweeted = tweet.retweeted
        retweetCount = tweet.retweetCount
        favorited = tweet.favorited
        favoriteCount = tweet.favoriteCount
        createdAt = tweet.createdAt
    }
}
