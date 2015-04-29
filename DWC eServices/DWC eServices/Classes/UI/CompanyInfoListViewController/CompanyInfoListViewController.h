//
//  CompanyInfoListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "SFRestAPI.h"
#import "UITableView+DragLoad.h"
#import "CompanyInfoListBaseTableViewCell.h"

@class DWCCompanyInfo;

@interface CompanyInfoListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate, SFRestDelegate, CompanyInfoListBaseTableViewCellDelegate>
{
    NSArray *dataRows;
    
    SFRestRequest *restRequest;
    
    NSIndexPath *expandedRowIndexPath;
}

@property (nonatomic, strong) DWCCompanyInfo *currentDWCCompanyInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
