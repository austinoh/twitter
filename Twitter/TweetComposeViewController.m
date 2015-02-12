//
//  TweetComposeViewController.m
//  Twitter
//
//  Created by Austin Oh on 2/11/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import "TweetComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation TweetComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onSendTweet)];
    
    self.navigationItem.title = @"140";
    
    self.nameLabel.text = [User currentUser].name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", [User currentUser].screenName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[User currentUser].profileImageUrl]];
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;

    
    self.tweetText.delegate = self;
    
    if (self.replyTweet) {
        self.tweetText.text = [NSString stringWithFormat:@"@%@",self.replyTweet.user.screenName];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView delegate methods

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger charCounter = 140 - [self.tweetText.text length];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld", charCounter];
}

#pragma mark - Private methods

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSendTweet {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if (self.replyTweet) {
        [params setObject:self.replyTweet.tweetId forKey:@"in_reply_to_status_id"];
    }
    
    [params setObject:self.tweetText.text forKey:@"status"];
    
    [[TwitterClient sharedInstance] postTweetWithParams:params completion:^(Tweet *tweet, NSError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Failed to post tweet: %@", error);
        }
    }];
}


@end
