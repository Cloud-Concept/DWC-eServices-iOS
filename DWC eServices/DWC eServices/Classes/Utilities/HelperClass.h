//
//  HelperClass.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/21/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperClass : NSObject
+ (NSDate *)dateTimeFromString:(NSString *)dateStringValue;
+ (NSString *)stringCheckNull:(NSString *)stringValue;
+ (NSNumber *)numberCheckNull:(NSNumber *)numberValue;
+ (void)setupButtonWithTextUnderImage:(UIButton *)button;
+ (void)setupButtonWithImageAlignedToLeft:(UIButton *)button;
+ (void)setupButtonWithTextLeftToImage:(UIButton *)button;
+ (void)setupButtonWithBadgeOnImage:(UIButton *)button Value:(NSInteger)value;
+ (NSString *)formatDateToString:(NSDate *)date;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (NSString *)formatNumberToString:(NSNumber *)number FormatStyle:(NSNumberFormatterStyle)numberFormatStyle MaximumFractionDigits:(NSUInteger)fractionDigits;
+ (void)displayAlertDialogWithTitle:(NSString *)title Message:(NSString *)message;
+ (NSString *)getRelationshipValue:(NSDictionary *)dictionary Key:(NSString *)key;
+ (NSString *)formatBoolToString:(BOOL)booleanValue;
@end
