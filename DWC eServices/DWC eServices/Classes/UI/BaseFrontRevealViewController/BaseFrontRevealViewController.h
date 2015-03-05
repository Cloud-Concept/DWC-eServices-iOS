//
//  BaseFrontRevealViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseFrontRevealViewController : UIViewController <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *bottomTabBar;
@property (nonatomic) BOOL showSlidingMenu;
@end
