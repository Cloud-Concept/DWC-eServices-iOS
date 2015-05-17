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

@protocol EmployeeListSelectEmployeeDelegate <NSObject>

- (void)didSelectVisaEmployee:(Visa *)selectedVisa;
- (void)didSelectCardEmployee:(CardManagement *)selectedCard;

@end

@interface EmployeeListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate, UISearchResultsUpdating>
{
    NSArray *dataRows;
    
    BOOL hideNewButton;
    
    NSIndexPath *selectedFilterIndexPath;
    NSString *selectedFilter;
    NSArray *filterStringArray;
    NSMutableArray *filteredEmployeesArray;
    
    NSString *searchBarText;
    
    SFRestRequest *restRequest;
    
    NSIndexPath *expandedRowIndexPath;
}
@property (nonatomic, strong) DWCEmployee *currentDWCEmployee;

@property (nonatomic) BOOL isSelectEmployee;
@property (nonatomic) id <EmployeeListSelectEmployeeDelegate> selectEmployeeDelegate;
@property (nonatomic) BOOL hideFilter;

@property (weak, nonatomic) IBOutlet UITableView *employeesTableView;
@property (weak, nonatomic) IBOutlet UIButton *addNewButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (strong, nonatomic) UISearchController *searchController;

- (IBAction)addNewButtonClicked:(id)sender;
- (IBAction)filterButtonClicked:(id)sender;
@end
