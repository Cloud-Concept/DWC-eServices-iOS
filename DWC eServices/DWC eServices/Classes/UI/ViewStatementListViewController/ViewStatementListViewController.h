//
//  ViewStatementListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+DragLoad.h"
#import "BaseFrontRevealViewController.h"

@class SFRestRequest;

@interface ViewStatementListViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate>
{
    NSArray *paymentsArray;
    SFRestRequest *restRequest;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
