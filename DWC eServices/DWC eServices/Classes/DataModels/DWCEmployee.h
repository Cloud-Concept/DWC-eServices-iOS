//
//  DWCEmployee.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PermanentEmployee,
    VisitVisaEmployee,
    ContractorEmployee,
} DWCEmployeeType;

@interface DWCEmployee : NSObject

@property (nonatomic, strong) NSString *Label;
@property (nonatomic, strong) NSString *SOQLQuery;
@property (nonatomic, strong) NSString *NavBarTitle;
@property (nonatomic, strong) NSString *CacheKey;
@property (nonatomic, strong) NSString *ObjectType;
@property (nonatomic) Class ObjectClass;
@property (nonatomic) DWCEmployeeType Type;

- (id)initDWCEmployee:(NSString*)employeeLabel DWCEmployeeType:(DWCEmployeeType)employeeType;
- (id)initDWCEmployee:(NSString*)employeeLabel NavBarTitle:(NSString *)navBarTitle DWCEmployeeType:(DWCEmployeeType)employeeType Query:(NSString*)query;
- (id)initDWCEmployee:(NSString*)employeeLabel NavBarTitle:(NSString *)navBarTitle DWCEmployeeType:(DWCEmployeeType)employeeType Query:(NSString*)query CacheKey:(NSString *)cacheKey ObjectType:(NSString *)objectType ObjectClass:(Class) objectClass;

@end
