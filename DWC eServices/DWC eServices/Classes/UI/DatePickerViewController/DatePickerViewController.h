//
//  DatePickerViewController.h
//  DWCTest
//
//  Created by Mina Zaklama on 12/25/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"

typedef enum : NSUInteger {
    Date,
    DateTime,
    Time,
} DatePickerType;

@interface DatePickerViewController : UIViewController <WYPopoverControllerDelegate>
{
    WYPopoverController *popoverController;
}

@property (nonatomic) DatePickerType DatePickerType;
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (strong, nonatomic) NSDate *defaultDate;

@property (nonatomic, copy) void (^valuePicked)(NSDate *, DatePickerViewController *);

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (void)showPopoverFromView:(UIView*)sender;
- (void)dismissPopover:(BOOL)animated;

@end
