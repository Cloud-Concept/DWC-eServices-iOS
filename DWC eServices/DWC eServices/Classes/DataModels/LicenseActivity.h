//
//  LicenseActivity.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BusinessActivity;

@interface LicenseActivity : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status; //Status__c
@property (nonatomic, strong) NSDate *startDate; //Start_Date__c
@property (nonatomic, strong) NSDate *endDate; //End_Date__c
@property (nonatomic, strong) BusinessActivity *originalBusinessActivity; //Original_Business_Activity__c

- (id)initLicenseActivity:(NSDictionary *)licenseActivityDict;
/*
- (id)initLicenseActivity:(NSString *)LicenseActivityId Name:(NSString *)Name Status:(NSString *)Status StartDate:(NSString *)StartDate EndDate:(NSString *)EndDate OriginalBusinessActivity:(BusinessActivity *)OriginalBusinessActivity;
*/
@end
