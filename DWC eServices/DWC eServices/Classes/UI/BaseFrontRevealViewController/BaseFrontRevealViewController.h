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
@property (nonatomic) BOOL hideSlidingMenu;
@property (nonatomic) BOOL hideNotificationIcon;
@property (nonatomic) BOOL hideBottomTabBar;
@property (nonatomic) BOOL hideBackButton;
@property (nonatomic) BOOL showLogoutButton;
@property (nonatomic, copy) void (^navigationItemBackAction)(void);

- (void)setNavigationBarTitle:(NSString *)title;
- (void)refreshNotificationsCount;
- (void)displayAlertDialogWithTitle:(NSString *)title Message:(NSString *)message;
@end
