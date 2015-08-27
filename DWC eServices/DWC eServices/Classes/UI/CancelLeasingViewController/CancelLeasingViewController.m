//
//  CancelLeasingViewController.m
//  iDWC
//
//  Created by George on 8/25/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CancelLeasingViewController.h"
#import "Globals.h"
#import "Account.h"
#import "FVCustomAlertView.h"
#import "HelperClass.h"
#import "ContractLineItem.h"
#import "InventoryUnit.h"
@interface CancelLeasingViewController ()

@end

@implementation CancelLeasingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"DWCCompanyCancelLeasingInfo",@"")];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem* leftItem =[[UIBarButtonItem alloc] initWithTitle:nil style:self.navigationItem.backBarButtonItem.style target:self action:@selector(backButtonPressed:)];
    [leftItem setImage:[UIImage imageNamed:@"Navigation Bar Back Button Icon"]];
    [leftItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
- (void)backButtonPressed:(id)sender {
    [self cancelServiceButtonClicked];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)submitClicked:(UIButton*)sender{
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileServiceUtilityWebService"];
    payAndSubmitRequest.method = SFRestMethodPOST;
    payAndSubmitRequest.path = [NSString stringWithFormat:@"/services/apexrest/MobileServiceUtilityWebService"];
    
    NSMutableDictionary *wrapperDict = [NSMutableDictionary new];
    [wrapperDict setObject:[Globals currentAccount].Id forKey:@"AccountId"];
    [wrapperDict setObject:self.currentContract.Id forKey:@"contractId"];
    [wrapperDict setObject:@"SubmitRequestLeasingCancellation" forKey:@"actionType"];
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObject:wrapperDict forKey:@"wrapper"];
    
    payAndSubmitRequest.queryParams = bodyDict;
    
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
}

-(IBAction)cancelClicked:(UIButton*)sender{
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
        
        else if([returnValue containsString:@"Success"]){
            [self.detailsAndSubmitView setHidden:YES];
            [self.submitView setMsgText];
            [self.submitView setDelgate:self];
            [self.submitView setHidden:false];
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

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
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

#pragma mark tableDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section == 0)? 4:self.currentContract.contractLineItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel* headerTxt = (UILabel*)[self.view viewWithTag:1];
        UILabel* valueTxt = (UILabel*)[self.view viewWithTag:2];
        if(indexPath.section ==0)
        {
            NSString *priceString = [HelperClass formatNumberToString:self.currentContract.totalRentPrice
                                                          FormatStyle:NSNumberFormatterDecimalStyle
                                                MaximumFractionDigits:2];
            switch (indexPath.row) {
                case 0:
                    [headerTxt setText:NSLocalizedString(@"TenancyContractName", @"")];
                    [valueTxt setText:self.currentContract.contractNumber];
                    break;
                case 1:
                    [headerTxt setText:NSLocalizedString(@"TenancyContractType", @"")];
                    [valueTxt setText:self.currentContract.contractType];
                    break;
                case 2:
                    [headerTxt setText:NSLocalizedString(@"TenancyContractDurationYear", @"")];
                    [valueTxt setText:[HelperClass formatNumberToString:self.currentContract.contractDurationYear
                                                            FormatStyle:NSNumberFormatterNoStyle
                                                  MaximumFractionDigits:0]];
                    break;
                case 3:
                    [headerTxt setText:NSLocalizedString(@"TenancyContractRentPrice", @"")];
                    [valueTxt setText:[NSString stringWithFormat:@"AED %@", priceString]];
                    break;
                default:
                    break;
            }
           
        }
        else{
            ContractLineItem *contractLineItem = (ContractLineItem*)self.currentContract.contractLineItems[indexPath.row];

            [headerTxt setText:NSLocalizedString(@"TenancyContractLineItemUnitName", @"")];
            [valueTxt setText:contractLineItem.inventoryUnit.name];
        }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return (section==0)?NSLocalizedString(@"TenancyContractInformation", @""):NSLocalizedString(@"TenancyContractLeasingUnitDetails", @"");
}
@end
