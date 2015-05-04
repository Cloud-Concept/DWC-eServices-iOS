//
//  UIImageView+Additions.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

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
