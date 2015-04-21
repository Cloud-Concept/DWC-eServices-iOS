//
//  NotificationListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NotificationListViewController.h"
#import "FVCustomAlertView.h"
#import "SFRestAPI+Blocks.h"
#import "SOQLQueries.h"
#import "Request.h"
#import "RecordType.h"
#import "NotificationManagement.h"
#import "NotificationTableViewCell.h"
#import "BaseServicesViewController.h"
#import "Request.h"
#import "SFDateUtil.h"
#import "Globals.h"
#import "HelperClass.h"
#import "Account.h"

@interface NotificationListViewController ()

@end

@implementation NotificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setNavigationBarTitle:NSLocalizedString(@"navBarNotificationTitle", @"")];
    
    [self.tableView setDragDelegate:self refreshDatePermanentKey:@""];
    self.tableView.queryLimit = 15;
    
    shouldMarkAllAsRead = NO;
    [self.tableView triggerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNotificationsRefresh:(BOOL)isRefresh {
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
            notificationsArray = [NSArray new];
        
        NSMutableArray *notificationMutableArray = [NSMutableArray arrayWithArray:notificationsArray];
        NSInteger notificationsCount = 0;
        
        for (NSDictionary *notificationDict in [dict objectForKey:@"records"]) {
            NotificationManagement *notification = [[NotificationManagement alloc]
                                                    initNotificationManager:notificationDict];
            
            if (!notification.isMessageRead) {
                notificationsCount++;
            }
            
            [notificationMutableArray addObject:notification];
        }
        
        notificationsArray = [NSArray arrayWithArray:notificationMutableArray];
        //[Globals setNotificationsCount:[NSNumber numberWithInteger:notificationsCount]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRefresh)
                [self.tableView finishRefresh];
            else
                [self.tableView finishLoadMore];
            
            [self.tableView reloadData];
        });
        
    };
    
    restRequest = [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries notificationsQueryWithLimit:self.tableView.
                                                                queryLimit offset:self.tableView.queryOffset]
                                                     failBlock:errorBlock
                                                 completeBlock:successBlock];
}

- (void)openViewMyRequestFlow:(Request *)request {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    baseServicesVC.relatedServiceType = RelatedServiceTypeViewMyRequest;
    baseServicesVC.currentWebformId = request.webFormId;
    [baseServicesVC initializeCaseId:request.Id];
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (void)setNotificationAsRead:(NotificationManagement *)notification AtIndexPath:(NSIndexPath *)indexPath {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
#warning Handle Error
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            notification.isMessageRead = YES;
            
            [Globals setNotificationsCount:[NSNumber numberWithInteger:[[Globals notificationsCount] integerValue] - 1]];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [self openViewMyRequestFlow:notification.request];
        });
        
    };
    
    NSMutableDictionary *fields = [NSMutableDictionary new];
    [fields setObject:[NSNumber numberWithBool:YES] forKey:@"isMessageRead__c"];
    
    NSString *dateString = [SFDateUtil toSOQLDateTimeString:[NSDate date] isDateTime:true];
    
    dateString = [dateString stringByReplacingOccurrencesOfString:@" am" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" pm" withString:@""];
    
    [fields setObject:dateString forKey:@"Read_Date_and_Time__c"];
    
    [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Notification_Management__c"
                                                   objectId:notification.Id
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)tableLoadMore {
    self.tableView.queryOffset += self.tableView.queryLimit;
    [self loadNotificationsRefresh:NO];
}

- (void)tableRefresh {
    if (shouldMarkAllAsRead)
        [self callNotificationsReadWebservice];
    else {
        self.tableView.queryOffset = 0;
        [self loadNotificationsRefresh:YES];
    }
    shouldMarkAllAsRead = YES;
}

- (void)callNotificationsReadWebservice {
    
    NotificationManagement *firstItem = nil;
    
    if (notificationsArray.count > 0)
        firstItem = [notificationsArray objectAtIndex:0];
    
    // Manually set up request object
    restRequest = [[SFRestRequest alloc] init];
    restRequest.endpoint = @"/services/apexrest/MobileNotificationsReadWebService";
    restRequest.method = SFRestMethodGET;
    restRequest.path = @"/services/apexrest/MobileNotificationsReadWebService";
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjects:@[[Globals currentAccount].Id,
                                                                                   [NSNumber numberWithInteger:self.tableView.queryLimit]]
                                                                         forKeys:@[@"AccountId", @"Limit"]];
    
    if (firstItem)
        [paramsDict setObject:[SFDateUtil toSOQLDateTimeString:firstItem.createdDate isDateTime:YES]
                       forKey:@"CreatedDate"];
    
    restRequest.queryParams = paramsDict;
    
    [[SFRestAPI sharedInstance] send:restRequest delegate:self];
}

- (void)handleNotificationsReadWebService:(id)jsonResponse {
    NSString *returnValue = [[NSString alloc] initWithData:jsonResponse encoding:NSUTF8StringEncoding];
    NSLog(@"request:didLoadResponse: %@", returnValue);
    
    [Globals setNotificationsCount:[NSNumber numberWithInteger:0]];
    
    [self refreshNotificationsCount];
    
    [self loadNotificationsRefresh:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return notificationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationManagement *currentNotification = [notificationsArray objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = currentNotification.isFeedbackAllowed ? @"Notification Feedback Cell" : @"Notification Cell";
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell refreshCellForNotification:currentNotification];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationManagement *currentNotification = [notificationsArray objectAtIndex:indexPath.row];
    
    if (currentNotification.isMessageRead)
        [self openViewMyRequestFlow:currentNotification.request];
    else
        [self setNotificationAsRead:currentNotification AtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationManagement *currentNotification = [notificationsArray objectAtIndex:indexPath.row];
    
    return currentNotification.isFeedbackAllowed? 104.0 : 80;
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

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", dict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([request.path containsString:@"MobileNotificationsReadWebService"])
            [self handleNotificationsReadWebService:jsonResponse];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView finishRefresh];
    });
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
