//
//  DatePickerViewController.h
//  DWCTest
//
//  Created by Mina Zaklama on 12/25/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewControllerDelegate <NSObject>
-(void)datePickerValueChanged:(NSDate*)newValue;
@end

typedef enum : NSUInteger {
    Date,
    DateTime,
    Time,
} DatePickerType;

@interface DatePickerViewController : UIViewController

@property (nonatomic) DatePickerType DatePickerType;
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (strong, nonatomic) NSDate *defaultDate;

@property (weak) id<DatePickerViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)datePickerValueChanged:(id)sender;

@end
