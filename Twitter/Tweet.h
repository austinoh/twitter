//
//  Tweet.h
//  Twitter
//
//  Created by Austin Oh on 2/6/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) NSInteger retweetCount;
@property BOOL favorited;
@property BOOL retweeted;
@property (nonatomic, strong) NSString *tweetId;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray * )tweetsWithArray:(NSArray *)array;

@end
