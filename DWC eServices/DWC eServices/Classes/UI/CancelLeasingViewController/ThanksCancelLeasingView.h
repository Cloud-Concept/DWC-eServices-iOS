//
//  ThanksCancelLeasingView.h
//  iDWC
//
//  Created by George on 8/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThanksCancelLeasingView : UIView

@property(nonatomic, assign) id delgate;
@property(weak,nonatomic) IBOutlet UITextView*message;

-(void)setMsgText;
-(IBAction)CloseBtn:(id)sender;
@end
