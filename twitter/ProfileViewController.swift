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
    var applicationModel: Application!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarToTwitterPrimaryColors()
        navigationItem.title = applicationModel.signedInUser == user ? "Me" : user.name
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TweetTableViewCell")
        
        user.reloadUserTimeline(TwitterClient.sharedInstance) { (tweets, error) -> Void in
            if (error == nil) {
                self.tableView.reloadData()
            }
        }
        
        updateControls()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return user.userTimeline?.count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCounterCell") as ProfileCounterTableViewCell
            cell.user = user
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as TweetTableViewCell
            cell.tweet = user.userTimeline?[indexPath.row]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 60
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            performSegueWithIdentifier("ProfileToTweet", sender: user.userTimeline?[indexPath.row])
        }
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ProfileToTweet") {
            var tweetController = segue.destinationViewController as TweetViewController
            tweetController.tweet = sender as Tweet
        }
    }
    
    // MARK: - Private API
    private func updateControls() {
        if let profileBannerUrl = user.profileBannerUrl {
            backgroundImage.setImageWithURL(profileBannerUrl)
        }
        profileImage.setImageWithURL(user.profileImageUrl)
        realNameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName)"
    }

}
