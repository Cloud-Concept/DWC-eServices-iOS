//
//  EmployeeListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "UITableView+DragLoad.h"
#import "EmployeeTableViewCell.h"

@class DWCEmployee;
@class SFRestRequest;

@interface EmployeeListViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate, UISearchResultsUpdating, EmployeeTableViewCellDelegate>
{
    NSArray *dataRows;
    
    BOOL hideNewButton;
    
    NSIndexPath *selectedFilterIndexPath;
    NSString *selectedFilter;
    NSArray *filterStringArray;
    NSMutableArray *filteredEmployeesArray;
    
    NSString *searchBarText;
    
    SFRestRequest *restRequest;
    
    NSIndexPath *selectedRowIndexPath;
}
@property (nonatomic, strong) DWCEmployee *currentDWCEmployee;

@property (weak, nonatomic) IBOutlet UITableView *employeesTableView;
@property (weak, nonatomic) IBOutlet UIButton *addNewButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (strong, nonatomic) UISearchController *searchController;

- (IBAction)addNewButtonClicked:(id)sender;
- (IBAction)filterButtonClicked:(id)sender;
@end
