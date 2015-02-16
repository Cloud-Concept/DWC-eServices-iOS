//
//  EmployeeListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@class DWCEmployee;

@interface EmployeeListViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataRows;
}
@property (nonatomic, strong) DWCEmployee *currentDWCEmployee;
@property (weak, nonatomic) IBOutlet UITableView *employeesTableView;

@end