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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    private func handleAccessTokenFailure(error: NSError!) {
        println("error getting access token")
        println("\(error)")
//        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
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
