//
//  PassportRequestDetailsView.h
//  iDWC
//
//  Created by George on 8/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "HelperClass.h"
#import "SFRestRequest.h"
#import "SFRestAPI.h"
#import "FVCustomAlertView.h"


@protocol viewControllerDelegate
@end

@interface PassportRequestDetailsView : UIView<SFRestDelegate>


@property (nonatomic, assign) id <viewControllerDelegate> delegate;

// Read only Fields
@property (weak,nonatomic) IBOutlet UITextField*oldPassportNo;
@property (weak,nonatomic) IBOutlet UITextField*passportHolder;
@property (weak,nonatomic) IBOutlet UITextField*CountryOfIssue;

@property (weak,nonatomic) IBOutlet UITextField* passportNumberField;
@property (weak,nonatomic) IBOutlet UIButton* issueDate;
@property (weak,nonatomic) IBOutlet UIButton* expiryDate;
@property (weak,nonatomic) IBOutlet UITextField* placeOfIssueField;

-(IBAction)newIssueDate:(UIButton*)sender;

-(IBAction)cancelBTN:(UIButton*)sender;
-(IBAction)nextBTNClicked:(UIButton*)sender;
@end
