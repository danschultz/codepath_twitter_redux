//
//  MenuViewController.swift
//  twitter
//
//  Created by Dan Schultz on 10/4/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    let menuOptions = [["title": "Profile"], ["title": "Profile"], ["title": "Timeline"], ["title": "Mentions"]]
    
    var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view options
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier("ProfileViewCell") as MenuProfileTableViewCell
            cell.fullNameLabel.text = "Dan Schultz"
            cell.screenNameLabel.text = "@dan_schultz"
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
