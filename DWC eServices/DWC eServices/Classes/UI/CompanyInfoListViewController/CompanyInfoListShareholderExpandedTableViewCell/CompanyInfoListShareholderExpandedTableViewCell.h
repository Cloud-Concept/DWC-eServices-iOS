//
//  CompanyInfoListShareholderExpandedTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyInfoListShareholderTableViewCell.h"

@class RelatedServicesBarScrollView;

@interface CompanyInfoListShareholderExpandedTableViewCell : CompanyInfoListShareholderTableViewCell
{
    NSUInteger servicesMask;
}

@property (weak, nonatomic) IBOutlet RelatedServicesBarScrollView *relatedServicesScrollView;

@end
