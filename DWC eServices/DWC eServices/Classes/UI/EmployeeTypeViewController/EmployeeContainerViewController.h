//
//  EmployeeTypeTableViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@interface EmployeeTypeViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dwcEmployeesTypesArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
