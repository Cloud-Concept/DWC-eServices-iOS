//
//  CompanyDocumentTypeViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyDocumentTypeViewController.h"
#import "DWCCompanyDocument.h"
#import "SOQLQueries.h"
#import "CompanyDocumentTypeListViewController.h"
#import "SwipePageViewController.h"
#import "UIViewController+ChildViewController.h"
#import "DWCSFRequestManager.h"
#import "EServicesDocumentChecklist.h"
#import "CompanyDocument.h"

@interface CompanyDocumentTypeViewController ()

@end

@implementation CompanyDocumentTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setNavigationBarTitle:NSLocalizedString(@"navBarCompanyDocumentsTitle", @"")];
    
    companyDocumentsTypesArray = [NSMutableArray new];
    
    [companyDocumentsTypesArray addObject:[[DWCCompanyDocument alloc]
                                           initDWCCompanyDocument:NSLocalizedString(@"DWCCompanyDocumentTypeDWCDocument", @"")
                                           NavBarTitle:NSLocalizedString(@"navBarDWCCompanyDocumentTypeDWCDocumentTitle", @"")
                                           DWCCompanyDocumentType:DWCCompanyDocumentTypeDWCDocument
                                           Query:[SOQLQueries dwcDocumentsQuery]
                                           CacheKey:kDWCDocumentCacheKey
                                           ObjectType:@"eServices_Document_Checklist__c"
                                           ObjectClass:[EServicesDocumentChecklist class]]];
    
    [companyDocumentsTypesArray addObject:[[DWCCompanyDocument alloc]
                                           initDWCCompanyDocument:NSLocalizedString(@"DWCCompanyDocumentTypeCustomerDocument", @"")
                                           NavBarTitle:NSLocalizedString(@"navBarDWCCompanyDocumentTypeCustomerDocumentTitle", @"")
                                           DWCCompanyDocumentType:DWCCompanyDocumentTypeCustomerDocument
                                           Query:[SOQLQueries customerDocumentsQuery]
                                           CacheKey:kCustomerDocumentCacheKey
                                           ObjectType:@"Company_Documents__c"
                                           ObjectClass:[CompanyDocument class]]];
    
    
    NSMutableArray *viewControllersMutableArray = [NSMutableArray new];
    NSMutableArray *pageLabelMutableArray = [NSMutableArray new];
    
    SwipePageViewController *swipePageVC = [SwipePageViewController new];
    for (DWCCompanyDocument *dwcCompanyDocument in companyDocumentsTypesArray) {
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        CompanyDocumentTypeListViewController *companyDocListVC = [storybord instantiateViewControllerWithIdentifier:@"Company Document List Page"];
        companyDocListVC.currentDocumentType = dwcCompanyDocument;
        [viewControllersMutableArray addObject:companyDocListVC];
        [pageLabelMutableArray addObject:dwcCompanyDocument.Label];
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
