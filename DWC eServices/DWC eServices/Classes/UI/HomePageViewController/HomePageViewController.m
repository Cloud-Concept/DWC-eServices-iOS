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
#import "BusinessActivity.h"
#import "LicenseActivity.h"
#import "SOQLQueries.h"
#import "UIImageView+SFAttachment.h"
#import "ViewStatementListViewController.h"
#import "UIButton+Additions.h"

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
    //[self setupHomeButton:self.logoutButton TitleKey:@"homeLogoutButton"];
    [self setupHomeButton:self.quickAccessInfoButton TitleKey:@"homeQuickAccessButton"];
    [self setupHomeButton:self.reportsButton TitleKey:@"homeReportsButton"];
    [self setupHomeButton:self.companyInfoButton TitleKey:@"homeCompanyInfoButton"];
    
    [self.notificationButton setupButtonWithBadgeOnImage:0];
    
    shouldLoadLicenseInfo = YES;
    
    [self setLogoutNavBarButton];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
    //Show Notification Count in Homepage
    //[self loadNotificationsCount];
    
    [self setNotificationNumberBadge];
    [self loadCompanyInfoWithLicenseInfo:shouldLoadLicenseInfo andNotificationCount:YES];
    shouldLoadLicenseInfo = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNotificationNumberBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[Globals notificationsCount] integerValue];
    [self.notificationButton setupButtonWithBadgeOnImage:[[Globals notificationsCount] integerValue]];
}

- (void)loadCompanyInfoWithLicenseInfo:(BOOL)shouldLoadLicenseInfo andNotificationCount:(BOOL)shouldLoadNotificationCount {
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            loadingCompanyInfo = NO;
            [self hideLoadingAlertView];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DWC" message:@"An error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        
        NSDictionary *accountDict = [[dict objectForKey:@"Contact"] objectForKey:@"Account"];
        
        Account *account = [[Account alloc] initAccount:accountDict];
        
        [Globals setCurrentAccount:account];
        
        [Globals setContactId:[dict objectForKey:@"ContactId"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingCompanyInfo = NO;
            [self hideLoadingAlertView];
            
            [self refreshLabels];
            
            if (shouldLoadNotificationCount)
                [self loadNotificationsCount];
            
            if (shouldLoadLicenseInfo)
                [self loadLicenseInfo];
        });
        
    };
    
    
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    
    
    NSArray *fields = @[@"ContactId, Contact.Name", @"Contact.Account.Id", @"Contact.Account.Account_Balance__c", @"Contact.Account.Portal_Balance__c", @"Contact.Account.Name", @"Contact.Account.License_Number_Formula__c", @"Contact.Account.BillingCity", @"Contact.Account.Company_Registration_Date__c", @"Contact.Account.Legal_Form__c", @"Contact.Account.Registration_Number_Value__c", @"Contact.Account.Phone", @"Contact.Account.Fax", @"Contact.Account.Email__c", @"Contact.Account.Mobile__c", @"Contact.Account.PRO_Email__c", @"Contact.Account.PRO_Mobile_Number__c", @"Contact.Account.BillingStreet", @"Contact.Account.BillingPostalCode", @"Contact.Account.BillingCountry", @"Contact.Account.BillingState", @"Contact.Account.Current_License_Number__r.Id", @"Contact.Account.Current_License_Number__r.License_Issue_Date__c", @"Contact.Account.Current_License_Number__r.License_Expiry_Date__c", @"Contact.Account.Current_License_Number__r.Commercial_Name__c", @"Contact.Account.Current_License_Number__r.Commercial_Name_Arabic__c", @"Contact.Account.Current_License_Number__r.License_Number_Value__c", @"Contact.Account.Current_License_Number__r.Validity_Status__c", @"Contact.Account.Current_License_Number__r.RecordType.Id", @"Contact.Account.Current_License_Number__r.RecordType.Name", @"Contact.Account.Current_License_Number__r.RecordType.DeveloperName", @"Contact.Account.Current_License_Number__r.RecordType.SObjectType", @"Contact.Account.Company_Logo__c"];
    
    loadingCompanyInfo = YES;
    [self showLoadingAlertView];
    
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
            loadingLicenseInfo = NO;
            [self hideLoadingAlertView];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DWC" message:@"An error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        
        NSMutableArray *licenseActivityMutableArray = [NSMutableArray new];
        
        for (NSDictionary *licenseActivityDict in [dict objectForKey:@"records"]) {
            [licenseActivityMutableArray addObject:[[LicenseActivity alloc] initLicenseActivity:licenseActivityDict]];
        }
        
        [Globals currentAccount].currentLicenseNumber.licenseActivityArray = [NSArray arrayWithArray:licenseActivityMutableArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingLicenseInfo = NO;
            [self hideLoadingAlertView];
        });
        
    };
    
    loadingLicenseInfo = YES;
    [self showLoadingAlertView];
    
    [[SFRestAPI sharedInstance]
     performSOQLQuery:[SOQLQueries licenseActivityQueryForLicenseId:[Globals currentAccount].currentLicenseNumber.Id]
     failBlock:errorBlock
     completeBlock:successBlock];
    
}

