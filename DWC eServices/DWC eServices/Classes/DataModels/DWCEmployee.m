//
//  DWCEmployee.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DWCEmployee.h"


@implementation DWCEmployee

- (id)initDWCEmployee:(NSString*)employeeLabel DWCEmployeeType:(DWCEmployeeType)employeeType {
    return [self initDWCEmployee:employeeLabel DWCEmployeeType:employeeType Query:@""];
}

- (id)initDWCEmployee:(NSString*)employeeLabel DWCEmployeeType:(DWCEmployeeType)employeeType Query:(NSString*)query {
    if (!(self = [super init]))
        return nil;
    
    self.Label = employeeLabel;
    self.Type = employeeType;
    self.SOQLQuery = query;
    
    return self;
}

@end
