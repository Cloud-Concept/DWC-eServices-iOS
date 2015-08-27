//
//  ThanksView.h
//  iDWC
//
//  Created by George on 8/20/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassportRequestDetailsView.h"
#import "RenewPassportSteperViewController.h"

@interface ThanksView : UIView

@property (nonatomic, assign) id <viewControllerDelegate> delegate;

@property(weak,nonatomic) IBOutlet UITextView*message;

-(void)setMessageText;
-(IBAction)CloseBtn:(id)sender;
@end
