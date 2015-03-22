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
#import "FVCustomAlertView.h"
#import "Request.h"
#import "RecordType.h"
#import "HelperClass.h"
#import "RelatedService.h"
#import "BaseServicesViewController.h"

@interface MyRequestListViewController ()

@end

@implementation MyRequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadMyRequests];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMyRequests {
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        NSMutableArray *mutableResults = [NSMutableArray new];
        for (NSDictionary *recordDict in records) {
            
            [mutableResults addObject:[[Request alloc] initRequest:recordDict]];
        }
        
        dataRows = [NSArray arrayWithArray:mutableResults];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            
            [self.requestsTableView reloadData];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
#warning Handle Error
        });
    };
    
    [self showLoadingDialog];
    
    NSString *query = [SOQLQueries myRequestsQuery];
    [[SFRestAPI sharedInstance] performSOQLQuery:query
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

- (void)openViewMyRequestFlow:(Request *)request {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = RelatedServiceTypeViewMyRequest;
    baseServicesVC.currentWebformId = request.webFormId;
    baseServicesVC.backAction = ^(void) {
        [self loadMyRequests];
    };
    [baseServicesVC initializeCaseId:request.Id];
    [self.navigationController pushViewController:baseServicesVC animated:YES];
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
    MyRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRequestTableViewCell"];
    
    if(!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyRequestTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    Request *currentRequest = [dataRows objectAtIndex:indexPath.row];
    
    cell.requestNumberLabel.text = currentRequest.caseNumber;
    cell.requestStatusLabel.text = currentRequest.status;
    cell.requestDateLabel.text = [HelperClass formatDateToString:currentRequest.createdDate];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Request *currentRequest = [dataRows objectAtIndex:indexPath.row];
    
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

@end
