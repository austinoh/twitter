//
//  TweetCell.h
//  Twitter
//
//  Created by Austin Oh on 2/8/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>
- (void)tweetCell:(TweetCell *)cell didPressButton:(NSInteger)buttonId;
@end

@interface TweetCell : UITableViewCell
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) id<TweetCellDelegate> delegate;
@end
