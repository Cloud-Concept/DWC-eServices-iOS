//
//  NotificationListViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/11/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "UITableView+DragLoad.h"
#import "SFRestAPI.h"

@interface NotificationListViewController : BaseFrontRevealViewController <UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate, SFRestDelegate>
{
    NSArray *notificationsArray;
    SFRestRequest *restRequest;
    
    BOOL shouldMarkAllAsRead;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
