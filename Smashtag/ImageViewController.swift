//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Paul Pfeiffer on 31/05/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController , UIScrollViewDelegate{

    
    private var imageView = UIImageView()
    
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            let scaleWidth = scrollView.frame.size.width / self.scrollView.contentSize.width
            let scaleHeight = scrollView.frame.size.height / self.scrollView.contentSize.height
            let minScale = min(scaleWidth, scaleHeight)
            scrollView.minimumZoomScale = minScale
            
            print(imageView.frame.size.width, appendNewline: false)
            print(imageView.image?.size.width, appendNewline: false)
            print(scrollView.contentSize.width, appendNewline: false)
            scrollView.maximumZoomScale = 1.0
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