- (void)loadNotificationsCount {
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            loadingNotificationsCount = NO;
            [self hideLoadingAlertView];
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingNotificationsCount = NO;
            [self hideLoadingAlertView];
            
            for (NSDictionary *record in [dict objectForKey:@"records"]) {
                NSNumber *notificationsCount = [record objectForKey:@"expr0"];
                [Globals setNotificationsCount:notificationsCount];
                [self setNotificationNumberBadge];
            }
        });
    };
    
    loadingNotificationsCount = YES;
    [self showLoadingAlertView];
    
    [[SFRestAPI sharedInstance]
     performSOQLQuery:[SOQLQueries notificationsCountQuery]
     failBlock:errorBlock
     completeBlock:successBlock];
}

- (void)refreshLabels {
    [self.companyLogoImageView loadImageFromSFAttachment:[Globals currentAccount].companyLogo placeholderImage:nil];
    [self.companyNameValueLabel setText:[Globals currentAccount].name];
    [self.licenseNumberValueLabel setText:[Globals currentAccount].licenseNumberFormula];
    [self.licenseExpiryDateValueLabel setText:[HelperClass formatDateToString:[Globals currentAccount].currentLicenseNumber.licenseExpiryDate]];
    
    NSString *balanceStr = [HelperClass formatNumberToString:[Globals currentAccount].portalBalance FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2];
    
    [self.currentBalanceValueLabel setText:[NSString stringWithFormat:@"%@ AED", balanceStr]];
}

- (void)setupHomeButton:(UIButton*)button TitleKey:(NSString*)titleKey {
    [button setTitle:NSLocalizedString(titleKey, @"") forState:UIControlStateNormal];
    [button setupButtonWithTextUnderImage];
}

- (void)logoutButtonClicked:(id)sender {
    [HelperClass showLogoutConfirmationDialog:self];
}

- (void)showLoadingAlertView {
    if (![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingAlertView {
    if (loadingCompanyInfo || loadingLicenseInfo || loadingNotificationsCount)
        return;
    
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

- (void)setLogoutNavBarButton {
    UIBarButtonItem *logoutBarButtonItem = [UIBarButtonItem new];
    logoutBarButtonItem.image = [UIImage imageNamed:@"Navigation Bar Logout Icon"];
    logoutBarButtonItem.target = self;
    logoutBarButtonItem.action = @selector(logoutButtonClicked:);
    
    self.navigationItem.rightBarButtonItem = logoutBarButtonItem;
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
    else if ([segueIdentifier isEqualToString:@"CompanyDocumentsSlidingMenuSegue"])
        initialSegueID = [NSString stringWithFormat:@"%@%@", SWSegueFrontIdentifier, @"_companyDocs"];
    else if ([segueIdentifier isEqualToString:@"DashboardSlidingMenuSegue"])
        initialSegueID = [NSString stringWithFormat:@"%@%@", SWSegueFrontIdentifier, @"_dashboard"];
    else if ([segueIdentifier isEqualToString:@"ViewStatementSlidingMenuSegue"])
        initialSegueID = [NSString stringWithFormat:@"%@%@", SWSegueFrontIdentifier, @"_view_statement"];
    else if ([segueIdentifier isEqualToString:@"ReportsSlidingMenuSegue"])
        initialSegueID = [NSString stringWithFormat:@"%@%@", SWSegueFrontIdentifier, @"_reports"];
    
    destinationVC.initialSegueIdentifier = initialSegueID;
    
}
//*/

@end
