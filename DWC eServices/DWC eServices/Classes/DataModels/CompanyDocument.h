//
//  CompanyDocument.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@class RecordType;

@interface CompanyDocument : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *attachmentId;
@property (nonatomic, strong) NSString *documentType;
@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSDate *createdDate;

@property (nonatomic) BOOL customerDocument;
@property (nonatomic) BOOL originalVerified;
@property (nonatomic) BOOL originalCollected;
@property (nonatomic) BOOL requiredOriginal;
@property (nonatomic) BOOL verifiedScanCopy;
@property (nonatomic) BOOL uploaded;
@property (nonatomic) BOOL requiredScanCopy;

@property (nonatomic, strong) Account *party;
@property (nonatomic, strong) RecordType *recordType;

- (id)initCompanyDocument:(NSDictionary *)companyDocumentDict;

@end
