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
            _menuViewController = newValue
            
            if let newViewController = newValue {
                if (menuContainerView != nil) {
                    addViewToContainer(menuContainerView, view: newViewController.view)
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
            _mainViewController = newValue
            
            if let newViewController = newValue {
                if (mainViewContainer != nil) {
                    addViewToContainer(mainViewContainer, view: newViewController.view)
                }
            }
        }
    }
    
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var mainViewContainer: UIView!
    
    var isMenuOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let suppliedMenuViewController = menuViewController {
            println("adding menu")
            addViewToContainer(menuContainerView, view: suppliedMenuViewController.view)
        }
        
        if let suppliedMainViewController = menuViewController {
            addViewToContainer(mainViewContainer, view: suppliedMainViewController.view)
        }
    }
    
    // MARK: - Public API methods
    func openMenu() {
        if (!isMenuOpen) {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.mainViewContainer.frame.origin.x = self.view.frame.width - 50
            })
            
            isMenuOpen = true
        }
    }
    
    func closeMenu() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.mainViewContainer.frame.origin.x = 0
        })
        
        isMenuOpen = false
    }
    
    // MARK: - Actions
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Changed) {
            peekAtMenu(sender.translationInView(view).x)
        }
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            peekAtMenuTouchEnd(atTouchPosition: sender.locationInView(view))
        }
    }
    
    @IBAction func handleMainContainerTap(sender: UITapGestureRecognizer) {
        closeMenu()
    }
    
    // MARK: - Private methods
    private func addViewToContainer(container: UIView, view: UIView) {
        view.frame = container.frame
        
        for child in container.subviews {
            child.removeFromSuperview()
        }
        
        container.addSubview(view)
    }
    
    private func peekAtMenu(width: CGFloat) {
        mainViewContainer.frame.origin.x = width
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
