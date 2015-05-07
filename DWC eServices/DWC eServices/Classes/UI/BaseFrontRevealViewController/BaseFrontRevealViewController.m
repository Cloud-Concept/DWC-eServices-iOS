//
//  BaseFrontRevealViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "BaseFrontRevealViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "Globals.h"
#import "NSString+SFAdditions.h"
#import "HelperClass.h"

@interface BaseFrontRevealViewController ()

@end

@implementation BaseFrontRevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.hideSlidingMenu = NO;
    //self.hideNotificationIcon = NO;
    //self.hideBottomTabBar = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.revealViewController.navigationController.navigationBarHidden = YES;
    self.revealViewController.delegate = self;
    
    [self initTabBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initNavigationItem];
    
    self.revealViewController.delegate = self;
    
    if (self.hideBottomTabBar) {
        [self.bottomTabBar removeFromSuperview];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationItem {
    if (!self.hideSlidingMenu)
        [self initSlidingMenu];
    else if (!self.hideBackButton)
        [self initBackButton];
    
    if (!self.hideNotificationIcon)
        [self initNotificationIcon];
    else if (self.showLogoutButton)
        [self setLogoutNavBarButton];
}

- (void)initBackButton {
    UIBarButtonItem *sideMenuBarButton = [[UIBarButtonItem alloc] init];
    sideMenuBarButton.image = [UIImage imageNamed:@"Navigation Bar Back Button Icon"];
    sideMenuBarButton.tintColor = [UIColor whiteColor];
    
    [sideMenuBarButton setTarget: self];
    [sideMenuBarButton setAction: @selector(backButtonClicked:)];
    
    self.navigationItem.leftBarButtonItem = sideMenuBarButton;
}

- (void)initNotificationIcon {
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [customButton setImage:[UIImage imageNamed:@"Navigation Bar Notification Icon"] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(openNotificationsPage:) forControlEvents:UIControlEventTouchUpInside];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    barButton.badgeValue = [NSString stringWithFormat:@"%@", [Globals notificationsCount]];
    barButton.badgeBGColor = [UIColor colorWithRed:0.2156 green:0.749 blue:0.741 alpha:1];
    barButton.badgeFont = [UIFont fontWithName:@"CorisandeLight" size:8.0f];
    barButton.shouldHideBadgeAtZero = YES;
    
    //barButton.badgeOriginX = 13;
    //barButton.badgeOriginY = -9;
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)initSlidingMenu {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        UIBarButtonItem *sideMenuBarButton = [[UIBarButtonItem alloc] init];
        
        sideMenuBarButton.image = [UIImage imageNamed:@"NavBar Sidemenu Button Icon"];
        sideMenuBarButton.tintColor = [UIColor whiteColor];
        
        [sideMenuBarButton setTarget: self.revealViewController];
        [sideMenuBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        self.navigationItem.leftBarButtonItem = sideMenuBarButton;
    }
}

- (void)initTabBar {
    if (!self.bottomTabBar)
        return;
    
    self.bottomTabBar.barStyle = UIBarStyleBlack;
    
    self.bottomTabBar.backgroundColor = [UIColor colorWithRed:0.17f
                                                        green:0.15f
                                                         blue:0.12f
                                                        alpha:1.0f];
    
    UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"HOME"
                                                           image:[UIImage imageNamed:@"TabBar Home Icon"]
                                                             tag:1];
    
    UITabBarItem *requestItem = [[UITabBarItem alloc] initWithTitle:@"REQUEST"
                                                              image:[UIImage imageNamed:@"TabBar Request Icon"]
                                                                tag:2];
    
    UITabBarItem *reportsItem = [[UITabBarItem alloc] initWithTitle:@"REPORTS"
                                                              image:[UIImage imageNamed:@"TabBar Reports Icon"]
                                                                tag:3];
    
    UITabBarItem *dashboardItem = [[UITabBarItem alloc] initWithTitle:@"DASHBOARD"
                                                                image:[UIImage imageNamed:@"TabBar Dashboard Icon"]
                                                                  tag:4];
    
    NSArray *tabBarItem = @[homeItem, requestItem, reportsItem, dashboardItem];
    
    [self.bottomTabBar setItems:tabBarItem animated:YES];
    self.bottomTabBar.delegate = self;
    //self.bottomTabBar.hidden = YES;
}

- (void)backButtonClicked:(id)sender {
    if (self.navigationItemBackAction) {
        self.navigationItemBackAction();
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch (item.tag) {
        case 1:
            [self openHomePage];
            break;
        case 2:
            [self openMyRequestsPage];
            break;
        case 3:
            [self openReportsPage];
            break;
        case 4:
            [self openDashBoardPage];
            break;
        default:
            break;
    }
}

- (void)openHomePage {
    [self.revealViewController.navigationController popViewControllerAnimated:YES];
}

- (void)openMyRequestsPage {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *myRequestVC = [storybord instantiateViewControllerWithIdentifier:@"My Requests Page"];
    [self.revealViewController setFrontViewController:myRequestVC animated:YES];
}

- (void)openReportsPage {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *myRequestVC = [storybord instantiateViewControllerWithIdentifier:@"Reports Page"];
    [self.revealViewController setFrontViewController:myRequestVC animated:YES];
}

- (void)openDashBoardPage {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *myRequestVC = [storybord instantiateViewControllerWithIdentifier:@"Dashboard Page"];
    [self.revealViewController setFrontViewController:myRequestVC animated:YES];
}

- (void)openNotificationsPage:(id)sender {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *notificationsVC = [storybord instantiateViewControllerWithIdentifier:@"Notifications Page"];
    [self.revealViewController setFrontViewController:notificationsVC animated:YES];
}

- (void)setNavigationBarTitle:(NSString *)title {
    
    title = [title capitalizedString];
    
    [self.navigationItem setTitle:title];
}

- (void)refreshNotificationsCount {
    if (!self.hideNotificationIcon)
        [self initNotificationIcon];
}

- (void)setLogoutNavBarButton {
    UIBarButtonItem *logoutBarButtonItem = [UIBarButtonItem new];
    logoutBarButtonItem.image = [UIImage imageNamed:@"Navigation Bar Logout Icon"];
    logoutBarButtonItem.target = self;
    logoutBarButtonItem.action = @selector(logoutButtonClicked:);
    
    self.navigationItem.rightBarButtonItem = logoutBarButtonItem;
}

- (void)logoutButtonClicked:(id)sender {
    [HelperClass showLogoutConfirmationDialog:self];
}

#pragma mark - SWRevealViewControllerDelegate Protocol

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionRight) {
        UIView *lockingView = [[UIView alloc] initWithFrame:revealController.frontViewController.view.frame];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
        [lockingView addGestureRecognizer:tap];
        [lockingView setTag:1000];
        lockingView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.6];
        
        [revealController.frontViewController.view addSubview:lockingView];
    }
    else
        [[revealController.frontViewController.view viewWithTag:1000] removeFromSuperview];
}

@end
