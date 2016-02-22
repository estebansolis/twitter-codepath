//
//  TweetsCell.swift
//  Tweet
//
//  Created by Esteban Solis on 2/21/16.
//  Copyright © 2016 Esteban Solis. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handlenameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var replyImageView: UIImageView!
    
    var tweets: [Tweet]?
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.sizeToFit()
      //  handlenameLabel.sizeToFit()
        // Initialization code
        profileImage.layer.cornerRadius = 8.0
        profileImage.clipsToBounds = true
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
