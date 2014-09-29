//
//  SplashViewController.swift
//  twitter
//
//  Created by Dan Schultz on 9/27/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var twitterClient = TwitterClient.sharedInstance
    
    var initialTweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        // If the user isn't logged in, then they need to log in.
        
        // Otherwise, load the latest tweets, then go to the home view.
    }
    
    func finishAuthorizationWithParamsFromUrl(url: NSURL) {
        var authToken = BDBOAuthToken(queryString: url.query)
        twitterClient.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: authToken, success: handleAccessTokenSuccess, failure: handleAccessTokenFailure)
        
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func handleAccessTokenSuccess(accessToken: BDBOAuthToken!) {
        println("got the access token")
        twitterClient.requestSerializer.saveAccessToken(accessToken)
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        twitterClient.homeTimeline() { (tweets, error) in
            if (tweets != nil) {
                self.showTimelineView(tweets)
            }
        }
    }
    
    private func showTimelineView(tweets: [Tweet]) {
        initialTweets = tweets
        performSegueWithIdentifier("SplashToHomeTimeline", sender: self)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func handleAccessTokenFailure(error: NSError!) {
        println("error getting access token")
        println("\(error)")
//        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        var tempSender = sender as? UIViewController
        
        if (tempSender == self) {
            if (segue.identifier == "SplashToHomeTimeline") {
                var navigationController = segue.destinationViewController as UINavigationController
                var timelineViewController = navigationController.childViewControllers[0] as HomeTimelineViewController
                timelineViewController.tweets = initialTweets
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
