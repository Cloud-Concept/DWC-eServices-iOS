//
//  MyRequestListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/2/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "MyRequestListViewController.h"
#import "MyRequestTableViewCell.h"
#import "SFRestAPI+Blocks.h"
#import "SOQLQueries.h"
#import "Request.h"
#import "RecordType.h"
#import "HelperClass.h"
#import "RelatedService.h"
#import "BaseServicesViewController.h"
#import "PickerTableViewController.h"

@interface MyRequestListViewController ()

@end

@implementation MyRequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setNavigationBarTitle:NSLocalizedString(@"navBarMyRequestTitle", @"")];
    
    [self initializeFiltersArrays];
    [self refreshStatusFilterButton];
    [self refreshServiceFilterButton];
    [self initializeSearchBar];
    
    [self.requestsTableView setDragDelegate:self refreshDatePermanentKey:@""];
    self.requestsTableView.queryLimit = 15;
    
    [self.requestsTableView triggerRefresh];
    //[self loadMyRequests];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)statusFilterButtonClicked:(id)sender {
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = statusFilterStringArray;
    pickerTableVC.selectedIndexPath = selectedStatusFilterIndexPath;
    pickerTableVC.valuePicked = ^(NSString * value, NSIndexPath * indexPath, PickerTableViewController *picklist) {
        selectedStatusFilterIndexPath = indexPath;
        selectedStatusFilter = value;
        [self refreshStatusFilterButton];
        [picklist dismissPopover:YES];
        [self refreshRequestsTable];
    };
    
    [pickerTableVC showPopoverFromView:sender];
}

- (IBAction)serviceFilterButtonClicked:(id)sender {
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = serviceFilterStringArray;
    pickerTableVC.selectedIndexPath = selectedServiceFilterIndexPath;
    pickerTableVC.valuePicked = ^(NSString * value, NSIndexPath * indexPath, PickerTableViewController *picklist) {
        selectedServiceFilterIndexPath = indexPath;
        selectedServiceFilter = value;
        [self refreshServiceFilterButton];
        [picklist dismissPopover:YES];
        [self refreshRequestsTable];
    };
    
    [pickerTableVC showPopoverFromView:sender];
}

- (void)initializeSearchBar {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.showsScopeBar = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[@""];
    
    self.requestsTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    searchBarText = @"";
}

- (void)initializeFiltersArrays {
    statusFilterStringArray = @[@"All", @"Completed", @"In Process", @"Ready for collection", @"Not Submitted"];
    selectedStatusFilter = @"All";
    selectedStatusFilterIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    serviceFilterStringArray = @[@"All", @"Visa Services", @"NOC Services", @"License Services", @"Access Card Services", @"Registration Services", @"Leasing Services"];
    selectedServiceFilter = @"All";
    selectedServiceFilterIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)refreshStatusFilterButton {
    [self.statusFilterButton setTitle:selectedStatusFilter forState:UIControlStateNormal];
}

- (void)refreshServiceFilterButton {
    [self.serviceFilterButton setTitle:selectedServiceFilter forState:UIControlStateNormal];
}

- (void)refreshRequestsTable {
    NSString *predicateString = [self getPredicateString];
    
    if ([predicateString isEqualToString:@""]) {
        filteredRequestsArray = [NSMutableArray arrayWithArray:dataRows];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        filteredRequestsArray = [NSMutableArray arrayWithArray:[dataRows filteredArrayUsingPredicate:predicate]];
    }
    
    [self.requestsTableView reloadData];
}

- (NSString *)getPredicateString {
    NSMutableString *predicateString = [NSMutableString new];
    NSString *statusFilterPredicate = @"";
    NSString *serviceFilterPredicate = @"";
    
    if (![selectedStatusFilter isEqualToString:@"All"])
        statusFilterPredicate = [NSMutableString stringWithFormat:@"status == '%@'", selectedStatusFilter];
    
    if (![selectedServiceFilter isEqualToString:@"All"])
        serviceFilterPredicate = [NSMutableString stringWithFormat:@"type == '%@'", selectedServiceFilter];
    
    
    if (![statusFilterPredicate isEqualToString:@""] && ![serviceFilterPredicate isEqualToString:@""])
        predicateString = [NSMutableString stringWithFormat:@"%@ AND %@", statusFilterPredicate, serviceFilterPredicate];
    else if ([statusFilterPredicate isEqualToString:@""] && ![serviceFilterPredicate isEqualToString:@""])
        predicateString = [NSMutableString stringWithString:serviceFilterPredicate];
    else if (![statusFilterPredicate isEqualToString:@""] && [serviceFilterPredicate isEqualToString:@""])
        predicateString = [NSMutableString stringWithString:statusFilterPredicate];
    
    if (![searchBarText isEqualToString:@""]) {
        NSString *nameFilter = [NSString stringWithFormat:@"caseNumber contains[c] '%@'", searchBarText];
        if ([predicateString isEqualToString:@""])
            predicateString = [NSMutableString stringWithString:nameFilter];
        else
            predicateString = [NSMutableString stringWithFormat:@"%@ AND %@", predicateString, nameFilter];
    }
    
    return predicateString;
}

- (void)loadMyRequestsRefresh:(BOOL)isRefresh {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        if (isRefresh)
            dataRows = [NSArray new];
        
        NSMutableArray *mutableResults = [NSMutableArray arrayWithArray:dataRows];
        for (NSDictionary *recordDict in records) {
            
            [mutableResults addObject:[[Request alloc] initRequest:recordDict]];
        }
        
        dataRows = [NSArray arrayWithArray:mutableResults];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.requestsTableView finishRefresh];
            else
                [self.requestsTableView finishLoadMore];
            
            [self refreshRequestsTable];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.requestsTableView finishRefresh];
            else
                [self.requestsTableView finishLoadMore];
        });
    };
    
    NSString *query = [SOQLQueries myRequestsQueryWithLimit:self.requestsTableView.queryLimit
                                                     offset:self.requestsTableView.queryOffset];
    
    restRequest = [[SFRestAPI sharedInstance] performSOQLQuery:query
                                                     failBlock:errorBlock
                                                 completeBlock:successBlock];
}

- (void)openViewMyRequestFlow:(Request *)request {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = RelatedServiceTypeViewMyRequest;
    baseServicesVC.currentWebformId = request.webFormId;
    baseServicesVC.backAction = ^(void) {
        [self tableRefresh];
    };
    [baseServicesVC initializeCaseId:request.Id];
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)tableLoadMore {
    self.requestsTableView.queryOffset += self.requestsTableView.queryLimit;
    [self loadMyRequestsRefresh:NO];
}

- (void)tableRefresh {
    self.requestsTableView.queryOffset = 0;
    [self loadMyRequestsRefresh:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return filteredRequestsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRequestTableViewCell"];
    
    if(!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyRequestTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    Request *currentRequest = [filteredRequestsArray objectAtIndex:indexPath.row];
    [cell displayValueForRequest:currentRequest];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Request *currentRequest = [filteredRequestsArray objectAtIndex:indexPath.row];
    
    [self openViewMyRequestFlow:currentRequest];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UISearchResultsUpdating delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    searchBarText = searchController.searchBar.text;
    [self refreshRequestsTable];
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

@end
