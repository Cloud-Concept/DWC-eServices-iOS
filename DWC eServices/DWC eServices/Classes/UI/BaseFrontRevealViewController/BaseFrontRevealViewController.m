//
//  BaseFrontRevealViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "BaseFrontRevealViewController.h"
#import "SWRevealViewController.h"

@interface BaseFrontRevealViewController ()

@end

@implementation BaseFrontRevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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

- (void) initTabBar {
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
                                                                tag:1];
    
    UITabBarItem *servicesItem = [[UITabBarItem alloc] initWithTitle:@"SERVICES"
                                                               image:[UIImage imageNamed:@"TabBar Services Icon"]
                                                                 tag:1];
    
    UITabBarItem *reportsItem = [[UITabBarItem alloc] initWithTitle:@"REPORTS"
                                                              image:[UIImage imageNamed:@"TabBar Reports Icon"]
                                                                tag:1];
    
    UITabBarItem *dashboardItem = [[UITabBarItem alloc] initWithTitle:@"DASHBOARD"
                                                                image:[UIImage imageNamed:@"TabBar Dashboard Icon"]
                                                                  tag:1];
    
    NSArray *tabBarItem = @[homeItem, requestItem, servicesItem, reportsItem, dashboardItem];
    
    [self.bottomTabBar setItems:tabBarItem animated:YES];
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
