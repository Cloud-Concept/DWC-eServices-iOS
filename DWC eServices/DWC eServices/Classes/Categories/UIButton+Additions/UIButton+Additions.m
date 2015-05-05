//
//  UIButton+Additions.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/5/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UIButton+Additions.h"
#import "UIView+MGBadgeView.h"

@implementation UIButton (Additions)

- (void)setupButtonWithTextLeftToImage {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width, 0, -self.titleLabel.frame.size.width - 10);
}

- (void)setupButtonWithImageAlignedToLeft {
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    CGFloat imageLeft = 15;
    CGFloat imageRight = imageLeft + self.imageView.frame.size.width;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, imageLeft, 0, imageRight);
    
    CGFloat titleLeft = imageRight + 25;
    CGFloat titleRight = self.titleLabel.frame.size.width;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, titleLeft, 0, titleRight);
}

- (void)setupButtonWithTextUnderImage {
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

- (void)setupButtonWithBadgeOnImage:(NSInteger)value {
    
    [self.imageView setClipsToBounds:NO];
    
    [self.imageView.badgeView setBadgeValue:value];
    
    [self.imageView.badgeView setOutlineWidth:1];
    
    [self.imageView.badgeView setPosition:MGBadgePositionTopRight];
    
    [self.imageView.badgeView setOutlineColor:[UIColor colorWithRed:.24f green:.89f blue:.88f alpha:1.0f]];
    [self.imageView.badgeView setBadgeColor:[UIColor colorWithRed:.21f green:.75f blue:.74f alpha:1.0f]];
    [self.imageView.badgeView setTextColor:[UIColor whiteColor]];
    
    [self.imageView.badgeView setFont:[UIFont fontWithName:@"CorisandeLight" size:8.0f]];
    [self.imageView.badgeView setMinDiameter:10.0f];
    
    [self.imageView.badgeView setDisplayIfZero:NO];
}


@end
