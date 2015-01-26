//
//  HelperClass.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/21/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "HelperClass.h"
#import "UIView+MGBadgeView.h"

@implementation HelperClass

+ (NSDate*)dateTimeFromString:(NSString*)dateStringValue {
    dateStringValue = [HelperClass stringCheckNull:dateStringValue];
    
    if ([dateStringValue isEqualToString:@""]) {
        return [NSDate date];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dateStringValue = [dateStringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateStringValue = [dateStringValue substringToIndex:[dateStringValue rangeOfString:@"."].location];
    
    return [format dateFromString:dateStringValue];
}

+ (NSString*)stringCheckNull:(NSString*)stringValue {
    if(![stringValue isKindOfClass:[NSNull class]])
        return stringValue;
    else
        return @"";
}

+ (NSNumber*)numberCheckNull:(NSNumber*)numberValue {
    if(![numberValue isKindOfClass:[NSNull class]])
        return numberValue;
    else
        return 0;
}

+ (void)setupButtonWithTextLeftToImage:(UIButton*)button {
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, 0, button.imageView.frame.size.width);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, button.titleLabel.frame.size.width, 0, -button.titleLabel.frame.size.width - 10);
}

+ (void)setupButtonWithTextUnderImage:(UIButton*)button {
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

+ (void)setupButtonWithBadgeOnImage:(UIButton*)button Value:(NSInteger)value {
    
    [button.imageView setClipsToBounds:NO];
    
    [button.imageView.badgeView setBadgeValue:value];
    
    [button.imageView.badgeView setOutlineWidth:1];
    
    [button.imageView.badgeView setPosition:MGBadgePositionTopRight];
    
    [button.imageView.badgeView setOutlineColor:[UIColor colorWithRed:.24f green:.89f blue:.88f alpha:1.0f]];
    [button.imageView.badgeView setBadgeColor:[UIColor colorWithRed:.21f green:.75f blue:.74f alpha:1.0f]];
    [button.imageView.badgeView setTextColor:[UIColor whiteColor]];
    
    [button.imageView.badgeView setFont:[UIFont fontWithName:@"CorisandeLight" size:8.0f]];
    [button.imageView.badgeView setMinDiameter:10.0f];
    
    [button.imageView.badgeView setDisplayIfZero:NO];
}

@end
