//
//  DirectorPayAndSubmitView.m
//  iDWC
//
//  Created by George Hanna Adly on 8/31/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DirectorPayAndSubmitView.h"
#import "FourButtonsSteperViewController.h"
#import "CapitalChangeDocumentView.h"
#import "Globals.h"
#import "Account.h"
#import "Directorship.h"


@implementation DirectorPayAndSubmitView

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"DirectorPayAndSubmitView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    return self;
}

-(void)setLabels{

    [self.directorLabel setText:[(FourButtonsSteperViewController*)self.delegate directorObject].director.name];

    CapitalChangeDocumentView* documentView = (CapitalChangeDocumentView*)[[(FourButtonsSteperViewController*)self.delegate holderView] viewWithTag:UploadDocumentsStep];
    [self.amountLabel setText:[NSString stringWithFormat:@"%@",[documentView.getEserviceAdmin totalAmount]]];
}
-(IBAction)cancel:(id)sender{
    [(FourButtonsSteperViewController*)self.delegate cancelServiceButtonClicked];
}
-(IBAction)Submit:(id)sender{
    [self performCapitalChangeRequest];
}

-(void)performCapitalChangeRequest{
    NSString * endPointPath = @"/services/apexrest/MobileServiceUtilityWebService";
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = endPointPath;
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = endPointPath;
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[Globals currentAccount].Id forKey:@"AccountId"];
    [params setObject:[(FourButtonsSteperViewController*)self.delegate caseID] forKey:@"caseId"];
    [params setObject:self.actionType forKey:@"actionType"];
    

    payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:params forKey:@"wrapper"];
    
    [(FourButtonsSteperViewController*)self.delegate showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
}

#pragma mark delegate
-(void)request:(SFRestRequest *)request didLoadResponse:(id)dataResponse{
    DLog(@"Load Response");
    dispatch_async(dispatch_get_main_queue(), ^{
        [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
        NSString *returnValue = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
        returnValue = [returnValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        if([returnValue containsString:@"Error"])
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:@"Error Happened during Validation Check, Please contact System Administrator"];
        else if([returnValue containsString:@"Success"]){
            [(FourButtonsSteperViewController*)self.delegate setRefrenceNumber:[returnValue stringByReplacingOccurrencesOfString:@"Success" withString:@""]];
            [(FourButtonsSteperViewController*)self.delegate NextScreen:ThanksScreenStep];
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
        [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:[error description]];
    });
    
}
-(void)requestDidCancelLoad:(SFRestRequest *)request{
    DLog(@"cancel loading request");
    dispatch_async(dispatch_get_main_queue(), ^{
        [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
    
}
-(void)requestDidTimeout:(SFRestRequest *)request{
    DLog(@"Time out request");
    dispatch_async(dispatch_get_main_queue(), ^{
        [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
}

@end
