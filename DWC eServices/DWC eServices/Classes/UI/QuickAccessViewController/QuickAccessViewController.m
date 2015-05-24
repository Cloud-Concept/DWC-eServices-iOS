//
//  QuickAccessViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/17/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "QuickAccessViewController.h"
#import "BaseServicesViewController.h"
#import "UIButton+Additions.h"
#import "DWCEmployee.h"
#import "SOQLQueries.h"
#import "DWCSFRequestManager.h"
#import "Visa.h"

@interface QuickAccessViewController ()

@end

@implementation QuickAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setNavigationBarTitle:NSLocalizedString(@"navBarQuickAccessTitle", @"")];
    
    [self.companyNOCButton setupButtonWithTextUnderImage];
    [self.cardNewButton setupButtonWithTextUnderImage];
    [self.employeeNOCButton setupButtonWithTextUnderImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)companyNOCButtonClicked:(id)sender {
    [self openNewNOCFlow:RelatedServiceTypeNewCompanyNOC visaObject:nil];
}

- (IBAction)employeeNOCButtonClicked:(id)sender {
    [self openSelectEmployeeVC];
}

- (IBAction)cardNewButtonClicked:(id)sender {
    [self openNewNOCFlow:RelatedServiceTypeNewCard visaObject:nil];
}

- (void)openNewNOCFlow:(RelatedServiceType)serviceType visaObject:(Visa *)visaObject {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = serviceType;
    baseServicesVC.currentVisaObject = visaObject;
    baseServicesVC.createServiceRecord = YES;
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)openSelectEmployeeVC {
    DWCEmployee *dwcEmployee = [[DWCEmployee alloc] initDWCEmployee:NSLocalizedString(@"PermanentEmployee", @"")
                                                        NavBarTitle:NSLocalizedString(@"navBarPermanentEmployeeTitle", @"")
                                                    DWCEmployeeType:PermanentEmployee
                                                              Query:[SOQLQueries permanentEmployeesQuery]
                                                           CacheKey:kPermanentEmployeeCacheKey
                                                         ObjectType:@"Visa__c"
                                                        ObjectClass:[Visa class]];
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    EmployeeListViewController *employeeListVC = [storybord instantiateViewControllerWithIdentifier:@"Employee List Page"];
    employeeListVC.currentDWCEmployee = dwcEmployee;
    employeeListVC.isSelectEmployee = YES;
    employeeListVC.selectEmployeeDelegate = self;
    employeeListVC.hideFilter = YES;
    
    [self.navigationController pushViewController:employeeListVC animated:YES];

}

#pragma Mark EmployeeListSelectEmployeeDelegate
- (void)didSelectVisaEmployee:(Visa *)selectedVisa {
    [self.navigationController popViewControllerAnimated:YES];
    
    [self openNewNOCFlow:RelatedServiceTypeNewEmployeeNOC visaObject:selectedVisa];
}

- (void)didSelectCardEmployee:(CardManagement *)selectedCard {
    
}

@end
