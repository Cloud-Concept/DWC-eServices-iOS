//
//  MyRequestListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/2/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "UITableView+DragLoad.h"

@class SFRestRequest;

@interface MyRequestListViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate, UISearchResultsUpdating>
{
    NSArray *dataRows;
    
    NSIndexPath *selectedStatusFilterIndexPath;
    NSString *selectedStatusFilter;
    NSArray *statusFilterStringArray;
    
    NSIndexPath *selectedServiceFilterIndexPath;
    NSString *selectedServiceFilter;
    NSArray *serviceFilterStringArray;
    
    NSMutableArray *filteredRequestsArray;
    
    NSString *searchBarText;
    
    SFRestRequest *restRequest;
    
    BOOL shouldClearCacheOnRefresh;
}

@property (weak, nonatomic) IBOutlet UITableView *requestsTableView;
@property (weak, nonatomic) IBOutlet UIButton *statusFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *serviceFilterButton;

@property (strong, nonatomic) UISearchController *searchController;

- (IBAction)statusFilterButtonClicked:(id)sender;
- (IBAction)serviceFilterButtonClicked:(id)sender;

@end
