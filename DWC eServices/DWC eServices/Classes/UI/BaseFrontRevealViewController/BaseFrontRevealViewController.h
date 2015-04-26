//
//  BaseFrontRevealViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface BaseFrontRevealViewController : UIViewController <UITabBarDelegate, SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *bottomTabBar;
@property (nonatomic) BOOL showSlidingMenu;
@property (nonatomic) BOOL showNotificationIcon;
@property (nonatomic) BOOL showBottomTabBar;

- (void)setNavigationBarTitle:(NSString *)title;
- (void)refreshNotificationsCount;
@end
