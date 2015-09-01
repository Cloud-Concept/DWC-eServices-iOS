//
//  ThankYouPhaseView.h
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouPhaseView : UIView

@property (nonatomic, assign) id delegate;
@property(weak,nonatomic) IBOutlet UITextView*message;

-(void)setMessageText:(NSString*)str;
-(IBAction)CloseBtn:(id)sender;

@end
