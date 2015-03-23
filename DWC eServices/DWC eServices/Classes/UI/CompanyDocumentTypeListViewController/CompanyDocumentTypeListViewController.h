//
//  CompanyDocumentTypeListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@class DWCCompanyDocument;

@interface CompanyDocumentTypeListViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataRows;
}

@property (nonatomic, strong) DWCCompanyDocument *currentDocumentType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
