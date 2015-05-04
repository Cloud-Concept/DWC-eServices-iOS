//
//  CustomerDocumentExpandedTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDocumentTableViewCell.h"

@class RelatedServicesBarScrollView;

@interface CustomerDocumentExpandedTableViewCell : CustomerDocumentTableViewCell
{
    NSUInteger servicesMask;
}

@property (weak, nonatomic) IBOutlet RelatedServicesBarScrollView *relatedServicesScrollView;

@end
