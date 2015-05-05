//
//  NeedHelpViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/5/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@class RecordType;

@interface NeedHelpViewController : BaseFrontRevealViewController
{
    NSArray *caseTypesArray;
    NSIndexPath *selectedCaseTypeIndexPath;
    
    RecordType *caseRecordType;
}

@property (weak, nonatomic) IBOutlet UIButton *caseTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextArea;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)caseTypeButtonClicked:(id)sender;

@end
