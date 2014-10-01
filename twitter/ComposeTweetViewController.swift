//
//  ComposeTweetViewController.swift
//  twitter
//
//  Created by Dan Schultz on 9/25/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var remainingCharsLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var messagePlaceholder: UILabel!
    
    var user: User {
        get {
            var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            return appDelegate.applicationModel.signedInUser!
        }
    }
    
    var initialMessage: String?
    var isReply: Bool?
    var isRetweet: Bool?
    var delegate: ComposeTweetViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.opaque = false
        
        updateControls()
        
        messageField.delegate = self
        messageField.becomeFirstResponder()
    }
    
    private func updateControls() {
        profileImage.setImageWithURL(user.profileImageUrl)
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName)"
        messageField.text = initialMessage != nil ? initialMessage : ""
        
        updateInputtedText()
    }
    
    private func updateInputtedText() {
        var charCount = countElements(messageField.text)
        messagePlaceholder.hidden = messageField.hasText()
        remainingCharsLabel.text = "\(140 - charCount)"
        postButton.enabled = charCount > 0 && charCount <= 140
    }
    
    // MARK: - Text view delegate methods
    func textViewDidChange(textView: UITextView) {
        updateInputtedText()
    }
    
    // MARK: - Actions
    @IBAction func handleCancelTap(sender: AnyObject) {
        delegate.composeTweetViewControllerDidCancel?()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleTweetTap(sender: AnyObject) {
        delegate.composeTweetViewControllerDidTweet(messageField.text, isRetweet: isRetweet ?? false, isReply: isReply ?? false)
        dismissViewControllerAnimated(true, completion: nil)
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
