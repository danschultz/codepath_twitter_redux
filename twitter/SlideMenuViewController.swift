//
//  SlideMenuViewController.swift
//  twitter
//
//  Created by Dan Schultz on 10/4/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {
    
    var _menuViewController: UIViewController?
    var menuViewController: UIViewController? {
        get {
            return _menuViewController
        }
        set {
            if let oldViewController = _menuViewController {
                removeViewController(oldViewController)
            }
            
            _menuViewController = newValue
            
            if let newViewController = newValue {
                if (menuContainerView != nil) {
                    addViewControllerToContainer(newViewController, container: menuContainerView)
                }
            }
        }
    }
    
    var _mainViewController: UIViewController?
    var mainViewController: UIViewController? {
        get {
            return _mainViewController
        }
        set {
            if let oldViewController = _mainViewController {
                removeViewController(oldViewController)
            }
            
            _mainViewController = newValue
            
            if let newViewController = newValue {
                if (mainViewContainer != nil) {
                    addViewControllerToContainer(newViewController, container: mainViewContainer)
                }
            }
        }
    }
    
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var mainViewContainer: UIView!
    @IBOutlet var mainViewTapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let suppliedMenuViewController = menuViewController {
            addViewControllerToContainer(suppliedMenuViewController, container: menuContainerView)
        }
        
        if let suppliedMainViewController = mainViewController {
            addViewControllerToContainer(suppliedMainViewController, container: mainViewContainer)
        }
        
        closeMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainViewContainer.layer.shadowColor = UIColor.blackColor().CGColor
        mainViewContainer.layer.shadowOpacity = 0.7
        mainViewContainer.layer.shadowRadius = 4.0;
        mainViewContainer.layer.shadowOffset = CGSizeMake(0, 0)
        mainViewContainer.layer.shadowPath = UIBezierPath(rect: mainViewContainer.frame).CGPath
        mainViewContainer.clipsToBounds = false
    }
    
    // MARK: - Public API methods
    func openMenu() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.mainViewContainer.frame.origin.x = self.view.frame.width - 50
        })
        mainViewTapGestureRecognizer.enabled = true
    }
    
    func closeMenu() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.mainViewContainer.frame.origin.x = 0
        })
        mainViewTapGestureRecognizer.enabled = false
    }
    
    // MARK: - Actions
    var mainViewContainerPanStartX = CGFloat(0)
    var isPeeking = false
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            mainViewContainerPanStartX = mainViewContainer.frame.origin.x
            isPeeking = sender.locationInView(view).x < view.center.x
        }
        
        if (sender.state == UIGestureRecognizerState.Changed && isPeeking) {
            peekAtMenu(sender.translationInView(view).x)
        }
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            if (isPeeking) {
                peekAtMenuTouchEnd(atTouchPosition: sender.locationInView(view))
            }
            isPeeking = false
        }
    }
    
    @IBAction func handleMainContainerTap(sender: UITapGestureRecognizer) {
        closeMenu()
    }
    
    // MARK: - Private methods
    private func addViewControllerToContainer(viewController: UIViewController, container: UIView) {
        addChildViewController(viewController)
        
        viewController.view.frame = container.frame
        viewController.view.frame.origin.x = 0
        
        container.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    private func removeViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func peekAtMenu(width: CGFloat) {
        var x = mainViewContainerPanStartX + width
        var maxX = view.frame.width - 50
        
        mainViewContainer.frame.origin.x = x <= maxX ? x : maxX
    }
    
    private func peekAtMenuTouchEnd(atTouchPosition touchPosition: CGPoint) {
        // The user moved the main view enough, they want to use the menu.
        if (touchPosition.x > view.center.x) {
            openMenu()
        }
        // The user didn't move the main view far enough, hide the revealed menu.
        else {
            closeMenu()
        }
    }
    
}
