//
//  Request.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecordType;

@interface Request : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *caseNumber;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *webFormId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *caseRatingScore;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) RecordType *caseRecordType;

- (id)initRequest:(NSDictionary *)requestDict;
/*
- (id)initRequestWithId:(NSString *)caseId Number:(NSString *)Number Status:(NSString *)Status WebFormId:(NSString *)WebFormId CreatedDate:(NSString *)CreatedDate CaseRecordType:(RecordType *)CaseRecordType;

- (id)initRequestWithId:(NSString *)caseId Number:(NSString *)Number Status:(NSString *)Status WebFormId:(NSString *)WebFormId RatingScore:(NSNumber *)RatingScore CreatedDate:(NSString *)CreatedDate CaseRecordType:(RecordType *)CaseRecordType;
*/
@end
