//
//  Directorship.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Directorship.h"
#import "HelperClass.h"
#import "SFDateUtil.h"

@implementation Directorship

- (id)initDirectorship:(NSString *)DirectorId Roles:(NSString *)Roles DirectorStatus:(NSString *)DirectorStatus DirectorshipStartDate:(NSString *)DirectorshipStartDate DirectorshipEndDate:(NSString *)DirectorshipEndDate Director:(Account *)Director {
    
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:DirectorId];
    self.roles = [HelperClass stringCheckNull:Roles];
    self.directorStatus = [HelperClass stringCheckNull:DirectorStatus];
    
    if (![DirectorshipStartDate isKindOfClass:[NSNull class]])
        self.directorshipStartDate = [SFDateUtil SOQLDateTimeStringToDate:DirectorshipStartDate];
    
    if (![DirectorshipEndDate isKindOfClass:[NSNull class]])
        self.directorshipEndDate = [SFDateUtil SOQLDateTimeStringToDate:DirectorshipEndDate];
    
    self.director = Director;
    
    return self;
}
@end
