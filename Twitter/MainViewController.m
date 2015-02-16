//
//  MainViewController.m
//  Twitter
//
//  Created by Austin Oh on 2/14/15.
//  Copyright (c) 2015 Austin Oh. All rights reserved.
//

#import "MainViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIViewController *currentView;
@property (strong, nonatomic) NSArray *viewControllers;

- (void)initControllers;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self initControllers];
    [self.tableView reloadData];
    //[self.tableView setHidden:YES];
}

- (void)initControllers {
    
    // Profile
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    UINavigationController *pnvc = [[UINavigationController alloc] initWithRootViewController:pvc];
    pnvc.navigationBar.translucent = NO;
    pnvc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    pnvc.navigationBar.tintColor = [UIColor whiteColor];
    [pnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Home Timeline
    TweetsViewController *tvc = [[TweetsViewController alloc] init];
    UINavigationController *tnvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    tnvc.navigationBar.translucent = NO;
    tnvc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    tnvc.navigationBar.tintColor = [UIColor whiteColor];
    [tnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Mentions
    MentionsViewController *mvc = [[MentionsViewController alloc] init];
    UINavigationController *mnvc = [[UINavigationController alloc] initWithRootViewController:mvc];
    mnvc.navigationBar.translucent = NO;
    mnvc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    mnvc.navigationBar.tintColor = [UIColor whiteColor];
    [mnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.viewControllers = [NSArray arrayWithObjects:pnvc, tnvc, mnvc, nil];
    
    self.currentView = tnvc;
    
    [self setContentController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self removeCurrentViewController];
    self.currentView = self.viewControllers[indexPath.row];
    [self setContentController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.bounds.size.height / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Profile";
            break;
        case 1:
            cell.textLabel.text = @"Timeline";
            break;
        case 2:
            cell.textLabel.text = @"Mentions";
            break;
    }

    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    
    return cell;
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    CGRect frame = self.currentView.view.frame;
    frame.origin.x = translation.x;
    
    self.currentView.view.frame = frame;
    
    if (sender.state == UIGestureRecognizerStateBegan) {

    } else if (sender.state == UIGestureRecognizerStateChanged) {

    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            CGRect frame = self.currentView.view.frame;
            frame.origin.x = 120;

            [UIView animateWithDuration:0.5 animations:^{
                self.currentView.view.frame = frame;
                [self.tableView setHidden:NO];
            }];

            /*
            [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:0.1 options:UIViewAnimationOptionAutoreverse animations:^{
                self.currentView.view.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
            */
        } else {
            CGRect frame = self.currentView.view.frame;
            frame.origin.x = 0;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.currentView.view.frame = frame;
                [self.tableView setHidden:YES];
            }];
        }
    }
}

#pragma mark - View Controll methods

- (void)removeCurrentViewController {
}

- (void)setContentController {
//    self.currentView.view.frame = self.contentView.bounds;
    
    [self.tableView setHidden:YES];
    self.currentView.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.currentView.view];
//    [self.currentView didMoveToParentViewController:self];
    
/*    [UIView animateWithDuration:.24 animations:^{
        self.contentViewXConstraint.constant = 0;
        self.contentViewYConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
 */
}


@end
