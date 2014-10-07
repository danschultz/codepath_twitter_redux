//
//  MenuViewController.swift
//  twitter
//
//  Created by Dan Schultz on 10/4/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    let menuOptions = [
        ["title": "Profile"],
        ["title": "Profile"],
        ["title": "Timeline"],
        ["title": "Mentions"],
        ["title": "Sign Out"]
    ]
    
    var user: User!
    
    var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationController?.setNavigationBarToTwitterPrimaryColors()
    }
    
    // MARK: - Table view options
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier("ProfileViewCell") as MenuProfileTableViewCell
            cell.fullNameLabel.text = user.name
            cell.screenNameLabel.text = "@\(user.screenName)"
            cell.profileImage.setImageWithURL(user.profileImageUrl)
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell") as MenuItemTableViewCell
            cell.titleLabel.text = menuOptions[indexPath.row]["title"]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let providedDelegate = delegate {
            providedDelegate.menuViewControllerDidSelectOption(menuOptions[indexPath.row])
        }
    }

}
