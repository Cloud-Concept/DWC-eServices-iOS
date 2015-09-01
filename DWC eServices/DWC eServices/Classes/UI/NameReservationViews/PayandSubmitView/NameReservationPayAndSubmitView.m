//
//  NameReservationPayAndSubmitView.m
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NameReservationPayAndSubmitView.h"
#import "ThreeButtonsSteperViewController.h"
#import "NameReservationData.h"
#import "HelperClass.h"
#import "Globals.h"
#import "Account.h"

@implementation NameReservationPayAndSubmitView

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"NameReservationPayandSubmitView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    return self;
}

-(void)setLabels{
    NameReservationData* v= (NameReservationData*)[[(ThreeButtonsSteperViewController*)self.delegate holderView] viewWithTag:ViewDetails];
    
    [self.choice1 setText:v.choice1.text];
    [self.choice2 setText:v.choice2.text];
    [self.choice3 setText:v.choice3.text];
}

-(IBAction)cancel:(id)sender{
 [(ThreeButtonsSteperViewController*)self.delegate cancelServiceButtonClicked];
}
-(IBAction)Submit:(id)sender{
    SFRestRequest *validate = [[SFRestRequest alloc] init];
    validate.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileServiceUtilityWebService"];
    validate.method = SFRestMethodPOST;
    validate.path = [NSString stringWithFormat:@"/services/apexrest/MobileServiceUtilityWebService"];
    
    NSMutableDictionary *wrapperDict = [NSMutableDictionary new];
    [wrapperDict setObject:[Globals currentAccount].Id forKey:@"AccountId"];
    [wrapperDict setObject:self.choice1.text forKey:@"choice1"];
    [wrapperDict setObject:self.choice2.text forKey:@"choice2"];
    [wrapperDict setObject:self.choice3.text forKey:@"choice3"];
    [wrapperDict setObject:@"SubmitRequestNameReservation" forKey:@"actionType"];
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObject:wrapperDict forKey:@"wrapper"];
    
    validate.queryParams = bodyDict;
    
    [(ThreeButtonsSteperViewController*)self.delegate showLoadingDialog];
    [[SFRestAPI sharedInstance] send:validate delegate:self];
}


#pragma mark - SFrest delegate
-(void)request:(SFRestRequest *)request didLoadResponse:(id)dataResponse{
    DLog(@"Load Response");
    dispatch_async(dispatch_get_main_queue(), ^{
        [(ThreeButtonsSteperViewController*)self.delegate  hideLoadingDialog];
        NSString *returnValue = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
        returnValue = [returnValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if([returnValue containsString:@"Error"])
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:@"Error Happened during Validation Check, Please contact System Administrator"];
        
        else if([returnValue containsString:@"Success"]){
            [(ThreeButtonsSteperViewController*)self.delegate setRefrenceNumber:[returnValue stringByReplacingOccurrencesOfString:@"Success" withString:@""]];
            [(ThreeButtonsSteperViewController*)self.delegate NextScreen:ThanksPhase];
        }
        else{
            NSArray *strings = [returnValue componentsSeparatedByString:@","];
            NSMutableString * errorMsgs = [NSMutableString new];
            for (NSString* value in strings)
                [errorMsgs appendString:[NSString stringWithFormat:@"%@ \n",value]];
            
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:errorMsgs];
        }
    });
}
-(void)request:(SFRestRequest *)request didFailLoadWithError:(NSError *)error{
    DLog(@"failed loading Error");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [(ThreeButtonsSteperViewController*)self.delegate  hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:[error description]];
    });
    
}
-(void)requestDidCancelLoad:(SFRestRequest *)request{
    DLog(@"cancel loading request");
    dispatch_async(dispatch_get_main_queue(), ^{
        [(ThreeButtonsSteperViewController*)self.delegate  hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
    
}
-(void)requestDidTimeout:(SFRestRequest *)request{
    DLog(@"Time out request");
    dispatch_async(dispatch_get_main_queue(), ^{
        [(ThreeButtonsSteperViewController*)self.delegate  hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
}
@end
