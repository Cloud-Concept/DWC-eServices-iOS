//
//  ThankYouPhaseView.m
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ThankYouPhaseView.h"
#import "ThreeButtonsSteperViewController.h"

@implementation ThankYouPhaseView

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"ThankYouPhase" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    return self;
}

-(void)setMessageText:(NSString*)str{
    [self.message setText:str];
}
-(IBAction)CloseBtn:(id)sender{
    [(ThreeButtonsSteperViewController*)self.delegate cancelServiceButtonClicked];
}

@end
