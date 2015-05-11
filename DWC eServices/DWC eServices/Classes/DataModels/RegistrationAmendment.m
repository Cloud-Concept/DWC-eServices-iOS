//
//  RegistrationAmendment.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RegistrationAmendment.h"
#import "SFDateUtil.h"
#import "RecordType.h"
#import "Account.h"
#import "HelperClass.h"
#import "Country.h"

@implementation RegistrationAmendment

- (id)initRegistrationAmendment:(NSDictionary *)amendmentDict {
    if (!(self = [super init]))
        return nil;
    
    if ([amendmentDict isKindOfClass:[NSNull class]] || amendmentDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Name"]];
    self.address = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Address__c"]];
    self.addressBeforeAmendment  = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Address_Before_Amendment__c"]];
    self.applicationStatus = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Application_Status__c"]];
    self.city = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"City__c"]];
    self.cityBeforeChange = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"City_Before_Change__c"]];
    self.companyName = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Company_Name__c"]];
    self.companyNameBeforeRegistration = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Company_Name_Before_Registration__c"]];
    self.companyArabicNameBeforeRegistration = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Company_Arabic_Name_Before_Registration__c"]];
    self.countryBeforeChange = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Country_Before_Change__c"]];
    self.email = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"E_Mail__c"]];
    self.emailBeforeChange = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Email_Before_Change__c"]];
    self.fax = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Fax__c"]];
    self.faxBeforeChange = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Fax_Before_Change__c"]];
    self.mobile = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Mobile__c"]];
    self.mobileBeforeChange = [HelperClass stringCheckNull:[amendmentDict objectForKey:@"Mobile_Before_Change__c"]];
    
    if (![[amendmentDict objectForKey:@"Amendment_Effective_Date__c"] isKindOfClass:[NSNull class]])
        self.amendmentEffectiveDate = [SFDateUtil SOQLDateTimeStringToDate:[amendmentDict objectForKey:@"Amendment_Effective_Date__c"]];
    
    self.company = [[Account alloc] initAccount:[amendmentDict objectForKey:@"Company__c"]];
    self.country = [[Country alloc] initCountry:[amendmentDict objectForKey:@"Country__c"]];
    self.recordType = [[RecordType alloc] initRecordType:[amendmentDict objectForKey:@"RecordType"]];

    return self;
}

@end
