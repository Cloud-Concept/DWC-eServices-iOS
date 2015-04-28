//
//  EmployeeExpandedTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeTableViewCell.h"

@class RelatedServicesBarScrollView;

@interface EmployeeExpandedTableViewCell : EmployeeTableViewCell
{
    NSUInteger servicesMask;
}

//@property (weak, nonatomic) IBOutlet RelatedServicesTabBar *relatedServicesTabBar;
@property (weak, nonatomic) IBOutlet RelatedServicesBarScrollView *relatedServicesScrollView;

@end
