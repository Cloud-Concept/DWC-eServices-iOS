//
//  DatePickerViewController.m
//  DWCTest
//
//  Created by Mina Zaklama on 12/25/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    switch (self.DatePickerType) {
        case Date:
            [self.datePicker setDatePickerMode:UIDatePickerModeDate];
            break;
        case DateTime:
            [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case Time:
            [self.datePicker setDatePickerMode:UIDatePickerModeTime];
            break;
        default:
            [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
    }
    
    if (self.minimumDate != nil) {
        [self.datePicker setMinimumDate:self.minimumDate];
    }
    
    if (self.maximumDate != nil) {
        [self.datePicker setMaximumDate:self.maximumDate];
    }
    
    if (self.defaultDate == nil) {
        self.defaultDate = [NSDate date];
    }
    [self.datePicker setDate:self.defaultDate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datePickerValueChanged:(id)sender {
    [self.delegate datePickerValueChanged:self.datePicker.date];
}
@end
