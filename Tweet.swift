//
//  Tweet.swift
//  Tweet
//
//  Created by Esteban Solis on 2/15/16.
//  Copyright © 2016 Esteban Solis. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User? // author
    var text: String?
    var retweetCount: Int?
    var likeCount: Int?
    var createdAtString: String?
    var createdAt: NSDate?
    var tweetID: String?
    var hasRetweeted = false
    var hasLiked = false
    var dictionary: NSDictionary
    var profileName: String?
    var at: String?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        retweetCount = dictionary["retweet_count"] as? Int
        likeCount = dictionary["favorite_count"] as? Int
        createdAtString = dictionary["created_at"] as? String // need to format date
        tweetID = dictionary["id_str"] as? String
        hasRetweeted = dictionary["retweeted"] as! Bool
        hasLiked = dictionary["favorited"] as! Bool
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        let test = NSDateFormatter()
        test.dateFormat = "h:mm a"
        //test.dateFormat = "M/d/yy - h:mm a"
        createdAtString = test.stringFromDate(createdAt!)
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
         
        
        return tweets
    }
    
}
