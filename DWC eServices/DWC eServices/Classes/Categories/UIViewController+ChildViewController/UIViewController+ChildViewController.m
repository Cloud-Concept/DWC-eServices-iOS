//
//  UIViewController+AddChildViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/22/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UIViewController+ChildViewController.h"

@implementation UIViewController (ChildViewController)

- (void)addChildViewController:(UIViewController *)childVC toView:(UIView *)parentView {
    [parentView addSubview:childVC.view];
    childVC.view.frame = parentView.bounds;
    childVC.view.bounds = parentView.bounds;
    [self addChildViewController:childVC];
    [childVC didMoveToParentViewController:self];
    
}

- (void)removeChildVC:(UIViewController *)childVC {
    [childVC willMoveToParentViewController:nil];
    [childVC.view removeFromSuperview];
    [childVC removeFromParentViewController];
}

@end
