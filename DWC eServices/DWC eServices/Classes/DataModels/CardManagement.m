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

@implementation CardManagement

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
