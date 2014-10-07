//
//  UINavigationController+Twitter.swift
//  twitter
//
//  Created by Dan Schultz on 10/6/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

extension UINavigationController {
    func setNavigationBarToTwitterPrimaryColors() {
        var headerTextColor = UIColor.whiteColor()
        navigationBar.barTintColor = twitterPrimaryColor
        navigationBar.tintColor = headerTextColor
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : headerTextColor
        ]
    }
}
