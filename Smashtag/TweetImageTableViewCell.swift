//
//  TweetImageTableViewCell.swift
//  Smashtag
//
//  Created by Paul Pfeiffer on 17/05/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit

class TweetImageTableViewCell: UITableViewCell {
    
    var imageUrl : NSURL? {
        didSet {
            tweetImage = nil
            fetchImage()
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tweetImageView: UIImageView! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var tweetImage: UIImage? {
        get { return tweetImageView.image }
        set {
            tweetImageView.image = newValue
            tweetImageView.sizeToFit()
            spinner?.stopAnimating()
            spinner.hidden = true
        }
    }
    
    private func fetchImage() {
        if let url = imageUrl {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if imageData != nil {
                            self.tweetImage = UIImage(data: imageData!)
                        } else {
                            self.tweetImage = nil
                        }
                    }
                }
            }
        }
    }
}
