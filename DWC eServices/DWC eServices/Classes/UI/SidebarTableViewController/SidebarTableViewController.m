//
//  SidebarTableViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "UIImageView+MaskImage.h"
#import "SFUserAccountManager.h"
#import "SWRevealViewController.h"
#import "VisualforceWebviewViewController.h"
#import "Globals.h"
#import "Account.h"

@interface SidebarTableViewController ()

@end

@implementation SidebarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"User Cell", @"Home Cell", @"Dashboard Cell", @"My Request Cell", @"Employees Cell", /*@"Services Cell",*/ @"Company Info Cell", @"Company Documents Cell", @"Need Help Cell", @"Logout Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            [self.revealViewController.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
            //[self showDashboards];
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[menuItems objectAtIndex:indexPath.row]
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (indexPath.row == 0) {
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:10];
        [imageView maskImageToCircle];
        
        SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
        
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:20];
        nameLabel.text = accountManager.currentUser.fullName;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 154 : 45;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // [segue.identifier isEqualToString:@""]
}
*/

@end
