//
//  ThanksCancelLeasingView.m
//  iDWC
//
//  Created by George on 8/27/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ThanksCancelLeasingView.h"
#import "CancelLeasingViewController.h"

@implementation ThanksCancelLeasingView

-(void)setMsgText{
    
    NSMutableString* str = [NSMutableString new];
    [str appendString:@"\r\n \r\n"];
    [str appendFormat:NSLocalizedString(@"ServiceThankLeasingCancellationMessage", @"")];
    
    [self.message setText:str];
}
-(IBAction)CloseBtn:(id)sender{
    [(CancelLeasingViewController*)self.delgate cancelServiceButtonClicked];
}


@end
