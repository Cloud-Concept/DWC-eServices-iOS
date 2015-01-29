//
//  UIView+RoundCorner.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UIView+RoundCorner.h"

@implementation UIView (RoundCorner)

- (void)createRoundBorderedWithRadius:(float)radius Shadows:(BOOL)withShadows ClipToBounds:(BOOL)clipBounds {
    // border radius
    [self.layer setCornerRadius:radius];
    
    // border
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.clipsToBounds = clipBounds;
    
    // drop shadow
    if(withShadows) {
        [self.layer setShadowColor:[UIColor darkGrayColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:0.5];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    }
}

@end
