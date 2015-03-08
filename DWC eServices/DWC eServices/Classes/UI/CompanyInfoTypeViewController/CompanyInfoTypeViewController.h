//
//  CompanyInfoViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@interface CompanyInfoTypeViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dwcCompanyInfoTypesArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
