//
//  EmployeeTypeTableViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "EmployeeTypeViewController.h"
#import "EmployeeListViewController.h"
#import "SWRevealViewController.h"
#import "DWCEmployee.h"
#import "SOQLQueries.h"

@interface EmployeeTypeViewController ()

@end

@implementation EmployeeTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dwcEmployeesTypesArray = [NSMutableArray new];
    
    [dwcEmployeesTypesArray addObject:[[DWCEmployee alloc] initDWCEmployee:@"Permanent Employee"
                                                           DWCEmployeeType:PermanentEmployee
                                                                     Query:[SOQLQueries permanentEmployeesQuery]]];
    
    [dwcEmployeesTypesArray addObject:[[DWCEmployee alloc] initDWCEmployee:@"Visit Visa"
                                                           DWCEmployeeType:VisitVisaEmployee
                                                                     Query:[SOQLQueries visitVisaEmployeesQuery]]];
    
    [dwcEmployeesTypesArray addObject:[[DWCEmployee alloc] initDWCEmployee:@"Access Card"
                                                           DWCEmployeeType:ContractorEmployee
                                                                     Query:[SOQLQueries contractorsQuery]]];
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
    return dwcEmployeesTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Employee Type Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    DWCEmployee *employeeType = [dwcEmployeesTypesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = employeeType.Label;
    
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
    if ([destinationVC isKindOfClass:[EmployeeListViewController class]]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
        ((EmployeeListViewController*)destinationVC).currentDWCEmployee = [dwcEmployeesTypesArray objectAtIndex:selectedIndexPath.row];
    }
}


@end
