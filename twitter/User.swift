//
//  User.swift
//  twitter
//
//  Created by Dan Schultz on 9/28/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString
    var screenName: NSString
    var profileImageUrl: NSURL
    var tagline: NSString
    
    init(values: NSDictionary) {
        name = values["name"] as NSString
        screenName = values["screen_name"] as NSString
        profileImageUrl = NSURL(string: values["profile_image_url"] as NSString)
        tagline = values["tagline"] as NSString
    }
}
