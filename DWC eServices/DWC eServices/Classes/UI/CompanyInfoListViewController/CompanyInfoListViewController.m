//
//  CompanyInfoListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListViewController.h"
#import "CompanyInfoListTableViewCell.h"
#import "SFRestAPI+Blocks.h"
#import "Globals.h"
#import "Account.h"
#import "ShareOwnership.h"
#import "ManagementMember.h"
#import "Directorship.h"
#import "LegalRepresentative.h"
#import "TenancyContract.h"
#import "HelperClass.h"
#import "RelatedServicesBarScrollView.h"

@interface CompanyInfoListViewController ()

@end

@implementation CompanyInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[super setNavigationBarTitle:self.currentDWCCompanyInfo.NavBarTitle];
    
    //self.showSlidingMenu = NO;
    
    [self.tableView setDragDelegate:self refreshDatePermanentKey:@""];
    self.tableView.queryLimit = 15;
    
    [self.tableView triggerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRecordsRefresh:(BOOL)isRefresh {
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
        case DWCCompanyInfoGeneralManagers:
        case DWCCompanyInfoDirectors:
        case DWCCompanyInfoLegalRepresentative:
            [self loadCompanyRefresh:isRefresh];
            break;
        case DWCCompanyInfoLeasingInfo:
            [self loadTenancyContractsRefresh:isRefresh];
            break;
        default:
            break;
    }
}

- (void)loadCompanyRefresh:(BOOL)isRefresh {
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
            dataRows = [NSArray new];
        
        NSMutableArray *dataMutableArray = [NSMutableArray arrayWithArray:dataRows];
        
        for (NSDictionary *recordDict in records) {
            switch (self.currentDWCCompanyInfo.Type) {
                case DWCCompanyInfoShareholders:
                    [dataMutableArray addObject:[[ShareOwnership alloc] initShareOwnership:recordDict]];
                    break;
                case DWCCompanyInfoGeneralManagers:
                    [dataMutableArray addObject:[[ManagementMember alloc] initManagementMember:recordDict]];
                    break;
                case DWCCompanyInfoDirectors:
                    [dataMutableArray addObject:[[Directorship alloc] initDirectorship:recordDict]];
                    break;
                case DWCCompanyInfoLegalRepresentative:
                    [dataMutableArray addObject:[[LegalRepresentative alloc] initLegalRepresentative:recordDict]];
                    break;
                default:
                    break;
            }
        }
        
        dataRows = [NSArray arrayWithArray:dataMutableArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.tableView finishRefresh];
            else
                [self.tableView finishLoadMore];
            
            [self.tableView reloadData];
        });
    };
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[NSString stringWithFormat:self.currentDWCCompanyInfo.SOQLQuery,
                                                  self.tableView.queryLimit, self.tableView.queryOffset]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
}

- (void)loadTenancyContractsRefresh:(BOOL)isRefresh {
    restRequest = [[SFRestRequest alloc] init];
    restRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileTenantContractsWebService"];
    restRequest.method = SFRestMethodGET;
    restRequest.path = @"/services/apexrest/MobileTenantContractsWebService";
    
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjects:@[[Globals currentAccount].Id, [NSNumber numberWithInteger:self.tableView.queryLimit], [NSNumber numberWithInteger:self.tableView.queryOffset]]
                                                            forKeys:@[@"AccountId", @"Limit", @"Offset"]];
    
    restRequest.queryParams = paramsDict;
    
    [[SFRestAPI sharedInstance] send:restRequest delegate:self];
}

- (void)tableLoadMore {
    self.tableView.queryOffset += self.tableView.queryLimit;
    [self loadRecordsRefresh:NO];
}

- (void)tableRefresh {
    self.tableView.queryOffset = 0;
    [self loadRecordsRefresh:YES];
}

- (BOOL)isIndexPathExpanded:(NSIndexPath *)indexPath {
    return expandedRowIndexPath && expandedRowIndexPath.row == indexPath.row && expandedRowIndexPath.section == indexPath.section;
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
    NSMutableString *cellIdentifier = [NSMutableString new];
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            [cellIdentifier appendString:@"CompanyInfoListShareholderCell"];
            break;
        case DWCCompanyInfoLeasingInfo:
            [cellIdentifier appendString:@"CompanyInfoListLeasingCell"];
            break;
        case DWCCompanyInfoGeneralManagers:
        case DWCCompanyInfoDirectors:
        case DWCCompanyInfoLegalRepresentative:
            [cellIdentifier appendString:@"CompanyInfoListCell"];
            break;
        default:
            break;
    }
    
    if ([self isIndexPathExpanded:indexPath])
        [cellIdentifier appendString:@"Expanded"];
        
    
    CompanyInfoListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.parentViewController = self;
    
    [cell refreshCellForObject:[dataRows objectAtIndex:indexPath.row]
               companyInfo:self.currentDWCCompanyInfo
                     indexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* rows = [NSMutableArray arrayWithCapacity:2];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 95;
    
    if (self.currentDWCCompanyInfo.Type == DWCCompanyInfoShareholders) {
        rowHeight = 110;
    }
    
    if ([self isIndexPathExpanded:indexPath]) {
        rowHeight += kRelatedServicesScrollViewHeight;
    }
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", resultsArray);
    
    NSMutableArray *dataMutableArray = [NSMutableArray new];
    for (NSDictionary *recordDict in resultsArray) {
        [dataMutableArray addObject:[[TenancyContract alloc] initTenancyContract:recordDict]];
    }
    
    dataRows = [NSArray arrayWithArray:dataMutableArray];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
        
        [self.tableView reloadData];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
    });
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
