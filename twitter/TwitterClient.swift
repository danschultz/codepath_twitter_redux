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
    
}
