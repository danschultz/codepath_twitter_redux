//
//  AuthViewController.swift
//  twitter
//
//  Created by Dan Schultz on 9/27/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var twitterClient: TwitterClient = TwitterClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        fetchRequestToken()
    }
    
    @IBAction func handleCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchRequestToken() {
        twitterClient.requestSerializer.removeAccessToken()
        twitterClient.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth/authorized"), scope: nil, success: handleRequestTokenSuccess, failure: handleRequestTokenFailure)
    }
    
    private func handleRequestTokenSuccess(requestToken: BDBOAuthToken!) {
        println("got the request token")
        
        var authorizeUrl = NSURL(string: "\(twitterClient.baseURL)/oauth/authorize?oauth_token=\(requestToken.token)")
        var authorizeRequest = NSURLRequest(URL: authorizeUrl)
        webView.loadRequest(authorizeRequest)
    }
    
    private func handleRequestTokenFailure(error: NSError!) {
        println("failed to get request token: \(error)")
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
