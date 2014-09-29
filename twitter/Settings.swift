//
//  Settings.swift
//  twitter
//
//  Created by Dan Schultz on 9/29/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

class Settings {
    
    class var sharedInstance: Settings {
        struct Static {
            static let instance = Settings()
        }
        
        return Static.instance
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var apiAccessToken: BDBOAuthToken? {
        get {
            if let accessTokenValues = defaults.stringArrayForKey("apiAccessToken") {
                return BDBOAuthToken(
                    token: accessTokenValues[0] as NSString,
                    secret: accessTokenValues[1] as NSString,
                    expiration: nil)
            } else {
                return nil
            }
        }
        set {
            if let authToken = newValue {
                var values = [authToken.token, authToken.secret]
                defaults.setObject(values, forKey: "apiAccessToken")
            } else {
                defaults.removeObjectForKey("apiAccessToken")
            }
        }
    }
    
    func save() {
        defaults.synchronize()
    }
}
