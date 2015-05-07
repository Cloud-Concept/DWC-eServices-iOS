//
//  Request.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Request.h"
#import "HelperClass.h"
#import "SFDateUtil.h"
#import "RecordType.h"
#import "Account.h"

@implementation Request

- (id)initRequest:(NSDictionary *)requestDict {
    if (!(self = [super init]))
        return nil;
    
    if ([requestDict isKindOfClass:[NSNull class]] || requestDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[requestDict objectForKey:@"Id"]];
    self.caseNumber = [HelperClass stringCheckNull:[requestDict objectForKey:@"CaseNumber"]];
    self.status = [HelperClass stringCheckNull:[requestDict objectForKey:@"Status"]];
    self.type = [HelperClass stringCheckNull:[requestDict objectForKey:@"Type"]];
    self.subType = [HelperClass stringCheckNull:[requestDict objectForKey:@"Sub_Type__c"]];
    self.subTypeFormula = [HelperClass stringCheckNull:[requestDict objectForKey:@"Sub_Type_Formula__c"]];
    self.webFormId = [HelperClass stringCheckNull:[requestDict objectForKey:@"Web_Form__c"]];
    self.applicationRejectionReason = [HelperClass stringCheckNull:[requestDict objectForKey:@"Application_Rejection_Reason__c"]];
    
    
    self.caseRatingScore = [HelperClass numberCheckNull:[requestDict objectForKey:@"Case_Rating_Score__c"]];
    
    self.createdDate = [SFDateUtil SOQLDateTimeStringToDate:[requestDict objectForKey:@"CreatedDate"]];
    
    self.caseRecordType = [[RecordType alloc] initRecordType:[requestDict objectForKey:@"RecordType"]];
    self.employeeRef = [[Account alloc] initAccount:[requestDict objectForKey:@"Employee_Ref__r"]];
    
    return self;
}

- (id)initRequestWithId:(NSString *)caseId Number:(NSString *)Number Status:(NSString *)Status WebFormId:(NSString *)WebFormId CreatedDate:(NSString *)CreatedDate CaseRecordType:(RecordType *)CaseRecordType {
    return [self initRequestWithId:caseId
                            Number:Number
                            Status:Status
                         WebFormId:WebFormId
                       RatingScore:nil
                       CreatedDate:CreatedDate
                    CaseRecordType:CaseRecordType];
}

- (id)initRequestWithId:(NSString *)caseId Number:(NSString *)Number Status:(NSString *)Status WebFormId:(NSString *)WebFormId RatingScore:(NSNumber *)RatingScore CreatedDate:(NSString *)CreatedDate CaseRecordType:(RecordType *)CaseRecordType {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:caseId];
    self.caseNumber = [HelperClass stringCheckNull:Number];
    self.status = [HelperClass stringCheckNull:Status];
    self.webFormId = [HelperClass stringCheckNull:WebFormId];
    self.caseRatingScore = [HelperClass numberCheckNull:RatingScore];
    self.createdDate = [SFDateUtil SOQLDateTimeStringToDate:CreatedDate];
    self.caseRecordType = CaseRecordType;
    
    return self;

    
}

@end
