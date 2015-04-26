//
//  EmployeeTypeTableViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "EmployeeContainerViewController.h"
#import "EmployeeListViewController.h"
#import "SWRevealViewController.h"
#import "DWCEmployee.h"
#import "SOQLQueries.h"
#import "SwipePageViewController.h"
#import "UIViewController+ChildViewController.h"

@interface EmployeeContainerViewController ()

@end

@implementation EmployeeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:NSLocalizedString(@"navBarEmployeesTitle", @"")];
    
    dwcEmployeesTypesArray = [NSMutableArray new];
    
    [dwcEmployeesTypesArray addObject:[[DWCEmployee alloc] initDWCEmployee:NSLocalizedString(@"PermanentEmployee", @"")
                                                               NavBarTitle:NSLocalizedString(@"navBarPermanentEmployeeTitle", @"")
                                                           DWCEmployeeType:PermanentEmployee
                                                                     Query:[SOQLQueries permanentEmployeesQuery]]];
    
    [dwcEmployeesTypesArray addObject:[[DWCEmployee alloc] initDWCEmployee:NSLocalizedString(@"VisitVisaEmployee", @"")
                                                               NavBarTitle:NSLocalizedString(@"navBarVisitVisaTitle", @"")
                                                           DWCEmployeeType:VisitVisaEmployee
                                                                     Query:[SOQLQueries visitVisaEmployeesQuery]]];
    
    [dwcEmployeesTypesArray addObject:[[DWCEmployee alloc] initDWCEmployee:NSLocalizedString(@"ContractorEmployee", @"")
                                                               NavBarTitle:NSLocalizedString(@"navBarContractorTitle", @"")
                                                           DWCEmployeeType:ContractorEmployee
                                                                     Query:[SOQLQueries contractorsQuery]]];
    
    NSMutableArray *viewControllersMutableArray = [NSMutableArray new];
    NSMutableArray *pageLabelMutableArray = [NSMutableArray new];
    
    SwipePageViewController *swipePageVC = [SwipePageViewController new];
    for (DWCEmployee *dwcEmployee in dwcEmployeesTypesArray) {
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        EmployeeListViewController *employeeListVC = [storybord instantiateViewControllerWithIdentifier:@"Employee List Page"];
        employeeListVC.currentDWCEmployee = dwcEmployee;
        [viewControllersMutableArray addObject:employeeListVC];
        [pageLabelMutableArray addObject:dwcEmployee.Label];
    }
    
    swipePageVC.viewControllerArray = viewControllersMutableArray;
    swipePageVC.pageLabelArray = pageLabelMutableArray;
    
    [self addChildViewController:swipePageVC toView:self.containerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
