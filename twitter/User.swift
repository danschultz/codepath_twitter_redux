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
    var profileImageUrl: NSURL
    var tagline: String?
    
    init(values: NSDictionary) {
        name = values["name"] as String
        screenName = values["screen_name"] as String
        profileImageUrl = NSURL(string: values["profile_image_url"] as String)
        tagline = values["tagline"] as? String
    }
}
