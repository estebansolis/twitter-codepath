//
//  TwitterClient.swift
//  Tweet
//
//  Created by Esteban Solis on 2/14/16.
//  Copyright © 2016 Esteban Solis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "zgypaktZJl0K4IjagHeam0yv2"
let twitterConsumerSecert = "Ps5Z9vmewApVTR165Rho9BmI7uTmudsstWfhqD7knNeKCXSwsO"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")



class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static{
            static let instance =  TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecert)
        }
        return Static.instance
    
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) ->()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error:NSError!) -> Void in
                print("Error getting home time line")
                completion(tweets: nil, error: error)
        })
    }
    
    func retweet(tweetID: String,params: NSDictionary?, completion: (response: NSDictionary?,error: NSError?) -> ()){
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(tweetID).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(response: response as? NSDictionary,error: nil)
            })
            { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                completion(response: nil,error: error)
        }
    }
    
    func like(tweetID: String,params: NSDictionary?, completion: (response: NSDictionary?,error: NSError?) -> ()){
        TwitterClient.sharedInstance.POST("https://api.twitter.com/1.1/favorites/create.json?id=\(tweetID)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(response: response as? NSDictionary,error: nil)
            })
            { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                completion(response: nil,error: error)
        }
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        // Fetch Request Token & redirect to authorization page
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got request token.")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request Token")
                
        }
    }
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:
            BDBOAuth1Credential!) -> Void in
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user // persist user as current user
                self.loginCompletion?(user: user, error: nil)
                //print("user: \(response)")
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            }) { (error: NSError!) -> Void in
                print("Error getting access token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
}
