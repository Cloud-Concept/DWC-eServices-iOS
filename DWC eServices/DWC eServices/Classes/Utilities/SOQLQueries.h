//
//  SOQLQueries.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOQLQueries : NSObject

+ (NSString *)visitVisaEmployeesQuery;
+ (NSString *)permanentEmployeesQuery;
+ (NSString *)contractorsQuery;
+ (NSString *)employeeNOCTypesQuery;
+ (NSString *)companyNOCTypesQuery;
+ (NSString *)caseReviewQuery:(NSString *)caseId Fields:(NSArray *)formFieldsArray RelatedObject:(NSString *)RelatedObject;
+ (NSString *)caseReviewQuery:(NSString *)caseId Fields:(NSArray *)formFieldsArray RelatedObject:(NSString *)RelatedObject AddRelatedFields:(BOOL)AddRelatedFields;
+ (NSString *)cardTypeQueryForDuration:(NSString *)duration CardType:(NSString *)cardType;
+ (NSString *)myRequestsQueryWithLimit:(NSInteger)limit offset:(NSInteger)offset;
+ (NSString *)companyShareholdersQuery;
+ (NSString *)companyManagersQuery;
+ (NSString *)companyDirectorsQuery;
+ (NSString *)companyLegalRepresentativesQuery;
+ (NSString *)licenseActivityQueryForLicenseId:(NSString *)LicenseId;
+ (NSString *)notificationsQueryWithLimit:(NSInteger)limit offset:(NSInteger)offset;
+ (NSString *)notificationsCountQuery;
+ (NSString *)contractsQuery;
+ (NSString *)dwcDocumentsQuery;
+ (NSString *)customerDocumentsQuery;
+ (NSString *)renewContractServiceAdminQuery:(NSString *)serviceIdentifier;
+ (NSString *)renewLicenseServiceAdminQuery;
+ (NSString *)freeZonePaymentsQueryWithLimit:(NSInteger)limit offset:(NSInteger)offset datesFilter:(NSString *)datesFilter;
+ (NSString *)amendementServiceAdminQuery:(NSString *)serviceIdentifier;
@end
