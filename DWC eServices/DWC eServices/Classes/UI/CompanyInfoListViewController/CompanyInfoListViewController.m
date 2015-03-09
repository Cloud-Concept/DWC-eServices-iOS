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
#import "ManagementMember.h"
#import "Directorship.h"
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
        case DWCCompanyInfoGeneralManagers:
            [self loadCompanyManagers];
            break;
        case DWCCompanyInfoDirectors:
            [self loadCompanyDirectors];
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

- (void)loadCompanyManagers {
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
            NSDictionary *managerDict = [recordDict objectForKey:@"Manager__r"];
            Account *manager;
            if (![managerDict isKindOfClass:[NSNull class]]) {
                manager = [[Account alloc] initAccount:[managerDict objectForKey:@"Id"]
                                                      Name:[managerDict objectForKey:@"Name"]];
            }
            
            [dataRows addObject:[[ManagementMember alloc] initManagementMember:[recordDict objectForKey:@"Id"]
                                                                 ManagerStatus:[recordDict objectForKey:@"Manager_Status__c"]
                                                                          Role:[recordDict objectForKey:@"Role__c"]
                                                                        Status:[recordDict objectForKey:@"Status__c"]
                                                              ManagerStartDate:[recordDict objectForKey:@"Manager_Start_Date__c"]
                                                                ManagerEndDate:[recordDict objectForKey:@"Manager_End_Date__c"]
                                                                       Manager:manager]];
            
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

- (void)loadCompanyDirectors {
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
            NSDictionary *directorDict = [recordDict objectForKey:@"Director__r"];
            Account *director;
            if (![directorDict isKindOfClass:[NSNull class]]) {
                director = [[Account alloc] initAccount:[directorDict objectForKey:@"Id"]
                                                   Name:[directorDict objectForKey:@"Name"]];
            }
            
            [dataRows addObject:[[Directorship alloc] initDirectorship:[recordDict objectForKey:@"Id"]
                                                                 Roles:[recordDict objectForKey:@"Roles__c"]
                                                        DirectorStatus:[recordDict objectForKey:@"Director_Status__c"]
                                                 DirectorshipStartDate:[recordDict objectForKey:@"Directorship_Start_Date__c"]
                                                   DirectorshipEndDate:[recordDict objectForKey:@"Directorship_End_Date__c"]
                                                              Director:director]];
            
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

- (UITableViewCell *)cellManagersForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    ManagementMember *currentManagementMember = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentManagementMember.manager.name;
    cell.roleValueLabel.text = currentManagementMember.role;
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (UITableViewCell *)cellDirectorsForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    Directorship *currentDirectorship = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentDirectorship.director.name;
    cell.roleValueLabel.text = currentDirectorship.roles;
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
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
        case DWCCompanyInfoGeneralManagers:
            cell = [self cellManagersForRowAtIndexPath:indexPath tableView:tableView];
        case DWCCompanyInfoDirectors:
            cell = [self cellDirectorsForRowAtIndexPath:indexPath tableView:tableView];
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
