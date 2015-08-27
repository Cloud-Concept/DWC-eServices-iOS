//
//  LicenseCancellationThanksView.m
//  iDWC
//
//  Created by George on 8/24/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "LicenseCancellationThanksView.h"
#import "LicenseCancelationViewController.h"
@implementation LicenseCancellationThanksView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setMsgText{
    
    NSMutableString* str = [NSMutableString new];
    int totalValue = [[[(LicenseCancelationViewController*)self.delgate totalAmount] text] intValue] + [[[(LicenseCancelationViewController*)self.delgate knowldgeFee] text] intValue];
    
    [str appendString:@"\r\n \r\n"];
    [str appendFormat:NSLocalizedString(@"ServiceThankYouMessageCards", @""), [NSString stringWithFormat:@"%d",totalValue]];
    
    [self.message setText:str];
}
-(IBAction)CloseBtn:(id)sender{
    [(LicenseCancelationViewController*)self.delgate cancelServiceButtonClicked];
}

@end
