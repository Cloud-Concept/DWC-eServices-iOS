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
@property (nonatomic) DWCEmployeeType Type;

- (id)initDWCEmployee:(NSString*)employeeLabel DWCEmployeeType:(DWCEmployeeType)employeeType;
- (id)initDWCEmployee:(NSString*)employeeLabel DWCEmployeeType:(DWCEmployeeType)employeeType Query:(NSString*)query;

@end
