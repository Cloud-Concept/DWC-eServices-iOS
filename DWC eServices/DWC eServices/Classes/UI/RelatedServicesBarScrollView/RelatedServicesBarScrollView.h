//
//  RelatedServicesTabBar.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelatedServicesBarScrollView : UIScrollView
{
    NSArray *relatedServicesArray;
}

- (void)displayRelatedServicesForMask:(NSUInteger)relatedServicesMask;

@end
