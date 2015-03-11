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
            
            [notificationMutableArray addObject:[[NotificationManagement alloc]
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
                                                 NotificationRequest:request]];
        }
        
        notificationsArray = [NSArray arrayWithArray:notificationMutableArray];
        
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
    
    [cell.notificationLabel setAttributedText:[currentNotification getAttributedNotificationMessage]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationManagement *currentNotification = [notificationsArray objectAtIndex:indexPath.row];
    
    [self openViewMyRequestFlow:currentNotification.request];
    
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


//SELECT ID,isFeedbackAllowed__c, Case__r.Case_Rating_Score__c, Case__c, Case__r.AccountId, Case__r.CaseNumber, Case_Process_Name__c, Case_Status__c, isMessageRead__c, Is_Push_Notification_Allowed__c, Notification_Message__c, Prior_Value__c, Read_Date_and_Time__c FROM Notification_Management__c WHERE Case__r.AccountId = '%@' AND Is_Push_Notification_Allowed__c = TRUE ORDER BY CreatedDate DESC


