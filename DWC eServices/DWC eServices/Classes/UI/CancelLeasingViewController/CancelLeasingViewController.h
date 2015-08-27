//
//  CancelLeasingViewController.h
//  iDWC
//
//  Created by George on 8/25/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI+Blocks.h"
#import "SFRestAPI.h"
#import "RelatedService.h"
#import "TenancyContract.h"
#import "ThanksCancelLeasingView.h"

@interface CancelLeasingViewController : UIViewController<SFRestDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) RelatedServiceType relatedServiceType;

@property(weak,nonatomic)IBOutlet UIView* detailsAndSubmitView;
@property(weak,nonatomic)IBOutlet ThanksCancelLeasingView* submitView;

@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TenancyContract *currentContract;
- (void)cancelServiceButtonClicked;

-(IBAction)submitClicked:(UIButton*)sender;
-(IBAction)cancelClicked:(UIButton*)sender;
@end
