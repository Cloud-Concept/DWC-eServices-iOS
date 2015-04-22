//
//  DashboardViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DashboardViewController.h"
#import "UIViewController+ChildViewController.h"
#import "VisualforceWebviewViewController.h"
#import "Globals.h"
#import "Account.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addVisualForceViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addVisualForceViewController {
    VisualforceWebviewViewController *vfWebviewVC = [VisualforceWebviewViewController new];
    vfWebviewVC.returnURL = [NSString stringWithFormat:@"/apex/DWCPortal_DashboardMobile?accountId=%@",
                             [Globals currentAccount].Id];
    
    vfWebviewVC.navBarTitle = NSLocalizedString(@"navBarDashboardTitle", @"");
    vfWebviewVC.VFshowSlidingMenu = YES;
    
    [self addChildViewController:vfWebviewVC toView:self.contentView];
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
