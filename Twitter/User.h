//
//  User.h
//  Twitter
//
//  Created by Austin Oh on 2/6/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;


@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagLine;

- (id)initWithDictionary:(NSDictionary *)dictionary;


+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

+ (void)logout;

@end
