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
#import "SWRevealViewController.h"
#import "License.h"
#import "RecordType.h"
#import "SFAuthenticationManager.h"
#import "BusinessActivity.h"
#import "LicenseActivity.h"
#import "SOQLQueries.h"

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
#warning Handle Error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DWC" message:@"An error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        
        NSDictionary *accountDict = [[dict objectForKey:@"Contact"] objectForKey:@"Account"];
        
        NSDictionary *licenseDict = [accountDict objectForKey:@"Current_License_Number__r"];
        License *license;
        if (![licenseDict isKindOfClass:[NSNull class]]) {
            NSDictionary *licenseRecordTypeDict = [licenseDict objectForKey:@"RecordType"];
            RecordType *licenseRecordType = [[RecordType alloc]
                                             initRecordType:[licenseRecordTypeDict objectForKey:@"Id"]
                                             Name:[licenseRecordTypeDict objectForKey:@"Name"]
                                             DeveloperName:[licenseRecordTypeDict objectForKey:@"DeveloperName"]
                                             IsActive:YES
                                             ObjectType:[licenseRecordTypeDict objectForKey:@"SobjectType"]];
            
            license = [[License alloc] initLicense:[licenseDict objectForKey:@"Id"]
                                    CommercialName:[licenseDict objectForKey:@"Commercial_Name__c"]
                              CommercialNameArabic:[licenseDict objectForKey:@"Commercial_Name_Arabic__c"]
                                LicenseNumberValue:[licenseDict objectForKey:@"License_Number_Value__c"]
                                    ValidityStatus:[licenseDict objectForKey:@"Validity_Status__c"]
                                  LicenseIssueDate:[licenseDict objectForKey:@"License_Issue_Date__c"]
                                 LicenseExpiryDate:[licenseDict objectForKey:@"License_Expiry_Date__c"]
                                 LicenseRecordType:licenseRecordType];
        }
        
        Account *account = [[Account alloc] initAccount:[accountDict objectForKey:@"Id"]
                                                   Name:[accountDict objectForKey:@"Name"]
                                         AccountBalance:[accountDict objectForKey:@"Account_Balance__c"]
                                   LicenseNumberFormula:[accountDict objectForKey:@"License_Number_Formula__c"]
                               LicenseExpiryDateFormula:[accountDict objectForKey:@"License_Expiry_Date_Formula__c"]
                                CompanyRegistrationDate:[accountDict objectForKey:@"Company_Registration_Date__c"]
                                              LegalForm:[accountDict objectForKey:@"Legal_Form__c"]
                                RegistrationNumberValue:[accountDict objectForKey:@"Registration_Number_Value__c"]
                                                  Phone:[accountDict objectForKey:@"Phone"]
                                                    Fax:[accountDict objectForKey:@"Fax"]
                                                  Email:[accountDict objectForKey:@"Email__c"]
                                                 Mobile:[accountDict objectForKey:@"Mobile__c"]
                                               ProEmail:[accountDict objectForKey:@"PRO_Email__c"]
                                        ProMobileNumber:[accountDict objectForKey:@"PRO_Mobile_Number__c"]
                                          BillingStreet:[accountDict objectForKey:@"BillingStreet"]
                                      BillingPostalCode:[accountDict objectForKey:@"BillingPostalCode"]
                                         BillingCountry:[accountDict objectForKey:@"BillingCountry"]
                                           BillingState:[accountDict objectForKey:@"BillingState"]
                                            BillingCity:[accountDict objectForKey:@"BillingCity"]
                                     BillingCountryCode:[accountDict objectForKey:@"BillingCountryCode"]
                                   CurrentLicenseNumber:license];
        
        [Globals setCurrentAccount:account];
        
        [Globals setContactId:[dict objectForKey:@"ContactId"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshLabels];
            [self loadLicenseInfo];
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    
    
    NSArray *fields = @[@"ContactId, Contact.Name", @"Contact.Account.Id", @"Contact.Account.Account_Balance__c", @"Contact.Account.Name", @"Contact.Account.License_Number_Formula__c", @"Contact.Account.BillingCity", @"Contact.Account.BillingCountryCode", @"Contact.Account.License_Expiry_Date_Formula__c", @"Contact.Account.Company_Registration_Date__c", @"Contact.Account.Legal_Form__c", @"Contact.Account.Registration_Number_Value__c", @"Contact.Account.Phone", @"Contact.Account.Fax", @"Contact.Account.Email__c", @"Contact.Account.Mobile__c", @"Contact.Account.PRO_Email__c", @"Contact.Account.PRO_Mobile_Number__c", @"Contact.Account.BillingStreet", @"Contact.Account.BillingPostalCode", @"Contact.Account.BillingCountry", @"Contact.Account.BillingState", @"Contact.Account.Current_License_Number__r.Id", @"Contact.Account.Current_License_Number__r.License_Issue_Date__c", @"Contact.Account.Current_License_Number__r.License_Expiry_Date__c", @"Contact.Account.Current_License_Number__r.Commercial_Name__c", @"Contact.Account.Current_License_Number__r.Commercial_Name_Arabic__c", @"Contact.Account.Current_License_Number__r.License_Number_Value__c", @"Contact.Account.Current_License_Number__r.Validity_Status__c", @"Contact.Account.Current_License_Number__r.RecordType.Id", @"Contact.Account.Current_License_Number__r.RecordType.Name", @"Contact.Account.Current_License_Number__r.RecordType.DeveloperName", @"Contact.Account.Current_License_Number__r.RecordType.SObjectType"];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performRetrieveWithObjectType:@"User"
                                                     objectId:accountManager.currentUser.credentials.userId
                                                    fieldList:fields
                                                    failBlock:errorBlock
                                                completeBlock:successBlock];
}

