//
//  CompanyDocumentTypeListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyDocumentTypeListViewController.h"
#import "SFRestAPI+Blocks.h"
#import "FVCustomAlertView.h"
#import "DWCCompanyDocument.h"
#import "CompanyDocument.h"
#import "EServicesDocumentChecklist.h"
#import "CustomerDocumentTableViewCell.h"
#import "DWCDocumentTableViewCell.h"
#import "HelperClass.h"
#import "Globals.h"
#import "Account.h"
#import "TenancyContract.h"
#import "RelatedServicesBarScrollView.h"

@interface CompanyDocumentTypeListViewController ()

@end

@implementation CompanyDocumentTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setDragDelegate:self refreshDatePermanentKey:@""];
    self.tableView.queryLimit = 15;
    
    
    switch (self.currentDocumentType.Type) {
        case DWCCompanyDocumentTypeCustomerDocument:
            [self.tableView triggerRefresh];
            break;
        case DWCCompanyDocumentTypeDWCDocument:
            [self loadTenancyContract];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDocumentsRefresh:(BOOL)isRefresh {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.tableView finishRefresh];
            else
                [self.tableView finishLoadMore];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        if (isRefresh)
            dataRows = [NSMutableArray new];
        
        NSMutableArray *dataMutableArray = [NSMutableArray arrayWithArray:dataRows];
        
        for (NSDictionary *recordDict in records) {
            switch (self.currentDocumentType.Type) {
                case DWCCompanyDocumentTypeCustomerDocument:
                    [dataMutableArray addObject:[[CompanyDocument alloc] initCompanyDocument:recordDict]];
                    break;
                case DWCCompanyDocumentTypeDWCDocument:
                    [dataMutableArray addObject:[[EServicesDocumentChecklist alloc] initEServicesDocumentChecklist:recordDict]];
                    break;
                default:
                    break;
            }
        }
        
        dataRows = [NSMutableArray arrayWithArray:dataMutableArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.tableView finishRefresh];
            else
                [self.tableView finishLoadMore];
            
            [self.tableView reloadData];
        });
    };
    
    restRequest = [[SFRestAPI sharedInstance] performSOQLQuery:[NSString stringWithFormat:self.currentDocumentType.SOQLQuery,
                                                                self.tableView.queryLimit, self.tableView.queryOffset]
                                                     failBlock:errorBlock
                                                 completeBlock:successBlock];
}

- (void)loadTenancyContract {
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    SFRestRequest *tenantContractsRequest = [[SFRestRequest alloc] init];
    tenantContractsRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileTenantContractsWebService"];
    tenantContractsRequest.method = SFRestMethodGET;
    tenantContractsRequest.path = @"/services/apexrest/MobileTenantContractsWebService";
    tenantContractsRequest.queryParams = [NSDictionary dictionaryWithObject:[Globals currentAccount].Id forKey:@"AccountId"];
    
    [[SFRestAPI sharedInstance] send:tenantContractsRequest delegate:self];
}

- (UITableViewCell *)cellDWCCompanyDocumentForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    NSString *cellIdentifier = @"DWC Document Cell";
    
    if ([self isIndexPathExpanded:indexPath])
        cellIdentifier = @"DWC Document Cell Expanded";
    
    DWCDocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.parentViewController = self;
    
    EServicesDocumentChecklist *eServicesDocumentChecklist = [dataRows objectAtIndex:indexPath.row];
    
    [cell refreshCellForEServicesDocumentChecklist:eServicesDocumentChecklist
                           activeBCTenancyContract:activeBCTenancyContract
                                         indexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)cellCustomerCompanyDocumentForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    NSString *cellIdentifier = @"Customer Document Cell";
    
    if ([self isIndexPathExpanded:indexPath])
        cellIdentifier = @"Customer Document Cell Expanded";
    
    CustomerDocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                          forIndexPath:indexPath];
    cell.parentViewController = self;
    
    CompanyDocument *companyDocument = [dataRows objectAtIndex:indexPath.row];
    
    [cell refreshCellForCompanyDocument:companyDocument indexPath:indexPath];
    
    return cell;
}

- (void)tableLoadMore {
    self.tableView.queryOffset += self.tableView.queryLimit;
    [self loadDocumentsRefresh:NO];
}

- (void)tableRefresh {
    self.tableView.queryOffset = 0;
    [self loadDocumentsRefresh:YES];
}

- (BOOL)isIndexPathExpanded:(NSIndexPath *)indexPath {
    return expandedRowIndexPath && expandedRowIndexPath.row == indexPath.row && expandedRowIndexPath.section == indexPath.section;
}

- (void)refreshViewController {
    [self tableRefresh];
}

- (void)documentSelectetAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.selectDocumentDelegate)
        return;
    
    CompanyDocument *companyDocument = [dataRows objectAtIndex:indexPath.row];
    
    [self.selectDocumentDelegate didSelectCompanyDocument:companyDocument];
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
    UITableViewCell *cell;
    
    switch (self.currentDocumentType.Type) {
        case DWCCompanyDocumentTypeCustomerDocument:
            cell = [self cellCustomerCompanyDocumentForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyDocumentTypeDWCDocument:
            cell = [self cellDWCCompanyDocumentForRowAtIndexPath:indexPath tableView:tableView];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* rows = [NSMutableArray arrayWithCapacity:2];
    
    if (self.isSelectDocument) {
        [self documentSelectetAtIndexPath:indexPath];
        return;
    }
    
    if (expandedRowIndexPath)
        [rows addObject:expandedRowIndexPath];
    
    if ([self isIndexPathExpanded:indexPath])
        expandedRowIndexPath = nil;
    else {
        expandedRowIndexPath = indexPath;
        [rows addObject:indexPath];
    }
    
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 64;
    
    if ([self isIndexPathExpanded:indexPath])
        rowHeight += kRelatedServicesScrollViewHeight;
    
    return rowHeight;
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", resultsArray);
    
    activeBCTenancyContract = nil;
    for (NSDictionary *recordDict in resultsArray) {
        TenancyContract *tempTenancyContract = [[TenancyContract alloc] initTenancyContract:recordDict];
        
        if (tempTenancyContract.isBCContract)
            activeBCTenancyContract = tempTenancyContract;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        
        [self.tableView triggerRefresh];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
}

#pragma mark - Table view Drag Load
- (void)dragTableDidTriggerRefresh:(UITableView *)tableView {
    [self tableRefresh];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView {
    [restRequest cancel];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView {
    [self tableLoadMore];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView {
    [restRequest cancel];
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
