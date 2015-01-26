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

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home NavBar DWC Logo"]];
    
    [HelperClass setupButtonWithTextUnderImage:self.dashboardButton];
    [HelperClass setupButtonWithTextUnderImage:self.employeesButton];
    [HelperClass setupButtonWithTextUnderImage:self.myRequestButton];
    [HelperClass setupButtonWithTextUnderImage:self.notificationButton];
    [HelperClass setupButtonWithTextUnderImage:self.quickAccessButton];
    [HelperClass setupButtonWithTextUnderImage:self.needHelpButton];
    [HelperClass setupButtonWithTextUnderImage:self.logoutButton];
    [HelperClass setupButtonWithTextUnderImage:self.reportsButton];
    [HelperClass setupButtonWithTextUnderImage:self.servicesButton];
    
    [HelperClass setupButtonWithBadgeOnImage:self.notificationButton Value:0];
    
    [self loadCompanyInfo];
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
            
        });
        
    };
    
    
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    
    
    NSArray *fields = @[@"ContactId, Contact.Name", @"Contact.Account.Id", @"Contact.Account.Account_Balance__c", @"Contact.Account.Name", @"Contact.Account.License_Number_Formula__c", @"Contact.Account.BillingCity", @"Contact.Account.BillingCountryCode", @"Contact.Account.License_Expiry_Date_Formula__c"];
    
    [[SFRestAPI sharedInstance] performRetrieveWithObjectType:@"User"
                                                     objectId:accountManager.currentUser.credentials.userId
                                                    fieldList:fields
                                                    failBlock:errorBlock
                                                completeBlock:successBlock];
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
