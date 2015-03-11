//
//  BusinessActivity.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "BusinessActivity.h"
#import "HelperClass.h"

@implementation BusinessActivity

- (id)initBusinessActivity:(NSString *)BusinessActivityId Name:(NSString *)Name BusinessActivityName:(NSString *)BusinessActivityName BusinessActivityNameArabic:(NSString *)BusinessActivityNameArabic BusinessActivityDescription:(NSString *)BusinessActivityDescription LicenseType:(NSString *)LicenseType Status:(NSString *)Status {
    if (!(self = [super init]))
        return nil;
    
    self.Id = [HelperClass stringCheckNull:BusinessActivityId];
    self.name = [HelperClass stringCheckNull:Name];
    self.businessActivityName = [HelperClass stringCheckNull:BusinessActivityName];
    self.businessActivityNameArabic = [HelperClass stringCheckNull:BusinessActivityNameArabic];
    self.businessActivityDescription = [HelperClass stringCheckNull:BusinessActivityDescription];
    self.licenseType = [HelperClass stringCheckNull:LicenseType];
    self.status = [HelperClass stringCheckNull:Status];
    
    return self;
}

@end
