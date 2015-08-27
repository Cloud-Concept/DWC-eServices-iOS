//
//  LicenseCancellationThanksView.h
//  iDWC
//
//  Created by George on 8/24/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenseCancellationThanksView : UIView


@property(nonatomic, assign) id delgate;
@property(weak,nonatomic) IBOutlet UITextView*message;

-(void)setMsgText;
-(IBAction)CloseBtn:(id)sender;
@end
