//
//  UIImageView+Additions.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (Additions)


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (void)maskImageToCircle;

@end
