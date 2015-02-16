//
//  MentionsViewController.m
//  Twitter
//
//  Created by Austin Oh on 2/16/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import "MentionsViewController.h"
#import "User.h"
#import "TweetComposeViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "TweetDetailViewController.h"
#import "ProfileViewController.h"

@interface MentionsViewController () <UITableViewDelegate, UITableViewDataSource, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) TweetCell *prototypeTweetCell;

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup navigation bar items
    self.navigationItem.title = @"Mentions";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweet)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // handle pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self onRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeTweetCell.tweet = self.tweets[indexPath.row];
    CGSize size = [self.prototypeTweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (TweetCell *)prototypeTweetCell {
    if (_prototypeTweetCell == nil ) {
        _prototypeTweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    
    return _prototypeTweetCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
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
    [[TwitterClient sharedInstance] mentionsTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
    }];
    
    [self.refreshControl endRefreshing];
    [self.tableView setHidden:NO];
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

- (void)onProfile:(User *)user {
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    [pvc setUser:user];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
