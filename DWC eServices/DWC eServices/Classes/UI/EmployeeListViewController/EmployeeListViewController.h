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
    
    BOOL hideNewButton;
    
    NSIndexPath *selectedFilterIndexPath;
    NSString *selectedFiler;
    NSArray *filterStringArray;
    NSMutableArray *filteredEmployeesArray;
}
@property (nonatomic, strong) DWCEmployee *currentDWCEmployee;

@property (weak, nonatomic) IBOutlet UITableView *employeesTableView;
@property (weak, nonatomic) IBOutlet UIButton *addNewButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

- (IBAction)addNewButtonClicked:(id)sender;
- (IBAction)filterButtonClicked:(id)sender;
@end
