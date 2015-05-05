//
//  CompanyDocumentTypeListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "SFRestAPI.h"
#import "UITableView+DragLoad.h"

@class DWCCompanyDocument;
@class TenancyContract;

@interface CompanyDocumentTypeListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate, SFRestDelegate>
{
    NSMutableArray *dataRows;
    TenancyContract *activeBCTenancyContract;
    
    SFRestRequest *restRequest;
    
    NSIndexPath *expandedRowIndexPath;
}

@property (nonatomic, strong) DWCCompanyDocument *currentDocumentType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)refreshViewController;

@end
