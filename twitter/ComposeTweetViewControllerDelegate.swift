//
//  ComposeTweetViewControllerDelegate.swift
//  twitter
//
//  Created by Dan Schultz on 9/30/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

@objc protocol ComposeTweetViewControllerDelegate : NSObjectProtocol {
    func composeTweetViewControllerDidTweet(message: String, isRetweet: Bool, isReply: Bool);
    
    optional func composeTweetViewControllerDidCancel();
}
