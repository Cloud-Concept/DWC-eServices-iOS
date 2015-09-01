//
//  DirectorRemovalView.m
//  iDWC
//
//  Created by George Hanna Adly on 8/31/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "DirectorRemovalView.h"
#import "FourButtonsSteperViewController.h"
#import "Globals.h"
#import "Account.h"

@implementation DirectorRemovalView

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"DirectorRemovalView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    return self;
}
-(void)setDirector{
    [self.directorName setText:[[(FourButtonsSteperViewController*)self.delegate directorObject] director].name];
}
-(void)performDirectorRemovalRequest{
    NSString*actionType = @"CreateRequestDirectorRemoval";
    NSString * endPointPath = @"/services/apexrest/MobileServiceUtilityWebService";
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = endPointPath;
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = endPointPath;
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[Globals currentAccount].Id forKey:@"AccountId"];
    [params setObject:actionType forKey:@"actionType"];
    [params setObject:[(FourButtonsSteperViewController*)self.delegate directorObject].Id forKey:@"directorId"];
    
    payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:params forKey:@"wrapper"];
    
    [(FourButtonsSteperViewController*)self.delegate showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
}
-(IBAction)nextButton:(id)sender{
    [self performDirectorRemovalRequest];
}
-(IBAction)cancelButton:(id)sender{
        [(FourButtonsSteperViewController*)self.delegate cancelServiceButtonClicked];
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
            [(FourButtonsSteperViewController*)self.delegate setCaseID:[returnValue stringByReplacingOccurrencesOfString:@"Success" withString:@""]];
            [(FourButtonsSteperViewController*)self.delegate NextScreen:UploadDocumentsStep];
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
