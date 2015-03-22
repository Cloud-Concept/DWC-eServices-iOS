//
//  CardManagement.m
//  DWCTest
//
//  Created by Mina Zaklama on 1/12/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "CardManagement.h"
#import "HelperClass.h"
#import "SFDateUtil.h"
#import "RecordType.h"
#import "Country.h"

@implementation CardManagement

- (id)initCardManagement:(NSDictionary *)cardManagementDict {
    if (!(self = [super init]))
        return nil;
    
    if ([cardManagementDict isKindOfClass:[NSNull class]] || cardManagementDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Name"]];
    self.personalPhoto = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Personal_Photo__c"]];
    self.cardNumber = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Card_Number__c"]];
    self.status = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Status__c"]];
    self.sponsor = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Sponsor__c"]];
    self.cardType = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Card_Type__c"]];
    self.salutation = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Salutation__c"]];
    self.fullName = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Full_Name__c"]];
    self.designation = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Designation__c"]];
    self.duration = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Duration__c"]];
    self.passportNumber = [HelperClass stringCheckNull:[cardManagementDict objectForKey:@"Passport_Number__c"]];
    
    if (![[cardManagementDict objectForKey:@"Card_Expiry_Date__c"] isKindOfClass:[NSNull class]])
        self.cardExpiryDate = [SFDateUtil SOQLDateTimeStringToDate:[HelperClass stringCheckNull:
                                                                    [cardManagementDict objectForKey:@"Card_Expiry_Date__c"]]];
    
    if (![[cardManagementDict objectForKey:@"Card_Issue_Date__c]"] isKindOfClass:[NSNull class]])
        self.cardIssueDate = [SFDateUtil SOQLDateTimeStringToDate:[HelperClass stringCheckNull:
                                                                   [cardManagementDict objectForKey:@"Card_Issue_Date__c"]]];
    
    self.recordType = [[RecordType alloc] initRecordType:[cardManagementDict objectForKey:@"RecordType"]];
    self.nationality = [[Country alloc] initCountry:[cardManagementDict objectForKey:@"Nationality__r"]];
    
    return self;
}

- (id)initCardManagement:(NSString*)Id Name:(NSString*)Name PersonalPhoto:(NSString*)PersonalPhoto CardNumber:(NSString*)CardNumber Status:(NSString*)Status Sponsor:(NSString*)Sponsor CardType:(NSString*)CardType Salutation:(NSString*)Salutation FullName:(NSString*)FullName Designation:(NSString*)Designation Duration:(NSString*)Duration CardExpiryDate:(NSString*)CardExpiryDate CardIssueDate:(NSString*)CardIssueDate PassportNumber:(NSString*)PassportNumber RecordType:(RecordType*)RecordType Nationality:(Country*)Nationality {
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:Id];
    self.name = [HelperClass stringCheckNull:Name];
    self.personalPhoto = [HelperClass stringCheckNull:PersonalPhoto];
    self.cardNumber = [HelperClass stringCheckNull:CardNumber];
    self.status = [HelperClass stringCheckNull:Status];
    self.sponsor = [HelperClass stringCheckNull:Sponsor];
    self.cardType = [HelperClass stringCheckNull:CardType];
    self.salutation = [HelperClass stringCheckNull:Salutation];
    self.fullName = [HelperClass stringCheckNull:FullName];
    self.designation = [HelperClass stringCheckNull:Designation];
    self.duration = [HelperClass stringCheckNull:Duration];
    self.passportNumber = [HelperClass stringCheckNull:PassportNumber];
    
    if ([CardExpiryDate isKindOfClass:[NSNull class]])
        self.cardExpiryDate = nil;
    else
        self.cardExpiryDate = [SFDateUtil SOQLDateTimeStringToDate:CardExpiryDate];
    
    if ([CardIssueDate isKindOfClass:[NSNull class]])
        self.cardIssueDate = [NSDate new];
    else
        self.cardIssueDate = [SFDateUtil SOQLDateTimeStringToDate:CardIssueDate];
    
    self.recordType = RecordType;
    self.nationality = Nationality;
    
    return self;
}

@end
