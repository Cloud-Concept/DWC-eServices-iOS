//
//  CompanyInfoViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoTypeViewController.h"
#import "DWCCompanyInfo.h"
#import "CompanyInfoListViewController.h"
#import "SOQLQueries.h"

@interface CompanyInfoTypeViewController ()

@end

@implementation CompanyInfoTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dwcCompanyInfoTypesArray = [NSMutableArray new];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoCompanyAndLicense", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoCompanyAndLicense]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoLeasingInfo", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoLeasingInfo]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoShareholders", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoShareholders
                                         Query:[SOQLQueries companyShareholdersQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoDirectors", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoDirectors
                                         Query:[SOQLQueries companyDirectorsQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoGeneralManagers", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoGeneralManagers
                                         Query:[SOQLQueries companyManagersQuery]]];
    
    [dwcCompanyInfoTypesArray addObject:[[DWCCompanyInfo alloc]
                                         initDWCCompanyInfo:NSLocalizedString(@"DWCCompanyInfoLegalRepresentative", @"")
                                         DWCCompanyInfoType:DWCCompanyInfoLegalRepresentative
                                         Query:[SOQLQueries companyLegalRepresentativesQuery]]];
    
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
    return dwcCompanyInfoTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    DWCCompanyInfo *companyInfoType = [dwcCompanyInfoTypesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = companyInfoType.Label;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destinationVC = [segue destinationViewController];
    if ([destinationVC isKindOfClass:[CompanyInfoListViewController class]]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
        ((CompanyInfoListViewController*)destinationVC).currentDWCCompanyInfo = [dwcCompanyInfoTypesArray objectAtIndex:selectedIndexPath.row];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    BOOL shouldPerformSegue = YES;
    
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    if (index.row == 0) {
        shouldPerformSegue = NO;
    }
    
    return shouldPerformSegue;
}

@end
