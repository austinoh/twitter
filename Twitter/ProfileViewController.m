//
//  ProfileViewController.m
//  Twitter
//
//  Created by Austin Oh on 2/14/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TweetComposeViewController.h"
#import "TweetDetailViewController.h"
#import "ProfileCell.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"


@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) TweetCell *prototypeTweetCell;
@property (nonatomic, strong) ProfileCell *prototypeProfileCell;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    User *user = self.user ? self.user : [User currentUser];
    
    if (!self.user) {

        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
        navLabel.text = user.name;
        navLabel.textAlignment = NSTextAlignmentCenter;
        navLabel.textColor = [UIColor whiteColor];
        navLabel.font = [UIFont boldSystemFontOfSize:17.0f];    // default font for consistency
        [navLabel setUserInteractionEnabled:YES];
        self.navigationItem.titleView = navLabel;
    } else {
        self.navigationItem.title = user.name;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweet)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // handle pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    if (user) {
        [self onRefresh];
    }
}

#pragma mask - TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 ) {
        ProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];

        User *user;
        
        if (self.user) {
            user = self.user;
        } else {
            user = [User currentUser];
        }
        
        [profileCell setUser:user];
        
        return profileCell;
    } else {
        TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        tweetCell.tweet = self.tweets[indexPath.row - 1];
        tweetCell.delegate = self;
        
        // if data for the last cell is requested, then obtain more data
        if (indexPath.row == self.tweets.count - 1) {
            [self getMoreTweets];
        }
        
        return tweetCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // do nothing if profile cell
    if (indexPath.row == 0) {
        return;
    }
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    
    vc.tweet = self.tweets[indexPath.row - 1];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (TweetCell *)prototypeTweetCell {
    if (_prototypeTweetCell == nil ) {
        _prototypeTweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    
    return _prototypeTweetCell;
}

- (ProfileCell *)prototypeProfileCell {
    if (_prototypeProfileCell == nil ) {
        _prototypeProfileCell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    }
    
    return _prototypeProfileCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGSize size = [self.prototypeProfileCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    } else {
        self.prototypeTweetCell.tweet = self.tweets[indexPath.row];
        CGSize size = [self.prototypeTweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    }
}

- (void)tweetCell:(TweetCell *)cell didPressButton:(NSInteger)buttonID {
    switch (buttonID) {
        case 1: { // reply tap
            TweetComposeViewController *vc = [[TweetComposeViewController alloc] init];
            vc.replyTweet = cell.tweet;
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nvc animated:YES completion:nil];
            break;
        }
        case 2: { // retweet tap
            break;
        }
        case 3: { // favorite tap
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private methods

- (void)onLogout {
    [User logout];
}

- (void)onNewTweet {
    TweetComposeViewController *vc = [[TweetComposeViewController alloc] init];
    vc.replyTweet = nil;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];

}

- (void)onRefresh {
    [[TwitterClient sharedInstance] userTimelineWithParams:nil user:self.user completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
    }];
    
    [self.refreshControl endRefreshing];
    [self.tableView setHidden:NO];
}

- (void) getMoreTweets {
    // if no previous max id str available, then don't do anything
    NSString *maxIdStr = [self.tweets[self.tweets.count - 1] idStr];
    if (!maxIdStr) {
        return;
    }
    [[TwitterClient sharedInstance] userTimelineWithParams:@{ @"max_id": maxIdStr} user:self.user completion:^(NSArray *tweets, NSError *error) {
        // reload only if there is more data
        if (error) {
        } else if (tweets.count > 0) {
            // ignore duplicate requests
            if ([[tweets[tweets.count - 1] idStr] isEqualToString:[self.tweets[self.tweets.count - 1] idStr]]) {
                NSLog(@"Ignoring duplicate data");
            } else {
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tweets];
                [temp addObjectsFromArray:tweets];
                self.tweets = [temp copy];
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"No more tweets retrieved");
        }
    }];
}

- (void)onProfile:(User *)user {

    NSString *profileScreenName = self.user ? self.user.screenName : [[User currentUser] screenName];

    if ([user.screenName isEqualToString:profileScreenName]) {

        CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
        anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
        anim.autoreverses = YES ;
        anim.repeatCount = 2.0f ;
        anim.duration = 0.07f ;
        
        [self.view.layer addAnimation:anim forKey:nil];
        return;
    }
    
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    [pvc setUser:user];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
