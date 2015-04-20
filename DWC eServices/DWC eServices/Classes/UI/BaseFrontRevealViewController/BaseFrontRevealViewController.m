//
//  BaseFrontRevealViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "BaseFrontRevealViewController.h"
#import "SWRevealViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "Globals.h"

@interface BaseFrontRevealViewController ()

@end

@implementation BaseFrontRevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showSlidingMenu = YES;
    self.showNotificationIcon = YES;
    self.revealViewController.navigationController.navigationBarHidden = YES;
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self initNavigationItem];
    
    [self initTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationItem {
    if (self.showSlidingMenu)
        [self initSlidingMenu];
    
    if (self.showNotificationIcon)
        [self initNotificationIcon];
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
    
    UITabBarItem *servicesItem = [[UITabBarItem alloc] initWithTitle:@"SERVICES"
                                                               image:[UIImage imageNamed:@"TabBar Services Icon"]
                                                                 tag:3];
    
    UITabBarItem *reportsItem = [[UITabBarItem alloc] initWithTitle:@"REPORTS"
                                                              image:[UIImage imageNamed:@"TabBar Reports Icon"]
                                                                tag:4];
    
    UITabBarItem *dashboardItem = [[UITabBarItem alloc] initWithTitle:@"DASHBOARD"
                                                                image:[UIImage imageNamed:@"TabBar Dashboard Icon"]
                                                                  tag:5];
    
    NSArray *tabBarItem = @[homeItem, requestItem, servicesItem, reportsItem, dashboardItem];
    
    [self.bottomTabBar setItems:tabBarItem animated:YES];
    self.bottomTabBar.delegate = self;
    //self.bottomTabBar.hidden = YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch (item.tag) {
        case 1:
            [self openHomePage];
            break;
        case 2:
            [self openMyRequestsPage];
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

- (void)openNotificationsPage:(id)sender {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *notificationsVC = [storybord instantiateViewControllerWithIdentifier:@"Notifications Page"];
    [self.revealViewController setFrontViewController:notificationsVC animated:YES];
}

- (void)setNavigationBarTitle:(NSString *)title {
    [self.navigationItem setTitle:title];
}

- (void)refreshNotificationsCount {
    if (self.showNotificationIcon)
        [self initNotificationIcon];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
