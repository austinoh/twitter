//
//  TweetCell.m
//  Twitter
//
//  Created by Austin Oh on 2/8/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import <NSDate+MinimalTimeAgo.h>

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)onReplyTap:(id)sender;
- (IBAction)onRetweetTap:(id)sender;
- (IBAction)onFavoriteTap:(id)sender;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.nameLabel.text = self.tweet.user.name;
    self.screenLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetLabel.text = self.tweet.text;
    self.timeLabel.text = [self.tweet.createdAt timeAgo];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}


- (IBAction)onReplyTap:(id)sender {
    
}

- (IBAction)onRetweetTap:(id)sender {
}

- (IBAction)onFavoriteTap:(id)sender {
}

@end
