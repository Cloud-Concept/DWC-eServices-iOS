//
//  UIImageView+MaskImage.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UIImageView+MaskImage.h"
#import "HelperClass.h"

@implementation UIImageView (MaskImage)

- (void)maskImageToCircle {
    /*
    UIImage *maskImage = [HelperClass imageWithImage:[UIImage imageNamed:@"Circle Mask"] scaledToSize:self.image.size];
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([self.image CGImage], mask);
    
    self.image = [UIImage imageWithCGImage:masked];
    */
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
    
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f].CGColor;

}

@end
