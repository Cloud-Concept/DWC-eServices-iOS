//
//  ServicesThankYouViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 4/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ServicesThankYouViewController.h"
#import "BaseServicesViewController.h"
#import "HelperClass.h"
#import "SWRevealViewController.h"

@interface ServicesThankYouViewController ()

@end

@implementation ServicesThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeMessage];
    
    if (self.isNeedHelp)
        self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMessage {
    
    if (self.isNeedHelp) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"NeedHelpThankYouMessage", @""), self.needHelpCaseNumber];
        [self.messageTextView setText:message];
        return;
    }
    
    NSString *totalPriceString = [HelperClass formatNumberToString:self.baseServicesViewController.createdCaseTotalPrice
                                                       FormatStyle:NSNumberFormatterDecimalStyle
                                             MaximumFractionDigits:2];
    
    NSMutableString *message = [NSMutableString stringWithFormat:NSLocalizedString(@"ServiceThankYouMessage", @""), self.baseServicesViewController.createdCaseNumber];
    
    if (self.baseServicesViewController.relatedServiceType != RelatedServiceTypeCancelCard &&
        self.baseServicesViewController.relatedServiceType != RelatedServiceTypeNewCard &&
        self.baseServicesViewController.relatedServiceType != RelatedServiceTypeRenewCard &&
        self.baseServicesViewController.relatedServiceType != RelatedServiceTypeReplaceCard) {
        [message appendString:@"\r\n \r\n"];
        [message appendFormat:NSLocalizedString(@"ServiceThankYouMessagePayment", @""), totalPriceString];
    }
    
    if (self.baseServicesViewController.relatedServiceType == RelatedServiceTypeNewCompanyNOC ||
        self.baseServicesViewController.relatedServiceType == RelatedServiceTypeNewEmployeeNOC) {
        [message appendString:@"\r\n \r\n \r\n"];
        [message appendFormat:NSLocalizedString(@"ServiceThankYouMessageNOCNote", @""), self.baseServicesViewController.createdCaseNOCEmailReceiver];
    }
    
    [self.messageTextView setText:message];
}

- (IBAction)closeButtonClicked:(id)sender {
    if (self.isNeedHelp) {
        [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    [self.baseServicesViewController closeThankYouFlowPage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
