//
//  CompanyInfoListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@class DWCCompanyInfo;

@interface CompanyInfoListViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataRows;
}

@property (nonatomic, strong) DWCCompanyInfo *currentDWCCompanyInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
