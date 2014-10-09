//
//  ProfileViewController.swift
//  twitter
//
//  Created by Dan Schultz on 10/5/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    @IBOutlet weak var blackOverlayView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    
    var loadedBackgroundImage: UIImage!
    
    var user: User!
    var applicationModel: Application!
    
    // Just hardcoding this for now. The size is the height of the header.
    let originalContentOffset = CGFloat(-64)
    
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
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // Adjust the height of the header view when the user reaches the edges of the scroll view.
        var offsetY = originalContentOffset - scrollView.contentOffset.y
        headerViewTopConstraint.constant = min(-offsetY, 0)
        
        if (loadedBackgroundImage != nil) {
            var radius = max(0, min(10, Int(offsetY / 5)))
            backgroundImage.image = blurImageWithGpu(loadedBackgroundImage!, radius: radius)
            
            println(offsetY)
        }
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
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.section == 0) {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if (indexPath.section == 0) {
            return nil
        } else {
            return indexPath
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
            var request = NSURLRequest(URL: profileBannerUrl)
            backgroundImage.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
                self.handleBackgroundImageLoaded(image)
            }, failure: { (request, response, error) -> Void in
                // handle error
            })
        }
        profileImage.setImageWithURL(user.profileImageUrl)
        realNameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName)"
    }
    
    private func handleBackgroundImageLoaded(image: UIImage) {
        // resize the image to a smaller version, to make blurring faster
        var resizedImage = image.resizedImageToFitInSize(CGSize(width: 300, height: 300), scaleIfSmaller: true)
        
        loadedBackgroundImage = resizedImage
        backgroundImage.image = blurImageWithGpu(resizedImage, radius: 0)
    }
    
    private func blurImageWithGpu(image: UIImage, radius: Int) -> UIImage {
        var filter = GPUImageGaussianBlurFilter()
        filter.blurRadiusInPixels = CGFloat(radius)
        return filter.imageByFilteringImage(image)
    }

}
