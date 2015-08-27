//
//  SubmitView.m
//  iDWC
//
//  Created by George on 8/20/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "SubmitView.h"
#import "RenewPassportSteperViewController.h"
#import "ThanksView.h"
#import "Visa.h"
#import "Account.h"
#import "Country.h"

@implementation SubmitView

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"SubmitView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    return self;
}
-(void)initFields{
    
    
    [self.passportHolder setText:[(RenewPassportSteperViewController*)self.delegate renewedPassportObject].passportNumber];
    [self.oldPassportNO setText:[(RenewPassportSteperViewController*)self.delegate renewedPassportObject].visaHolder.name];
    [self.CountryOfIssue setText:[(RenewPassportSteperViewController*)self.delegate renewedPassportObject].passportIssueCountry.name];
    
    [self.requestedPassportNo setText:[(RenewPassportSteperViewController*)self.delegate passportDetailsView].passportNumberField.text];
    [self.issueDate setText:[(RenewPassportSteperViewController*)self.delegate passportDetailsView].issueDate.titleLabel.text];
    [self.ExpiryDate setText:[(RenewPassportSteperViewController*)self.delegate passportDetailsView].expiryDate.titleLabel.text];
    [self.placeOfIssue setText:[(RenewPassportSteperViewController*)self.delegate passportDetailsView].placeOfIssueField.text];
}



-(IBAction)cancelBTN:(UIButton*)sender{
    [(RenewPassportSteperViewController*)self.delegate cancelServiceButtonClicked];
}


-(IBAction)nextBTNClicked:(UIButton*)sender{
    NSString *functionName = @"MobilePayAndSubmitWebService";
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/%@", functionName];
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = [NSString stringWithFormat:@"/services/apexrest/%@", functionName];
    payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:[(RenewPassportSteperViewController*)self.delegate getCaseID] forKey:@"caseId"];
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
    [self setHidden:YES];
//    [(RenewPassportSteperViewController*)self.delegate NextScreen:ThanksScreen];
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}


#pragma mark - SFrest delegate
-(void)request:(SFRestRequest *)request didLoadResponse:(id)dataResponse{
    DLog(@"Load Response");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        NSString *caseIDValue = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
        caseIDValue = [caseIDValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if(![caseIDValue isEqualToString:@"Success"]){
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:@"An Error Has been Ouccared"];
        }
        else{
            [self setHidden:YES];
            [(RenewPassportSteperViewController*)self.delegate NextScreen:ThanksScreen];
        }
    });
}
-(void)request:(SFRestRequest *)request didFailLoadWithError:(NSError *)error{
    DLog(@"failed loading Error");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:[error description]];
    });
    
}
-(void)requestDidCancelLoad:(SFRestRequest *)request{
    DLog(@"cancel loading request");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
    
}
-(void)requestDidTimeout:(SFRestRequest *)request{
    DLog(@"Time out request");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
}
@end
