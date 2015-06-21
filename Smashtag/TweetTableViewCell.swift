//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Paul Pfeiffer on 26/04/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    func updateUI() {
        tweetTextLabel.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        //tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet {
            let text = NSMutableAttributedString(string: tweet.text)
            
            for h in tweet.hashtags {
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: h.nsrange)
            }
            for h in tweet.urls {
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: h.nsrange)
            }
            for h in tweet.userMentions {
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor.purpleColor(), range: h.nsrange)
            }
            tweetTextLabel?.attributedText = text
            //            if tweetTextLabel?.text != nil {
            //                for _ in tweet.media {
            //                    tweetTextLabel.text! += " 📷"
            //                }
            //            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        if imageData != nil {
                            self.tweetProfileImageView?.image = UIImage(data: imageData!)
                        } else {
                            self.tweetProfileImageView?.image = nil
                        }
                    }
                }
            }
        }
    }
}
