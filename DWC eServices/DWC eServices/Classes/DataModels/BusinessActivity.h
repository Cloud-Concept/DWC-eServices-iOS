//
//  BusinessActivity.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/10/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessActivity : NSObject

@property (nonatomic, strong) NSString *Id; //Id
@property (nonatomic, strong) NSString *name; //Name
@property (nonatomic, strong) NSString *businessActivityName; //Business_Activity_Name__c
@property (nonatomic, strong) NSString *businessActivityNameArabic; //Business_Activity_Name_Arabic__c
@property (nonatomic, strong) NSString *businessActivityDescription; //Business_Activity_Description__c
@property (nonatomic, strong) NSString *licenseType; //License_Type__c
@property (nonatomic, strong) NSString *status; //Status__c

- (id)initBusinessActivity:(NSString *)BusinessActivityId Name:(NSString *)Name BusinessActivityName:(NSString *)BusinessActivityName BusinessActivityNameArabic:(NSString *)BusinessActivityNameArabic BusinessActivityDescription:(NSString *)BusinessActivityDescription LicenseType:(NSString *)LicenseType Status:(NSString *)Status;

@end
