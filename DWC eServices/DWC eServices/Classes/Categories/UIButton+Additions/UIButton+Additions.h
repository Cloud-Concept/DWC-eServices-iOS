//
//  UIButton+Additions.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/5/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (Additions)

- (void)setupButtonWithTextUnderImage;
- (void)setupButtonWithImageAlignedToLeft;
- (void)setupButtonWithTextLeftToImage;
- (void)setupButtonWithBadgeOnImage:(NSInteger)value;

@end
