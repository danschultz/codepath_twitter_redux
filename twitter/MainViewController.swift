//
//  MainViewController.swift
//  twitter
//
//  Created by Dan Schultz on 10/4/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MenuViewControllerDelegate {

    var slideMenuViewController: SlideMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var menuNavigationController = storyboard?.instantiateViewControllerWithIdentifier("MenuNavigationController") as UINavigationController
        var menuViewController = menuNavigationController.viewControllers[0] as MenuViewController
        menuViewController.delegate = self
        
        slideMenuViewController = storyboard?.instantiateViewControllerWithIdentifier("SlideMenuViewController") as SlideMenuViewController
        view.addSubview(slideMenuViewController.view)
        
        slideMenuViewController.menuViewController = menuNavigationController
        showTimelineView()
    }
    
    private func showTimelineView() {
        var timelineNavigationController = storyboard?.instantiateViewControllerWithIdentifier("HomeTimelineNavigationController") as UINavigationController
        var timelineViewController = timelineNavigationController.viewControllers[0] as HomeTimelineViewController
        slideMenuViewController.mainViewController = timelineNavigationController
    }
    
    // MARK: - Menu View Delegate
    func menuViewControllerDidSelectOption(option: NSDictionary) {
        if (option["title"] as String == "Timeline") {
            showTimelineView()
        }
        slideMenuViewController.closeMenu()
    }
}
