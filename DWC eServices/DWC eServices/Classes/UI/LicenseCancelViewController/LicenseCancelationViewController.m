//
//  LicenseCancelationViewController.m
//  iDWC
//
//  Created by George on 8/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "LicenseCancelationViewController.h"
#import "HelperClass.h"
#import "FVCustomAlertView.h"
#import "SFRestAPI.h"
#import "SFRestAPI+Blocks.h"
#import "Globals.h"
#import "Account.h"

@interface LicenseCancelationViewController ()

@end

@implementation LicenseCancelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"LicenseCancellation",@"")];
    [self.licenseName setText:self.currentLicense.commercialName];
    [self.licenseNo setText:self.currentLicense.licenseNumberValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    [self.issueDate setText:[formatter stringFromDate:self.currentLicense.licenseIssueDate]];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem* leftItem =[[UIBarButtonItem alloc] initWithTitle:nil style:self.navigationItem.backBarButtonItem.style target:self action:@selector(backButtonPressed:)];
    [leftItem setImage:[UIImage imageNamed:@"Navigation Bar Back Button Icon"]];
    [leftItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftItem];

    [self.thanksView setHidden:YES];
    [self.thanksView setDelgate:self];
    [self requestPayement];
}
- (void)backButtonPressed:(id)sender {
        [self cancelServiceButtonClicked];
}
- (void)cancelServiceButtonClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ConfirmAlertTitle", @"")
                                                                   message:NSLocalizedString(@"CancelServiceAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          NSLog(@"Yes action");
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"")
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action){
                                                         NSLog(@"No action");
                                                     }];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestPayement{
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            @try {
                NSArray *records = [dict objectForKey:@"records"];
                [self.totalAmount setText:[NSString stringWithFormat:@"%ld",(long)[[records[0] objectForKey:@"Amount__c"] integerValue]]];
                NSDictionary * knowldgeDic = [records[0] objectForKey:@"Knowledge_Fee__r"];
                [self.knowldgeFee setText:[NSString stringWithFormat:@"%ld",(long)[[knowldgeDic objectForKey:@"Amount__c"] integerValue]]];
            }
            @catch (NSException *exception) {
                DLog(@"%@",[exception description]);
            }
            
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
            
        });
    };
    
    NSString* query = @"select Service_Identifier__c , Amount__c , Display_Name__c , Require_Knowledge_Fee__c , Knowledge_Fee__r.Amount__c from Receipt_Template__c where Service_Identifier__c in ('License Cancellation' , 'License Cancellation')";
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] performSOQLQuery:query
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)payClicked:(UIButton *)sender {
    [self sendRequest:@"validateRequestLicenseCancellation"];
    
}
-(void)sendRequest:(NSString*) actionType{
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileServiceUtilityWebService"];
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = [NSString stringWithFormat:@"/services/apexrest/MobileServiceUtilityWebService"];
    
    NSMutableDictionary *wrapperDict = [NSMutableDictionary new];
    [wrapperDict setObject:[Globals currentAccount].Id forKey:@"AccountId"];
    [wrapperDict setObject:self.currentLicense.Id forKey:@"licenseId"];
    [wrapperDict setObject:actionType forKey:@"actionType"];
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObject:wrapperDict forKey:@"wrapper"];
    
    payAndSubmitRequest.queryParams = bodyDict;
    
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
}
- (IBAction)backClicked:(UIButton *)sender {
    [self cancelServiceButtonClicked];
}

#pragma mark delegate

-(void)request:(SFRestRequest *)request didLoadResponse:(id)dataResponse{
    DLog(@"Load Response");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        NSString *returnValue = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
        returnValue = [returnValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        if([returnValue containsString:@"Error"])
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:@"Error Happened during Validation Check, Please contact System Administrator"];
        else if([[[request.queryParams objectForKey:@"wrapper"] objectForKey:@"actionType"] isEqualToString:@"SubmitRequestLicenseCancellation"] && [returnValue containsString:@"Success"]){
            [self.thanksView setMsgText];
            [self.detailsView setHidden:YES];
            [self.thanksView setHidden:NO];
        }
        else if([[[request.queryParams objectForKey:@"wrapper"] objectForKey:@"actionType"] isEqualToString:@"validateRequestLicenseCancellation"] && [returnValue containsString:@"Success"]){
            [self sendRequest:@"SubmitRequestLicenseCancellation"];
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
