//
//  UIViewController+AddChildViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (ChildViewController)

- (void)addChildViewController:(UIViewController *)childVC toView:(UIView *)parentView;
- (void)removeChildVC:(UIViewController *)childVC;

@end
