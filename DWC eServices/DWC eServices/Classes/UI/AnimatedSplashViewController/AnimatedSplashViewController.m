//
//  AnimatedSplashViewController.m
//  iDWC
//
//  Created by Mina Zaklama on 6/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "AnimatedSplashViewController.h"
#import "UIImageView+AnimationCompletion.h"
#import "SFRestAPI+Blocks.h"
#import "SFUserAccountManager.h"
#import "Globals.h"
#import "Account.h"
#import "License.h"
#import "LicenseActivity.h"
#import "HelperClass.h"
#import "SOQLQueries.h"
#import "SFAuthenticationManager.h"

@interface AnimatedSplashViewController ()

@end

@implementation AnimatedSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self performSelector:@selector(loadCompanyInfoWithLicenseInfo) withObject:nil afterDelay:.5f];

    [self loadCompanyInfoWithLicenseInfo];
//                [self setupRootViewController];
//    [self setupAnimationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAnimationView {
    NSMutableArray *animationImagesArray = [NSMutableArray new];
    
    for (NSInteger index = 1; index <= 22; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Animation Screen %ld", (long)index]];
        //NSString *animationImageName = [NSString stringWithFormat:@"Animation Screen %ld", (long)index];
        [animationImagesArray addObject:image];
    }
    
    self.animationImageView.animationImages = animationImagesArray;
    self.animationImageView.animationRepeatCount = 1;
    self.animationImageView.animationDuration = 2.5;
    
    [self.animationImageView startAnimatingWithCompletionBlock:^(BOOL success) {
    
        [self loadCompanyInfoWithLicenseInfo];
    
    }];
    
    self.animationImageView.image = [UIImage imageNamed:@"Animation Screen 22"];
    [self.animationImageView startAnimating];
    
    
}

- (void)setupRootViewController {
    //RootViewController *rootVC = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    //UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc =[storybord instantiateInitialViewController];
    
    [self presentViewController:vc animated:NO completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)loadCompanyInfoWithLicenseInfo {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DWC" message:@"An error has been occured please re-login" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
            
            [[SFAuthenticationManager sharedManager] logout];
            
        });
        
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSDictionary *accountDict = [[dict objectForKey:@"Contact"] objectForKey:@"Account"];
        Account *account = [[Account alloc] initAccount:accountDict];
        [Globals setCurrentAccount:account];
        [Globals setContactId:[dict objectForKey:@"ContactId"]];
        [Globals setContactPersonalPhoto:[HelperClass stringCheckNull:[[dict objectForKey:@"Contact"] objectForKey:@"Personal_Photo__c"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadLicenseInfo];
        });
        
    };
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    NSArray *fields = @[@"ContactId", @"Contact.Name", @"Contact.Personal_Photo__c", @"Contact.Account.Id", @"Contact.Account.Account_Balance__c", @"Contact.Account.Portal_Balance__c", @"Contact.Account.Name", @"Contact.Account.Arabic_Account_Name__c", @"Contact.Account.License_Number_Formula__c", @"Contact.Account.BillingCity", @"Contact.Account.Company_Registration_Date__c", @"Contact.Account.Legal_Form__c", @"Contact.Account.Registration_Number_Value__c", @"Contact.Account.Phone", @"Contact.Account.Fax", @"Contact.Account.Email__c", @"Contact.Account.Mobile__c", @"Contact.Account.PRO_Email__c", @"Contact.Account.PRO_Mobile_Number__c", @"Contact.Account.BillingStreet", @"Contact.Account.BillingPostalCode", @"Contact.Account.BillingCountry", @"Contact.Account.BillingState", @"Contact.Account.Current_License_Number__r.Id", @"Contact.Account.Current_License_Number__r.License_Issue_Date__c", @"Contact.Account.Current_License_Number__r.License_Expiry_Date__c", @"Contact.Account.Current_License_Number__r.Commercial_Name__c", @"Contact.Account.Current_License_Number__r.Commercial_Name_Arabic__c", @"Contact.Account.Current_License_Number__r.License_Number_Value__c", @"Contact.Account.Current_Manager__r.Id", @"Contact.Account.Current_License_Number__r.Validity_Status__c", @"Contact.Account.Current_License_Number__r.RecordType.Id", @"Contact.Account.Current_License_Number__r.RecordType.Name", @"Contact.Account.Current_License_Number__r.RecordType.DeveloperName", @"Contact.Account.Current_License_Number__r.RecordType.SObjectType", @"Contact.Account.Company_Logo__c"];
    
    [self.activityIndicator startAnimating];
    
    [[SFRestAPI sharedInstance] performRetrieveWithObjectType:@"User"
                                                     objectId:accountManager.currentUser.credentials.userId
                                                    fieldList:fields
                                                    failBlock:errorBlock
                                                completeBlock:successBlock];
}

- (void)loadLicenseInfo {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
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
            [self setupRootViewController];
        });
        
    };
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries licenseActivityQueryForLicenseId:[Globals currentAccount].currentLicenseNumber.Id]
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
