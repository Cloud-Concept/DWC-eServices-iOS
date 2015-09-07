//
//  PassportRequestDetailsView.m
//  iDWC
//
//  Created by George on 8/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "PassportRequestDetailsView.h"
#import "RenewPassportSteperViewController.h"
#import "UploadDocumentsView.h"
#import "Globals.h"
#import "Account.h"
#import "Passport.h"
#import "Country.h"
#import "SFDateUtil.h"

@implementation PassportRequestDetailsView

-(IBAction)cancelBTN:(UIButton*)sender{
        [(RenewPassportSteperViewController*)self.delegate cancelServiceButtonClicked];
}
//- (RenewPassportSteperViewController*)viewController
//{
//    for (UIView* next = [self superview]; next; next = next.superview)
//    {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[RenewPassportSteperViewController class]])
//        {
//            return (RenewPassportSteperViewController*)nextResponder;
//        }
//    }
//    return nil;
//}

-(IBAction)nextBTNClicked:(UIButton*)sender{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    NSDate *issueDate = [dateFormatter dateFromString:self.issueDate.titleLabel.text];
    NSDate *ExpiryDate = [dateFormatter dateFromString:self.expiryDate.titleLabel.text];

    NSInteger month = [[[NSCalendar currentCalendar] components: NSCalendarUnitMonth
                                                       fromDate: issueDate
                                                         toDate: ExpiryDate
                                                        options: 0] month];
    

    
    
    if (ISEMPTY(self.passportNumberField.text) || ISEMPTY(self.placeOfIssueField.text) || (ISEMPTY(self.issueDate.titleLabel.text)) || ISEMPTY(self.expiryDate.titleLabel.text)) {
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredFieldsAlertMessage", @"")];
    }
    else if (([issueDate compare:ExpiryDate] == NSOrderedDescending)){
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredDateFieldNotValiedAlertMessage", @"")];
    }
    else if (month  < 6){
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredDateFieldNotValiedInterval", @"")];
    }
    else{
        
        NSString * endPointPath = @"/services/apexrest/MobilePassportRenewalWebService";
        SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
        payAndSubmitRequest.endpoint = endPointPath;
        payAndSubmitRequest.method = SFRestMethodPOST;
        payAndSubmitRequest.path = endPointPath;
        
        NSMutableDictionary* params = [NSMutableDictionary new];
        [params setObject:[Globals currentAccount].Id forKey:@"AccountId"];
        [params setObject:@"CreateRequest" forKey:@"actionType"];
        [params setObject:[(RenewPassportSteperViewController*)self.delegate renewedPassportObject].passportIssueCountry.Id forKey:@"passportIssueCountryId"];
        
        [params setObject:[(RenewPassportSteperViewController*)self.delegate renewedPassportObject].Id forKey:@"visaId"];
        // to be sent when actionType = "Submit"
        [params setObject:@"" forKey:@"caseId"];
        
        [params setObject:[(RenewPassportSteperViewController*)self.delegate renewedPassportObject].passport.passportHolder.Id forKey:@"PassportHolderId"];
        
        // TO be added and validated
        [params setObject:self.passportNumberField.text forKey:@"passportNo"];
        [params setObject:[SFDateUtil toSOQLDateTimeString:issueDate isDateTime:NO] forKey:@"passportIssueDate"];
        
//        [SFDateUtil toSOQLDateTimeString:[SFDateUtil SOQLDateTimeStringToDate:[visaDict objectForKey:@"Passport_Expiry__c"] isDateTime:NO]
        
        [params setObject:[SFDateUtil toSOQLDateTimeString:ExpiryDate isDateTime:NO] forKey:@"passportExpiryDate"];
        [params setObject:self.placeOfIssueField.text forKey:@"passportPlaceOfIssue"];
        
        payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:params forKey:@"wrapper"];
        
        [self showLoadingDialog];
        [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
    }
//                [(RenewPassportSteperViewController*)self.delegate NextScreen:UploadDocuments];
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

-(IBAction)newIssueDate:(UIButton*)sender{
    DatePickerViewController *datePickerVC = [DatePickerViewController new];
    datePickerVC.DatePickerType = Date;
    
    datePickerVC.preferredContentSize = datePickerVC.view.bounds.size;
    
    datePickerVC.valuePicked = ^(NSDate *value, DatePickerViewController *picklist) {
        [((UIButton*)sender) setTitle:[HelperClass formatDateToString:value] forState:UIControlStateNormal];
        [picklist dismissPopover:YES];
    };
    
    [datePickerVC showPopoverFromView:sender];
}

#pragma mark - SFrest delegate
-(void)request:(SFRestRequest *)request didLoadResponse:(id)dataResponse{
    DLog(@"Load Response");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingDialog];
        NSString *caseIDValue = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
        caseIDValue = [caseIDValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if([caseIDValue isEqualToString:@"Duplication"]){
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:@"A duplicate entry found in the system with the same Passport number and Passport Issue country."];
        }
        else{
            
            [(RenewPassportSteperViewController*)self.delegate setCaseIDValue:caseIDValue];
            [(RenewPassportSteperViewController*)self.delegate NextScreen:UploadDocuments];
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
