//
//  ProfileViewController.swift
//  twitter
//
//  Created by Dan Schultz on 10/5/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarToTwitterPrimaryColors()
        tableView.rowHeight = UITableViewAutomaticDimension
        updateControls()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCounterCell") as ProfileCounterTableViewCell
        cell.user = user
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 60
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    private func updateControls() {
        if let profileBannerUrl = user.profileBannerUrl {
            backgroundImage.setImageWithURL(profileBannerUrl)
        }
        profileImage.setImageWithURL(user.profileImageUrl)
        realNameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName)"
    }

}
