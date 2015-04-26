//
//  SwipePageViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/26/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipePageViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    NSInteger currentPageIndex;
    
    
}

@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UIView *pageViewControllerContainerView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *viewControllerArray;
@property (strong, nonatomic) NSArray *pageLabelArray;
@end
