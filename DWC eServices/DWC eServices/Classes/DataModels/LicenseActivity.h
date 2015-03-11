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

//SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Original_Business_Activity__r.Id, Original_Business_Activity__r.Name, Original_Business_Activity__r.License_Type__c, Original_Business_Activity__r.Business_Activity_Name__c, Original_Business_Activity__r.Business_Activity_Name_Arabic__c, Original_Business_Activity__r.Business_Activity_Description__c, Original_Business_Activity__r..Status__c FROM License_Activity__c WHERE License__c = : lic.Id

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status; //Status__c
@property (nonatomic, strong) NSDate *startDate; //Start_Date__c
@property (nonatomic, strong) NSDate *endDate; //End_Date__c
@property (nonatomic, strong) BusinessActivity *originalBusinessActivity; //Original_Business_Activity__c

- (id)initLicenseActivity:(NSString *)LicenseActivityId Name:(NSString *)Name Status:(NSString *)Status StartDate:(NSString *)StartDate EndDate:(NSString *)EndDate OriginalBusinessActivity:(BusinessActivity *)OriginalBusinessActivity;

@end
