//
//  MyRequestListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/2/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@interface MyRequestListViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *dataRows;
}
@property (weak, nonatomic) IBOutlet UITableView *requestsTableView;

@end
