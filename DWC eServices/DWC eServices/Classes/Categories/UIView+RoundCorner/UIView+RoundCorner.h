//
//  UIView+RoundCorner.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (RoundCorner)

- (void)createRoundBorderedWithRadius:(float)radius Shadows:(BOOL)withShadows ClipToBounds:(BOOL)clipBounds;

@end
