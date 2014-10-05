//
//  SplashViewController.swift
//  twitter
//
//  Created by Dan Schultz on 9/27/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var twitterClient = TwitterClient.sharedInstance
    var settings = Settings.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var headerTextColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor(red: 46 / 255, green: 154 / 255, blue: 234, alpha: 1.0)
        navigationController?.navigationBar.tintColor = headerTextColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : headerTextColor
        ]
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        // If the user has already logged in, then load the newest tweets and go to the home timeline view
        if (settings.apiAccessToken != nil) {
            handleAccessTokenSuccess(settings.apiAccessToken)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func finishAuthorizationWithParamsFromUrl(url: NSURL) {
        var authToken = BDBOAuthToken(queryString: url.query)
        twitterClient.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: authToken, success: handleAccessTokenSuccess, failure: handleAccessTokenFailure)
        
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func handleAccessTokenSuccess(accessToken: BDBOAuthToken!) {
        settings.apiAccessToken = accessToken
        settings.save()
        
        twitterClient.requestSerializer.saveAccessToken(accessToken)
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        loadSignedInUser() { (user) in
            user.reloadTimeline(self.twitterClient) { (tweets, error) in
                self.showMainView()
            }
        }
    }
    
    private func showMainView() {
        performSegueWithIdentifier("SplashToMain", sender: self)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func handleAccessTokenFailure(error: NSError!) {
        println("error getting access token")
        println("\(error)")
    }
    
    func loadSignedInUser(handler: (User!) -> Void) {
        twitterClient.verifyAccountCredentials() { (user, error) in
            self.appDelegate.applicationModel.signedInUser = user
            handler(user)
        }
    }
    
    func signOut() {
        settings.apiAccessToken = nil
        settings.save()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        var tempSender = sender as? UIViewController
        
        if (tempSender == self) {
            if (segue.identifier == "SplashToMain") {
//                var navigationController = segue.destinationViewController as UINavigationController
//                var timelineViewController = navigationController.childViewControllers[0] as HomeTimelineViewController
//                timelineViewController.tweets = initialTweets
            }
        }
    }
    
    @IBAction func unwindToSplash(segue: UIStoryboardSegue) {
        signOut()
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
