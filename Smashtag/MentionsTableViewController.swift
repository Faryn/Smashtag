//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Paul Pfeiffer on 30/04/15.
//  Copyright (c) 2015 Paul Pfeiffer. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    private enum Thing {
        case Image(MediaItem)
        case Url(Tweet.IndexedKeyword)
        case Hashtag(Tweet.IndexedKeyword)
        case User(Tweet.IndexedKeyword)
        
        var content: String {
            switch self {
            case .Image(let image): return image.description
            case .Url(let url): return url.keyword
            case .Hashtag(let hashTag): return hashTag.keyword
            case .User(let user): return user.keyword
            }
        }
        
        var title : String {
            switch self {
            case .Hashtag(_): return "Hashtags"
            case .Image(_): return "Images"
            case .Url(_): return "URLs"
            case .User(_): return "Users"
            }
        }
    }
    
    private var things  = [[Thing]]()
    
    var tweet : Tweet? {
        didSet {
            title = tweet?.user.name
            if let newTweet = tweet {
                if !newTweet.media.isEmpty {
                    var items = [Thing]()
                    for item in newTweet.media{
                        items.append(Thing.Image(item))
                    }
                    things.append(items)
                }
                if !newTweet.urls.isEmpty {
                    var items = [Thing]()
                    for item in newTweet.urls{
                        items.append(Thing.Url(item))
                    }
                    things.append(items)
                }
                if !newTweet.hashtags.isEmpty {
                    var items = [Thing]()
                    for item in newTweet.hashtags{
                        items.append(Thing.Hashtag(item))
                    }
                    things.append(items)
                }
                if !newTweet.userMentions.isEmpty {
                    var items = [Thing]()
                    for item in newTweet.userMentions{
                        items.append(Thing.User(item))
                    }
                    things.append(items)
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return things.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let item = things[indexPath.section][indexPath.row]
        switch item {
        case .Image(let image):
            let cell = tableView.dequeueReusableCellWithIdentifier("image", forIndexPath: indexPath) as! TweetImageTableViewCell
                cell.imageUrl = image.url
                return cell

            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("text", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = item.content
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = things[indexPath.section][indexPath.row]
        switch item {
        case .Image(let image):
            return tableView.bounds.size.width / CGFloat(image.aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return things[section].first?.title
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = things[indexPath.section][indexPath.row]
        switch item {
        case .Url(let url):
            UIApplication.sharedApplication().openURL(NSURL(string: url.keyword)!)
        case .Image( _):
            break
        default:
            performSegueWithIdentifier("search", sender: tableView.cellForRowAtIndexPath(indexPath))
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController!
        }
        if let identifier = segue.identifier {
            switch identifier {
            case "search":
                let source = sender as? UITableViewCell
                if let ttvc = destination as? TweetTableViewController {
                    ttvc.searchText = source?.textLabel?.text
                }
            case "image":
                let source = sender as? TweetImageTableViewCell
                if let ivc = destination as? ImageViewController {
                    ivc.image = source?.tweetImage
                    print(source?.description, appendNewline: false)
                }
            default:break
            }
            
            
        }
    }
    

}
