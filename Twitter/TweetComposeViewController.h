//
//  TweetComposeViewController.h
//  Twitter
//
//  Created by Austin Oh on 2/11/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetComposeViewController : UIViewController
@property (nonatomic, strong) Tweet *replyTweet;
@end
