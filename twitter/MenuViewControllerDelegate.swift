//
//  MenuViewControllerDelegate.swift
//  twitter
//
//  Created by Dan Schultz on 10/5/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

@objc protocol MenuViewControllerDelegate : NSObjectProtocol {
    func menuViewControllerDidSelectOption(option: NSDictionary)
}