- (void)loadLicenseInfo {
        void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DWC" message:@"An error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        
        NSMutableArray *licenseActivityMutableArray = [NSMutableArray new];
        
        for (NSDictionary *licenseActivityDict in [dict objectForKey:@"records"]) {
            
            
            NSDictionary *originalBusinessActivityDict = [licenseActivityDict objectForKey:@"Original_Business_Activity__r"];
            
            BusinessActivity *businessActivity;
            if (![originalBusinessActivityDict isKindOfClass:[NSNull class]]) {
                businessActivity = [[BusinessActivity alloc]
                                    initBusinessActivity:[originalBusinessActivityDict objectForKey:@"Id"]
                                    Name:[originalBusinessActivityDict objectForKey:@"Name"]
                                    BusinessActivityName:[originalBusinessActivityDict objectForKey:@"Business_Activity_Name__c"]
                                    BusinessActivityNameArabic:[originalBusinessActivityDict objectForKey:@"Business_Activity_Name_Arabic__c"]
                                    BusinessActivityDescription:[originalBusinessActivityDict objectForKey:@"Business_Activity_Description__c"]
                                    LicenseType:[originalBusinessActivityDict objectForKey:@"License_Type__c"]
                                    Status:[originalBusinessActivityDict objectForKey:@"Status__c"]];
            }

            [licenseActivityMutableArray addObject:[[LicenseActivity alloc]
                                                    initLicenseActivity:[licenseActivityDict objectForKey:@"Id"]
                                                    Name:[licenseActivityDict objectForKey:@"Name"]
                                                    Status:[licenseActivityDict objectForKey:@"Status__c"]
                                                    StartDate:[licenseActivityDict objectForKey:@"Start_Date__c"]
                                                    EndDate:[licenseActivityDict objectForKey:@"End_Date__c"]
                                                    OriginalBusinessActivity:businessActivity]];
        }
        
        [Globals currentAccount].currentLicenseNumber.licenseActivityArray = [NSArray arrayWithArray:licenseActivityMutableArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshLabels];
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance]
     performSOQLQuery:[SOQLQueries licenseActivityQueryForLicenseId:[Globals currentAccount].currentLicenseNumber.Id]
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

- (IBAction)logoutButtonClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"LogoutAlertTitle", @"")
                                                                   message:NSLocalizedString(@"LogoutAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [[SFAuthenticationManager sharedManager] logout];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"")
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Pass the selected object to the new view controller.
    
    SWRevealViewController *destinationVC = [segue destinationViewController];
    
    NSString *segueIdentifier = segue.identifier;
    NSString *initialSegueID;
    
    if ([segueIdentifier isEqualToString:@"MyRequestsSlidingMenuSegue"])
        initialSegueID = [NSString stringWithFormat:@"%@%@", SWSegueFrontIdentifier, @"_myRequests"];
    else if ([segueIdentifier isEqualToString:@"EmployeesSlidingMenuSegue"])
        initialSegueID = [NSString stringWithFormat:@"%@%@", SWSegueFrontIdentifier, @"_employees"];
    else if ([segueIdentifier isEqualToString:@"CompanyInfoSlidingMenuSegue"])
        initialSegueID = [NSString stringWithFormat:@"%@%@", SWSegueFrontIdentifier, @"_company_info"];
    else if ([segueIdentifier isEqualToString:@"NotificationSlidingMenuSegue"])
        initialSegueID = [NSString stringWithFormat:@"%@%@", SWSegueFrontIdentifier, @"_notification"];
    
    destinationVC.initialSegueIdentifier = initialSegueID;
    
}
//*/

@end
