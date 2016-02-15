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
    class var sharedInstance: TwitterClient {
        struct Static{
            static let instance =  TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecert)
        }
        return Static.instance
        
    }

}
