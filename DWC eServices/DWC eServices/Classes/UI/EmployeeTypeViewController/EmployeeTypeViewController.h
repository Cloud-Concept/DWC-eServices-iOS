//
//  EmployeeTypeTableViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

typedef enum {
    PermanentEmployee,
    VisitVisaEmployee,
    ContractorEmployee,
} DWCEmployeeType;

@interface EmployeeTypeViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *employeesTypesArray;
}

@end
