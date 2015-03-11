//
//  LicenseActivity.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "LicenseActivity.h"
#import "HelperClass.h"
#import "SFDateUtil.h"

@implementation LicenseActivity

- (id)initLicenseActivity:(NSString *)LicenseActivityId Name:(NSString *)Name Status:(NSString *)Status StartDate:(NSString *)StartDate EndDate:(NSString *)EndDate OriginalBusinessActivity:(BusinessActivity *)OriginalBusinessActivity {
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:LicenseActivityId];
    self.name = [HelperClass stringCheckNull:Name];
    self.status = [HelperClass stringCheckNull:Status];
    
    if (![StartDate isKindOfClass:[NSNull class]])
        self.startDate = [SFDateUtil SOQLDateTimeStringToDate:StartDate];
    
    if (![EndDate isKindOfClass:[NSNull class]])
        self.endDate = [SFDateUtil SOQLDateTimeStringToDate:EndDate];
    
    self.originalBusinessActivity = OriginalBusinessActivity;
    
    return self;
}
@end
