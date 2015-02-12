//
//  Tweet.m
//  Twitter
//
//  Created by Austin Oh on 2/6/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self ) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        NSString *create = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:create];
        
        NSInteger favoriteCount = dictionary[@"favorite_count"] ? [dictionary[@"favorite_count"] integerValue] : 0;
        NSInteger retweetCount = dictionary[@"retweet_count"] ? [dictionary[@"retweet_count"] integerValue] : 0;
        self.favoritesCount = favoriteCount;
        self.retweetCount = retweetCount;
        
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        
        self.tweetId = dictionary[@"id"];
    }
    
    return self;
}

+ (NSArray * )tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
        //NSLog(@"Tweets: %@", dictionary);
    }
    
    
    return tweets;
}

@end
