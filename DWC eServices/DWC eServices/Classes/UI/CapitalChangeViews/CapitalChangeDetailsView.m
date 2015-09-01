//
//  CapitalChangeDetailsView.m
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CapitalChangeDetailsView.h"
#import "FourButtonsSteperViewController.h"
#import "HelperClass.h"
#import "Globals.h"
#import "Account.h"

@implementation CapitalChangeDetailsView

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"CapitalChangeDetailsView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    return self;
}
-(void)requestCapitalShareAmount{
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {


        dispatch_async(dispatch_get_main_queue(), ^{
            [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
            for (NSDictionary* record in [dict objectForKey:@"records"]) {
                NSString* value = [NSString stringWithFormat:@"%f",[[record objectForKey:@"Share_Capital_in_AED__c"] doubleValue]];
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init] ;
                [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
                NSString* formatedValue =[formatter stringFromNumber: [formatter numberFromString:[value stringByReplacingOccurrencesOfString:@"," withString:@""]]];
                
                self.oldShareCapital.text = formatedValue;
                [self.requestedShareCapital setText:formatedValue];
            }
        });
    };
    
    [(FourButtonsSteperViewController*)self.delegate showLoadingDialog];
    
    NSString *selectQuery = [NSString stringWithFormat:@"select Share_Capital_in_AED__c  from Account where id = '%@'",[Globals currentAccount].Id];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}
-(IBAction)nextButton:(id)sender{
    NSString* value = self.requestedShareCapital.text;
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (ISEMPTY(self.oldShareCapital.text) || ISEMPTY(self.requestedShareCapital.text))
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredFieldsAlertMessage", @"")];

    else if ([self.oldShareCapital.text isEqualToString:self.requestedShareCapital.text])
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ERRORCAPITALCHANGEEQUAL", @"")];
    else if ([value doubleValue] < 300000.00)
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ERRORCAPITALCHANGE", @"")];
    else
        [self performCapitalChangeRequest];
}
-(void)performCapitalChangeRequest{
    NSString*actionType = @"CreateRequestCapitalChange";
    
    NSString * endPointPath = @"/services/apexrest/MobileServiceUtilityWebService";
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = endPointPath;
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = endPointPath;
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[Globals currentAccount].Id forKey:@"AccountId"];
    [params setObject:actionType forKey:@"actionType"];
    
    // TO be added and validated
    NSString* value = self.requestedShareCapital.text;
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    [params setObject:value forKey:@"newCapital"];
    
    payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:params forKey:@"wrapper"];
    
    [(FourButtonsSteperViewController*)self.delegate showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (([string isEqualToString:@"0"] || [string isEqualToString:@""]) && [textField.text rangeOfString:@"."].location < range.location) {
        return YES;
    }
    
    // First check whether the replacement string's numeric...
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    bool isNumeric = [string isEqualToString:filtered];
    
    // Then if the replacement string's numeric, or if it's
    // a backspace, or if it's a decimal point and the text
    // field doesn't already contain a decimal point,
    // reformat the new complete number using
    // NSNumberFormatterDecimalStyle
    if (isNumeric ||
        [string isEqualToString:@""] ||
        ([string isEqualToString:@"."] &&
         [textField.text rangeOfString:@"."].location == NSNotFound)) {
            
            // Create the decimal style formatter
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setMaximumFractionDigits:10];
            
            // Combine the new text with the old; then remove any
            // commas from the textField before formatting
            NSString *combinedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSString *numberWithoutCommas = [combinedText stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSNumber *number = [formatter numberFromString:numberWithoutCommas];
            
            NSString *formattedString = [formatter stringFromNumber:number];
            
            // If the last entry was a decimal or a zero after a decimal,
            // re-add it here because the formatter will naturally remove
            // it.
            if ([string isEqualToString:@"."] &&
                range.location == textField.text.length) {
                formattedString = [formattedString stringByAppendingString:@"."];
            }
            
            textField.text = formattedString;
            
        }

    return NO;
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
