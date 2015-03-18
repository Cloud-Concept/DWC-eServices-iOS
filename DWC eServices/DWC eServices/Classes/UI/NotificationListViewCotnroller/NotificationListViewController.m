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

@interface NotificationListViewController ()

@end

@implementation NotificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNotifications {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSMutableArray *notificationMutableArray = [NSMutableArray new];
        NSInteger notificationsCount = 0;
        
        for (NSDictionary *notificationDict in [dict objectForKey:@"records"]) {
            NSDictionary *requestDict = [notificationDict objectForKey:@"Case__r"];
            Request *request;
            if (![requestDict isKindOfClass:[NSNull class]]) {
                request = [[Request alloc] initRequestWithId:[requestDict objectForKey:@"Id"]
                                                      Number:[requestDict objectForKey:@"CaseNumber"]
                                                      Status:[requestDict objectForKey:@"Status"]
                                                   WebFormId:[requestDict objectForKey:@"Web_Form__c"]
                                                 RatingScore:[requestDict objectForKey:@"Case_Rating_Score__c"]
                                                 CreatedDate:[requestDict objectForKey:@"CreatedDate"]
                                              CaseRecordType:nil];
            }
            
            NotificationManagement *notification = [[NotificationManagement alloc]
                                                    initNotificationManager:[notificationDict objectForKey:@"Id"]
                                                    Name:[notificationDict objectForKey:@"Name"]
                                                    CaseStatus:[notificationDict objectForKey:@"Case_Status__c"]
                                                    CompiledMessage:[notificationDict objectForKey:@"Compiled_Message__c"]
                                                    NotificationMessage:[notificationDict objectForKey:@"Notification_Message__c"]
                                                    PriorValue:[notificationDict objectForKey:@"Prior_Value__c"]
                                                    ReadDateTime:[notificationDict objectForKey:@"Read_Date_and_Time__c"]
                                                    IsFeedbackAllowed:[[notificationDict objectForKey:@"isFeedbackAllowed__c"] boolValue]
                                                    IsMessageRead:[[notificationDict objectForKey:@"isMessageRead__c"] boolValue]
                                                    IsPushNotificationAllowed:[[notificationDict objectForKey:@"Is_Push_Notification_Allowed__c"] boolValue]
                                                    NotificationRequest:request];
            
            if (!notification.isMessageRead) {
                notificationsCount++;
            }
            
            [notificationMutableArray addObject:notification];
        }
        
        notificationsArray = [NSArray arrayWithArray:notificationMutableArray];
        [Globals setNotificationsCount:[NSNumber numberWithInteger:notificationsCount]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries notificationsQuery]
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
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NotificationManagement *currentNotification = [notificationsArray objectAtIndex:indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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