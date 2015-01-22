//
//  HomePageViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/21/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "HomePageViewController.h"
#import "HelperClass.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home NavBar DWC Logo"]];
    
    [HelperClass setupButtonWithTextUnderImage:self.dashboardButton];
    [HelperClass setupButtonWithTextUnderImage:self.employeesButton];
    [HelperClass setupButtonWithTextUnderImage:self.myRequestButton];
    [HelperClass setupButtonWithTextUnderImage:self.notificationButton];
    [HelperClass setupButtonWithTextUnderImage:self.quickAccessButton];
    [HelperClass setupButtonWithTextUnderImage:self.needHelpButton];
    [HelperClass setupButtonWithTextUnderImage:self.logoutButton];
    [HelperClass setupButtonWithTextUnderImage:self.reportsButton];
    [HelperClass setupButtonWithTextUnderImage:self.servicesButton];
    
    [HelperClass setupButtonWithBadgeOnImage:self.notificationButton Value:40];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
