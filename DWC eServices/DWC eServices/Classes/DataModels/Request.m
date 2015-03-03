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

@implementation Request

- (id)initRequestWithId:(NSString *)caseId Number:(NSString *)Number Status:(NSString *)Status WebFormId:(NSString *)WebFormId CreatedDate:(NSString *)CreatedDate CaseRecordType:(RecordType *)CaseRecordType {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:caseId];
    self.caseNumber = [HelperClass stringCheckNull:Number];
    self.status = [HelperClass stringCheckNull:Status];
    self.webFormId = [HelperClass stringCheckNull:WebFormId];
    self.createdDate = [SFDateUtil SOQLDateTimeStringToDate:CreatedDate];
    self.caseRecordType = CaseRecordType;
    
    return self;
}

@end
