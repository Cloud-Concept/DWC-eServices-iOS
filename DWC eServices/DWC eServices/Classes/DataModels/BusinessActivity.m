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

- (id)initBusinessActivity:(NSDictionary *)businessActivityDict {
    if (!(self = [super init]))
        return nil;
    
    if ([businessActivityDict isKindOfClass:[NSNull class]] || businessActivityDict == nil)
        return nil;
    
    self.Id = [HelperClass stringCheckNull:[businessActivityDict objectForKey:@"Id"]];
    self.name = [HelperClass stringCheckNull:[businessActivityDict objectForKey:@"Name"]];
    self.businessActivityName = [HelperClass stringCheckNull:[businessActivityDict objectForKey:@"Business_Activity_Name__c"]];
    self.businessActivityNameArabic = [HelperClass stringCheckNull:[businessActivityDict objectForKey:@"Business_Activity_Name_Arabic__c"]];
    self.businessActivityDescription = [HelperClass stringCheckNull:[businessActivityDict objectForKey:@"Business_Activity_Description__c"]];
    self.licenseType = [HelperClass stringCheckNull:[businessActivityDict objectForKey:@"License_Type__c"]];
    self.status = [HelperClass stringCheckNull:[businessActivityDict objectForKey:@"Status__c"]];
    
    return self;
}

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
