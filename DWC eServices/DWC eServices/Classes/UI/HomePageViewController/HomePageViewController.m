//
//  HomePageViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/21/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "HomePageViewController.h"
#import "HelperClass.h"
#import "SFRestAPI+Blocks.h"
#import "SFUserAccountManager.h"
#import "Globals.h"
#import "Account.h"
#import "FVCustomAlertView.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home NavBar DWC Logo"]];
    
    [self setupHomeButton:self.dashboardButton TitleKey:@"homeDashboardButton"];
    [self setupHomeButton:self.employeesButton TitleKey:@"homeEmployeesButton"];
    [self setupHomeButton:self.myRequestButton TitleKey:@"homeMyRequestButton"];
    [self setupHomeButton:self.notificationButton TitleKey:@"homeNotificationButton"];
    [self setupHomeButton:self.companyDocumentsButton TitleKey:@"homeCompanyDocumentsButton"];
    [self setupHomeButton:self.needHelpButton TitleKey:@"homeNeedHelpButton"];
    [self setupHomeButton:self.logoutButton TitleKey:@"homeLogoutButton"];
    [self setupHomeButton:self.servicesButton TitleKey:@"homeServicesButton"];
    [self setupHomeButton:self.companyInfoButton TitleKey:@"homeCompanyInfoButton"];
    
    [HelperClass setupButtonWithBadgeOnImage:self.notificationButton Value:0];
    
    [self loadCompanyInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCompanyInfo {
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DWC" message:@"An error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        
        NSDictionary *accountDict = [[dict objectForKey:@"Contact"] objectForKey:@"Account"];
        Account *account = [[Account alloc] initAccount:[accountDict objectForKey:@"Id" ]
                                                   Name:[accountDict objectForKey:@"Name" ]
                                         AccountBalance:[accountDict objectForKey:@"Account_Balance__c" ]
                                            BillingCity:[accountDict objectForKey:@"BillingCity" ]
                                     BillingCountryCode:[accountDict objectForKey:@"BillingCountryCode" ]
                                   LicenseNumberFormula:[accountDict objectForKey:@"License_Number_Formula__c" ]
                               LicenseExpiryDateFormula:[accountDict objectForKey:@"License_Expiry_Date_Formula__c" ]];
        
        [Globals setCurrentAccount:account];
        
        [Globals setContactId:[dict objectForKey:@"ContactId"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshLabels];
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    
    
    NSArray *fields = @[@"ContactId, Contact.Name", @"Contact.Account.Id", @"Contact.Account.Account_Balance__c", @"Contact.Account.Name", @"Contact.Account.License_Number_Formula__c", @"Contact.Account.BillingCity", @"Contact.Account.BillingCountryCode", @"Contact.Account.License_Expiry_Date_Formula__c"];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performRetrieveWithObjectType:@"User"
                                                     objectId:accountManager.currentUser.credentials.userId
                                                    fieldList:fields
                                                    failBlock:errorBlock
                                                completeBlock:successBlock];
}

- (void)refreshLabels {
    [self.companyNameValueLabel setText:[Globals currentAccount].name];
    [self.licenseNumberValueLabel setText:[Globals currentAccount].licenseNumberFormula];
    [self.licenseExpiryDateValueLabel setText:[HelperClass formatDateToString:[Globals currentAccount].licenseExpiryDateFormula]];
    
    NSString *balanceStr = [HelperClass formatNumberToString:[Globals currentAccount].accountBalance FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2];
    
    [self.currentBalanceValueLabel setText:[NSString stringWithFormat:@"%@ AED", balanceStr]];
}

- (void)setupHomeButton:(UIButton*)button TitleKey:(NSString*)titleKey {
    [button setTitle:NSLocalizedString(titleKey, @"") forState:UIControlStateNormal];
    [HelperClass setupButtonWithTextUnderImage:button];
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
