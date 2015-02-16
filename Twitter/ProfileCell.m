//
//  ProfileCell.m
//  Twitter
//
//  Created by Austin Oh on 2/15/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import "ProfileCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

@end

@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code

    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    
    NSString *bannerUrl = user.bannerUrl ? user.bannerUrl : user.backgroundImageUrl;
    [self.bannerImageView setImageWithURL:[NSURL URLWithString:bannerUrl]];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetCountLabel.text = [self getFriendlyCount:user.tweetCount];
    self.followingCountLabel.text = [self getFriendlyCount:user.followingCount];
    self.followerCountLabel.text = [self getFriendlyCount:user.followerCount];
}

- (NSString *) getFriendlyCount:(NSInteger)count {
    if (count >= 1000000) {
        return [NSString stringWithFormat:@"%.1fM", (double)count / 1000000];
    } else if (count >= 10000) {
        return [NSString stringWithFormat:@"%.1fK", (double)count / 1000];
    } else if (count >= 1000) {
        return [NSString stringWithFormat:@"%ld,%ld", (long)count / 1000, (long)count % 1000];
    } else {
        return [NSString stringWithFormat:@"%ld", (long)count];
    }
}

@end
