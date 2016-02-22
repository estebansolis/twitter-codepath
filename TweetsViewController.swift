//
//  TweetsViewController.swift
//  Tweet
//
//  Created by Esteban Solis on 2/21/16.
//  Copyright © 2016 Esteban Solis. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 170
       
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) ->() in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onLogOut(sender: AnyObject) {
        User.currentUser?.logout()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell",forIndexPath: indexPath) as! TweetsCell
        cell.textLabel!.text = "row \(indexPath.row)"
        
        let tweet = self.tweets![indexPath.row]
        let profileImageURL = NSURL(string: (tweet.user?.profileImageUrl)!)
        cell.profileImage.setImageWithURL(profileImageURL!)
       
        cell.tweet = tweet
        cell.usernameLabel.text = tweet.user?.name
       // print(cell.usernameLabel.text)
        cell.handlenameLabel.text = "@" + (tweet.user?.screenName)!
        cell.textLabel!.text = tweet.text
        cell.timeLabel.text = tweet.createdAtString
        cell.retweetLabel.text = String(tweet.retweetCount!)
        cell.likeLabel.text = String(tweet.likeCount!)

        let retweetTapAction = UITapGestureRecognizer(target: self, action: "retweet:")
        cell.replyImageView.tag = indexPath.row
        cell.replyImageView.userInteractionEnabled = true
        cell.replyImageView.addGestureRecognizer(retweetTapAction)
        if tweet.hasRetweeted{
            cell.replyImageView.highlighted = true
        }
        
        let likeTapAction = UITapGestureRecognizer(target: self, action: "like:")
        cell.likeImageView.tag = indexPath.row
        cell.likeImageView.userInteractionEnabled = true
        cell.likeImageView.addGestureRecognizer(likeTapAction)
        if tweet.hasLiked{
            cell.likeImageView.highlighted = true
        }
        
      
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func retweet(sender: UITapGestureRecognizer){
        if sender.state != .Ended{
            return
        }
        
        let index = sender.view?.tag
        if let index = index{
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TweetsCell
            if (!cell.tweet!.hasRetweeted){
                TwitterClient.sharedInstance.retweet(tweets![index].tweetID!, params: nil, completion: { (response, error) -> () in
                    if (error == nil){
                        self.tweets![index].retweetCount! += 1
                        self.tweets![index].hasRetweeted = true
                        cell.retweetLabel!.text = String(Int(cell.retweetLabel.text!)! + 1)
                        cell.tweet!.hasRetweeted = true
                        cell.replyImageView.highlighted = true
                    }else{
                        print("Retweet failed: \(error!.description)")
                    }
                })
            }
        }
    }
    
    func like(sender: UITapGestureRecognizer){
        if sender.state != .Ended{
            return
        }
        
        let index = sender.view?.tag
        if let index = index{
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TweetsCell
            if (!cell.tweet!.hasRetweeted){
                TwitterClient.sharedInstance.like(tweets![index].tweetID!, params: nil, completion: { (response, error) -> () in
                    if (error == nil){
                        self.tweets![index].likeCount! += 1
                        self.tweets![index].hasLiked = true
                        cell.likeLabel!.text = String(Int(cell.likeLabel.text!)! + 1)
                        cell.tweet!.hasLiked = true
                        cell.likeImageView.highlighted = true
                    }else{
                        print("Like failed: \(error!.description)")
                    }
                })
            }
        }
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
