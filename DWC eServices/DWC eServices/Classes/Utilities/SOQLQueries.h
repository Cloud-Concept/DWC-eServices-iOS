//
//  SOQLQueries.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOQLQueries : NSObject

+ (NSString*)visitVisaEmployeesQuery;
+ (NSString*)permanentEmployeesQuery;
+ (NSString*)contractorsQuery;
+ (NSString *)employeeNOCTypesQuery;
+ (NSString *)companyNOCTypesQuery;
@end
