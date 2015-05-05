//
//  ServicesThankYouViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 4/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseServicesViewController;

@interface ServicesThankYouViewController : UIViewController

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (assign, nonatomic) BOOL isNeedHelp;
@property (strong, nonatomic) NSString *needHelpCaseNumber;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

- (IBAction)closeButtonClicked:(id)sender;


@end
