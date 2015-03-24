//
//  CompanyDocumentTypeViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@interface CompanyDocumentTypeViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *companyDocumentsTypesArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end