//
//  DWCDocumentExpandedTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWCDocumentTableViewCell.h"

@class RelatedServicesBarScrollView;

@interface DWCDocumentExpandedTableViewCell : DWCDocumentTableViewCell
{
    NSUInteger servicesMask;
}

@property (weak, nonatomic) IBOutlet RelatedServicesBarScrollView *relatedServicesScrollView;

@end
