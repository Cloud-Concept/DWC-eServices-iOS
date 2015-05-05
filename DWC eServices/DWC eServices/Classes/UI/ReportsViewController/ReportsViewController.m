//
//  ReportsViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/5/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ReportsViewController.h"
#import "MyRequestListViewController.h"
#import "ViewStatementListViewController.h"
#import "UIButton+Additions.h"

@interface ReportsViewController ()

@end

@implementation ReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.myRequestButton setupButtonWithTextUnderImage];
    [self.statementOfAccountButton setupButtonWithTextUnderImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myRequestButtonClicked:(id)sender {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseFrontRevealViewController *myRequestVC = [storybord instantiateViewControllerWithIdentifier:@"My Requests Inner Page"];
    //[self.revealViewController setFrontViewController:myRequestVC animated:YES];
    myRequestVC.hideSlidingMenu = YES;
    [self.navigationController pushViewController:myRequestVC animated:YES];
}

- (IBAction)statementOfAccountButtonClicked:(id)sender {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseFrontRevealViewController *viewStatementVC = [storybord instantiateViewControllerWithIdentifier:@"View Statement Inner Page"];
    //[self.revealViewController setFrontViewController:myRequestVC animated:YES];
    viewStatementVC.hideSlidingMenu = YES;
    [self.navigationController pushViewController:viewStatementVC animated:YES];
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
