//
//  MainViewController.swift
//  twitter
//
//  Created by Dan Schultz on 10/4/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MenuViewControllerDelegate {

    var application: Application!
    
    var slideMenuViewController: SlideMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var menuNavigationController = storyboard?.instantiateViewControllerWithIdentifier("MenuNavigationController") as UINavigationController
        var menuViewController = menuNavigationController.viewControllers[0] as MenuViewController
        menuViewController.user = application.signedInUser
        menuViewController.delegate = self
        
        slideMenuViewController = storyboard?.instantiateViewControllerWithIdentifier("SlideMenuViewController") as SlideMenuViewController
        view.addSubview(slideMenuViewController.view)
        addChildViewController(slideMenuViewController)
        
        slideMenuViewController.menuViewController = menuNavigationController
        showTimelineView()
//        showProfileView()
    }
    
    private func showTimelineView() {
        var timelineNavigationController = storyboard?.instantiateViewControllerWithIdentifier("HomeTimelineNavigationController") as UINavigationController
        var timelineViewController = timelineNavigationController.viewControllers[0] as HomeTimelineViewController
        slideMenuViewController.mainViewController = timelineNavigationController
    }
    
    private func showProfileView() {
        var profileNavigationController = storyboard?.instantiateViewControllerWithIdentifier("ProfileNavigationController") as UINavigationController
        var profileViewController = profileNavigationController.viewControllers[0] as ProfileViewController
        profileViewController.user = application.signedInUser
        slideMenuViewController.mainViewController = profileNavigationController
    }
    
    // MARK: - Menu View Delegate
    func menuViewControllerDidSelectOption(option: NSDictionary) {
        if (option["title"] as String == "Timeline") {
            showTimelineView()
        } else if (option["title"] as String == "Profile") {
            showProfileView()
        }
        
        slideMenuViewController.closeMenu()
    }
}
