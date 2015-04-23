//
//  ViewStatementListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ViewStatementListViewController.h"
#import "FreeZonePayment.h"
#import "SFRestAPI+Blocks.h"
#import "SOQLQueries.h"
#import "ViewStatementTableViewCell.h"
#import "HelperClass.h"
#import "PickerTableViewController.h"
#import "SFDateUtil.h"

@interface ViewStatementListViewController ()

@end

@implementation ViewStatementListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setNavigationBarTitle:NSLocalizedString(@"navBarStatementTitle", @"")];
    
    [self initializeFilterStringArray];
    
    [self.tableView setDragDelegate:self refreshDatePermanentKey:@""];
    self.tableView.queryLimit = 15;
    
    [self.tableView triggerRefresh];
    
    [HelperClass formatDatesForFilterOperation:@"" startDate:nil endDate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableLoadMore {
    self.tableView.queryOffset += self.tableView.queryLimit;
    [self loadPaymentsRefresh:NO];
}

- (void)tableRefresh {
    self.tableView.queryOffset = 0;
    [self loadPaymentsRefresh:YES];
}

- (void)loadPaymentsRefresh:(BOOL)isRefresh {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.tableView finishRefresh];
            else
                [self.tableView finishLoadMore];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        if (isRefresh)
            paymentsArray = [NSArray new];
        
        NSMutableArray *paymentsMutableArray = [NSMutableArray arrayWithArray:paymentsArray];
        
        for (NSDictionary *freeZonePaymentDict in [dict objectForKey:@"records"]) {
            FreeZonePayment *payment = [[FreeZonePayment alloc]
                                                    initFreeZonePayment:freeZonePaymentDict];
            
            [paymentsMutableArray addObject:payment];
        }
        
        paymentsArray = [NSArray arrayWithArray:paymentsMutableArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.tableView finishRefresh];
            else
                [self.tableView finishLoadMore];
            
            [self.tableView reloadData];
        });
        
    };
    
    NSString *datesFilter = [self constructDateRangeFilter];
    
    restRequest = [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries freeZonePaymentsQueryWithLimit:self.tableView.
                                                                queryLimit offset:self.tableView.queryOffset datesFilter:datesFilter]
                                                     failBlock:errorBlock
                                                 completeBlock:successBlock];
}

- (void)refreshFilterButton {
    [self.filterButton setTitle:selectedFilter forState:UIControlStateNormal];
}

- (void)initializeFilterStringArray {
    selectedFilterIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    filterStringArray = @[@"Current Quarter", @"Last Quarter", @"Current Year", @"Last Year", @"All Time"];
    
    selectedFilter = [filterStringArray objectAtIndex:selectedFilterIndexPath.row];
    
    [self refreshFilterButton];
}

- (NSString *)constructDateRangeFilter {
    NSString *queryFilter = @"";
    
    if (![selectedFilter isEqualToString:@"All Time"]) {
        NSDate *startDate = [NSDate date];
        NSDate *endDate = [NSDate date];
        
        [HelperClass formatDatesForFilterOperation:selectedFilter startDate:&startDate endDate:&endDate];
        
        NSString *startDateString = [SFDateUtil toSOQLDateTimeString:startDate isDateTime:YES];
        NSString *endDateString = [SFDateUtil toSOQLDateTimeString:endDate isDateTime:YES];
        
        queryFilter = [NSString stringWithFormat:@"CreatedDate >= %@ AND CreatedDate <= %@", startDateString, endDateString];
    }
    
    return queryFilter;
}

- (IBAction)filterButtonClicked:(id)sender {
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = filterStringArray;
    pickerTableVC.selectedIndexPath = selectedFilterIndexPath;
    pickerTableVC.valuePicked = ^(NSString * value, NSIndexPath * indexPath, PickerTableViewController *picklist) {
        selectedFilterIndexPath = indexPath;
        selectedFilter = value;
        [self refreshFilterButton];
        [picklist dismissPopover:YES];
        [self.tableView triggerRefresh];
    };
    
    [pickerTableVC showPopoverFromView:sender];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return paymentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FreeZonePayment *currentPayment = [paymentsArray objectAtIndex:indexPath.row];
    
    ViewStatementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewStatementTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell displayValueForPayment:currentPayment];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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
