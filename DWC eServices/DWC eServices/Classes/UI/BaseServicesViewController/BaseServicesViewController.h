//
//  BaseServicesViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/16/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@interface BaseServicesViewController : BaseFrontRevealViewController <UIAlertViewDelegate>

@property (strong, nonatomic) UIViewController *cancelViewController;

- (void)cancelServiceButtonClicked;

@end
