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

@interface ViewStatementListViewController ()

@end

@implementation ViewStatementListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setNavigationBarTitle:NSLocalizedString(@"navBarStatementTitle", @"")];
    
    self.showSlidingMenu = NO;
    
    [self.tableView setDragDelegate:self refreshDatePermanentKey:@""];
    self.tableView.queryLimit = 15;
    
    [self.tableView triggerRefresh];
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
    
    restRequest = [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries freeZonePaymentsQueryWithLimit:self.tableView.
                                                                queryLimit offset:self.tableView.queryOffset]
                                                     failBlock:errorBlock
                                                 completeBlock:successBlock];
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
