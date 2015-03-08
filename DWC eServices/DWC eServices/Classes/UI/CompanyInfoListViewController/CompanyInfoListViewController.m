//
//  CompanyInfoListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListViewController.h"
#import "CompanyInfoListTableViewCell.h"
#import "DWCCompanyInfo.h"
#import "FVCustomAlertView.h"
#import "SFRestAPI+Blocks.h"
#import "Account.h"
#import "ShareOwnership.h"
#import "HelperClass.h"

@interface CompanyInfoListViewController ()

@end

@implementation CompanyInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            [self loadCompanyShareholders];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCompanyShareholders {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            NSDictionary *shareholderDict = [recordDict objectForKey:@"Shareholder__r"];
            Account *shareholder;
            if (![shareholderDict isKindOfClass:[NSNull class]]) {
                shareholder = [[Account alloc] initAccount:[shareholderDict objectForKey:@"Id"]
                                                       Name:[shareholderDict objectForKey:@"Name"]];
            }
            
            [dataRows addObject:[[ShareOwnership alloc] initShareOwnership:[recordDict objectForKey:@"Id"]
                                                                NoOfShares:(NSNumber*)[recordDict objectForKey:@"No_of_Shares__c"]
                                                          OwnershipOfShare:(NSNumber*)[recordDict objectForKey:@"Ownership_of_Share__c"]
                                                         ShareholderStatus:[recordDict objectForKey:@"Shareholder_Status__c"]
                                                        OwnershipStartDate:[recordDict objectForKey:@"Ownership_Start_Date__c"]
                                                          OwnershipEndDate:[recordDict objectForKey:@"Ownership_End_Date__c"]
                                                               Shareholder:shareholder]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
}

- (UITableViewCell *)cellShareholdersForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    ShareOwnership *currentShareOwnership = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentShareOwnership.shareholder.name;
    cell.roleValueLabel.text = @"Shareholder";
    cell.shareOwnershipValueLabel.text = [NSString stringWithFormat:@"%@ %%",[HelperClass formatNumberToString:currentShareOwnership.ownershipOfShare FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2]];
    
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell;
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            cell = [self cellShareholdersForRowAtIndexPath:indexPath tableView:tableView];
            break;
        default:
            break;
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*EmployeeListViewController *employeeListVC = [EmployeeListViewController new];
     employeeListVC.currentDWCEmployee = [dwcEmployeesTypesArray objectAtIndex:indexPath.row];
     
     [self.navigationController pushViewController:employeeListVC animated:YES];*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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
