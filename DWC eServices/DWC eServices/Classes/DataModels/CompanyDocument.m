//
//  CompanyDocument.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyDocument.h"
#import "Account.h"
#import "RecordType.h"
#import "HelperClass.h"
#import "SFDateUtil.h"

@implementation CompanyDocument

- (id)initCompanyDocument:(NSDictionary *)companyDocumentDict {
    if (!(self = [super init]))
        return nil;
    
    if ([companyDocumentDict isKindOfClass:[NSNull class]] || companyDocumentDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[companyDocumentDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[companyDocumentDict objectForKey:@"Name"]];
    self.attachmentId  = [HelperClass stringCheckNull:[companyDocumentDict objectForKey:@"Attachment_Id__c"]];
    self.documentType  = [HelperClass stringCheckNull:[companyDocumentDict objectForKey:@"Document_Type__c"]];
    self.version = [HelperClass numberCheckNull:[companyDocumentDict objectForKey:@"Version__c"]];
    
    if (![[companyDocumentDict objectForKey:@"CreatedDate"] isKindOfClass:[NSNull class]])
        self.createdDate = [SFDateUtil SOQLDateTimeStringToDate:[companyDocumentDict objectForKey:@"CreatedDate"]];
    
    self.customerDocument = [[companyDocumentDict objectForKey:@"Customer_Document__c"] boolValue];
    self.originalVerified = [[companyDocumentDict objectForKey:@"Original_Verified__c"] boolValue];
    self.originalCollected = [[companyDocumentDict objectForKey:@"Original_Collected__c"] boolValue];
    self.requiredOriginal = [[companyDocumentDict objectForKey:@"Required_Original__c"] boolValue];
    self.verifiedScanCopy = [[companyDocumentDict objectForKey:@"Verified_Scan_Copy__c"] boolValue];
    self.uploaded = [[companyDocumentDict objectForKey:@"Uploaded__c"] boolValue];
    self.requiredScanCopy = [[companyDocumentDict objectForKey:@"Required_Scan_copy__c"] boolValue];
    
    self.party = [[Account alloc] initAccount:[companyDocumentDict objectForKey:@"Party__r"]];
    self.recordType = [[RecordType alloc] initRecordType:[companyDocumentDict objectForKey:@"RecordType"]];
    
    return self;
}

@end
