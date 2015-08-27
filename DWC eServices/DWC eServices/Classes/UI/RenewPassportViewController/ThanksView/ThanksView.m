//
//  ThanksView.m
//  iDWC
//
//  Created by George on 8/20/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ThanksView.h"


@implementation ThanksView


- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"ThanksView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    //     [self displayDocuments];
    return self;
}
-(void)setMessageText{
//    NSString *totalPriceString = [HelperClass formatNumberToString:self.baseServicesViewController.createdCaseTotalPrice
//                                                       FormatStyle:NSNumberFormatterDecimalStyle
//                                             MaximumFractionDigits:2];
    
    NSMutableString *mess = [NSMutableString stringWithFormat:NSLocalizedString(@"ServiceThankYouMessage", @""), [(RenewPassportSteperViewController*)self.delegate getCaseID]];
    
    [self.message setText:mess];
}
-(IBAction)CloseBtn:(id)sender{
        [(RenewPassportSteperViewController*)self.delegate cancelServiceButtonClicked];
}

@end
