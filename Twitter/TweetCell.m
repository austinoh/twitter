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

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.nameLabel.text = self.tweet.user.name;
    self.screenLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetLabel.text = self.tweet.text;
    self.timeLabel.text = [self.tweet.createdAt timeAgo];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favoritesCount];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;

}

- (IBAction)onReplyTap:(id)sender {
    NSLog(@"Tap on reply button");
    [self.delegate tweetCell:self didPressButton:1];
}
- (IBAction)onRetweetTap:(id)sender {
    NSLog(@"Tap on retweet button");
    [self.delegate tweetCell:self didPressButton:2];
}
- (IBAction)onFavoriteTap:(id)sender {
    NSLog(@"Tap on favorite button");
    [self.delegate tweetCell:self didPressButton:3];
}

- (IBAction)onProfile:(id)sender {
    [self.delegate onProfile:_tweet.user];
}


@end
