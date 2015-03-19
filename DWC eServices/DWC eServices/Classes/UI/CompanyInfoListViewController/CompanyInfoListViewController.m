//
//  CompanyInfoListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyInfoListViewController.h"
#import "CompanyInfoListTableViewCell.h"
#import "DWCCompanyInfo.h"
#import "FVCustomAlertView.h"
#import "SFRestAPI+Blocks.h"
#import "RecordMainViewController.h"
#import "Globals.h"
#import "Account.h"
#import "ShareOwnership.h"
#import "ManagementMember.h"
#import "Directorship.h"
#import "LegalRepresentative.h"
#import "TenancyContract.h"
#import "HelperClass.h"
#import "Passport.h"
#import "TableViewSectionField.h"
#import "TableViewSection.h"

@interface CompanyInfoListViewController ()

@end

@implementation CompanyInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            [self loadCompanyShareholders];
            break;
        case DWCCompanyInfoGeneralManagers:
            [self loadCompanyManagers];
            break;
        case DWCCompanyInfoDirectors:
            [self loadCompanyDirectors];
            break;
        case DWCCompanyInfoLegalRepresentative:
            [self loadCompanyLegalRepresentatives];
            break;
        case DWCCompanyInfoLeasingInfo:
            [self loadTenancyContracts];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCompanyShareholders {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            NSDictionary *shareholderDict = [recordDict objectForKey:@"Shareholder__r"];
            Account *shareholder;
            if (![shareholderDict isKindOfClass:[NSNull class]]) {
                NSDictionary *passportDict = [shareholderDict objectForKey:@"Current_Passport__r"];
                Passport *passport;
                if (![passportDict isKindOfClass:[NSNull class]]) {
                    passport = [[Passport alloc] initPassport:[passportDict objectForKey:@"Id"]
                                               PassportNumber:[passportDict objectForKey:@"Name"]
                                                 PassportType:[passportDict objectForKey:@"Passport_Type__c"]
                                         PassportPlaceOfIssue:[passportDict objectForKey:@"Passport_Place_of_Issue__c"]
                                            PassportIssueDate:[passportDict objectForKey:@"Passport_Issue_Date__c"]
                                           PassportExpiryDate:[passportDict objectForKey:@"Passport_Expiry_Date__c"]];
                }
                
                shareholder = [[Account alloc] initAccount:[shareholderDict objectForKey:@"Id"]
                                                      Name:[shareholderDict objectForKey:@"Name"]
                                               Nationality:[shareholderDict objectForKey:@"Nationality__c"]
                                           AccountPassport:passport];
            }
            
            [dataRows addObject:[[ShareOwnership alloc] initShareOwnership:[recordDict objectForKey:@"Id"]
                                                                NoOfShares:(NSNumber*)[recordDict objectForKey:@"No_of_Shares__c"]
                                                          OwnershipOfShare:(NSNumber*)[recordDict objectForKey:@"Ownership_of_Share__c"]
                                                         ShareholderStatus:[recordDict objectForKey:@"Shareholder_Status__c"]
                                                        OwnershipStartDate:[recordDict objectForKey:@"Ownership_Start_Date__c"]
                                                          OwnershipEndDate:[recordDict objectForKey:@"Ownership_End_Date__c"]
                                                               Shareholder:shareholder]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
}

- (void)loadCompanyManagers {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            NSDictionary *managerDict = [recordDict objectForKey:@"Manager__r"];
            Account *manager;
            if (![managerDict isKindOfClass:[NSNull class]]) {
                NSDictionary *passportDict = [managerDict objectForKey:@"Current_Passport__r"];
                Passport *passport;
                if (![passportDict isKindOfClass:[NSNull class]]) {
                    passport = [[Passport alloc] initPassport:[passportDict objectForKey:@"Id"]
                                               PassportNumber:[passportDict objectForKey:@"Name"]
                                                 PassportType:[passportDict objectForKey:@"Passport_Type__c"]
                                         PassportPlaceOfIssue:[passportDict objectForKey:@"Passport_Place_of_Issue__c"]
                                            PassportIssueDate:[passportDict objectForKey:@"Passport_Issue_Date__c"]
                                           PassportExpiryDate:[passportDict objectForKey:@"Passport_Expiry_Date__c"]];
                }
                
                manager = [[Account alloc] initAccount:[managerDict objectForKey:@"Id"]
                                                  Name:[managerDict objectForKey:@"Name"]
                                           Nationality:[managerDict objectForKey:@"Nationality__c"]
                                       AccountPassport:passport];
            }
            
            [dataRows addObject:[[ManagementMember alloc] initManagementMember:[recordDict objectForKey:@"Id"]
                                                                 ManagerStatus:[recordDict objectForKey:@"Manager_Status__c"]
                                                                          Role:[recordDict objectForKey:@"Role__c"]
                                                                        Status:[recordDict objectForKey:@"Status__c"]
                                                              ManagerStartDate:[recordDict objectForKey:@"Manager_Start_Date__c"]
                                                                ManagerEndDate:[recordDict objectForKey:@"Manager_End_Date__c"]
                                                                       Manager:manager]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadCompanyDirectors {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        
        for (NSDictionary *recordDict in records) {
            NSDictionary *directorDict = [recordDict objectForKey:@"Director__r"];
            Account *director;
            if (![directorDict isKindOfClass:[NSNull class]]) {
                director = [[Account alloc] initAccount:[directorDict objectForKey:@"Id"]
                                                   Name:[directorDict objectForKey:@"Name"]];
            }
            
            [dataRows addObject:[[Directorship alloc] initDirectorship:[recordDict objectForKey:@"Id"]
                                                                 Roles:[recordDict objectForKey:@"Roles__c"]
                                                        DirectorStatus:[recordDict objectForKey:@"Director_Status__c"]
                                                 DirectorshipStartDate:[recordDict objectForKey:@"Directorship_Start_Date__c"]
                                                   DirectorshipEndDate:[recordDict objectForKey:@"Directorship_End_Date__c"]
                                                              Director:director]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadCompanyLegalRepresentatives {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        for (NSDictionary *recordDict in records) {
            NSDictionary *legalRepresentativeDict = [recordDict objectForKey:@"Legal_Representative__r"];
            Account *legalRepresentative;
            if (![legalRepresentativeDict isKindOfClass:[NSNull class]]) {
                legalRepresentative = [[Account alloc] initAccount:[legalRepresentativeDict objectForKey:@"Id"]
                                                              Name:[legalRepresentativeDict objectForKey:@"Name"]];
            }
            
            [dataRows addObject:[[LegalRepresentative alloc]
                                 initLegalRepresentative:[recordDict objectForKey:@"Id"]
                                 Role:[recordDict objectForKey:@"Role__c"]
                                 Status:[recordDict objectForKey:@"Status__c"]
                                 LegalRepresentativeStartDate:[recordDict objectForKey:@"Legal_Representative_Start_Date__c"]
                                 LegalRepresentativeEndDate:[recordDict objectForKey:@"Legal_Representative_End_Date__c"]
                                 LegalRepresentative:legalRepresentative]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDWCCompanyInfo.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadTenancyContracts {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *records = [dict objectForKey:@"records"];
        
        dataRows = [NSMutableArray new];
        for (NSDictionary *recordDict in records) {
            [dataRows addObject:[[TenancyContract alloc] initTenanctContract:[recordDict objectForKey:@"Id"]
                                                                        Name:[recordDict objectForKey:@"Name"]
                                                                ContractType:[recordDict objectForKey:@"Contract_Type__c"]
                                                                      Status:[recordDict objectForKey:@"Status__c"]
                                                       ContractDurationMonth:[recordDict objectForKey:@"Contract_Duration_Year_Month__c"]
                                                               ActivatedDate:[recordDict objectForKey:@"Activated_Date__c"]
                                                               RentStartDate:[recordDict objectForKey:@"Rent_Start_date__c"]
                                                           ContractStartDate:[recordDict objectForKey:@"Contract_Start_Date__c"]
                                                          ContractExpiryDate:[recordDict objectForKey:@"Contract_Expiry_Date__c"]
                                                              TotalRentPrice:[recordDict objectForKey:@"Total_Rent_Price__c"]
                                                        ContractDurationYear:[recordDict objectForKey:@"Contract_Duration__c"]
                                                                IsBCContract:[[recordDict objectForKey:@"IS_BC_Contract__c"] boolValue]]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    SFRestRequest *payAndSubmitRequest = [[SFRestRequest alloc] init];
    payAndSubmitRequest.endpoint = [NSString stringWithFormat:@"/services/apexrest/MobileTenantContractsWebService"];
    payAndSubmitRequest.method = SFRestMethodGET;
    payAndSubmitRequest.path = @"/services/apexrest/MobileTenantContractsWebService";
    payAndSubmitRequest.queryParams = [NSDictionary dictionaryWithObject:[Globals currentAccount].Id forKey:@"AccountId"];
    
    [[SFRestAPI sharedInstance] send:payAndSubmitRequest delegate:self];
}

- (UITableViewCell *)cellContractsForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    TenancyContract *currentTenancyContract = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentTenancyContract.name;
    cell.roleLabel.text = NSLocalizedString(@"ExpiryLabel", @"");
    cell.roleValueLabel.text = [HelperClass formatDateToString:currentTenancyContract.contractExpiryDate];
    
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (UITableViewCell *)cellShareholdersForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    ShareOwnership *currentShareOwnership = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentShareOwnership.shareholder.name;
    cell.roleValueLabel.text = @"Shareholder";
    cell.shareOwnershipValueLabel.text = [NSString stringWithFormat:@"%@ %%",[HelperClass formatNumberToString:currentShareOwnership.ownershipOfShare FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2]];
    
    return cell;
}

- (UITableViewCell *)cellManagersForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    ManagementMember *currentManagementMember = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentManagementMember.manager.name;
    cell.roleValueLabel.text = currentManagementMember.role;
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (UITableViewCell *)cellDirectorsForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    Directorship *currentDirectorship = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentDirectorship.director.name;
    cell.roleValueLabel.text = currentDirectorship.roles;
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (UITableViewCell *)cellLegalRepresentativeForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CompanyInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Company Info List Cell" forIndexPath:indexPath];
    
    LegalRepresentative *currentLegalRepresentative = [dataRows objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentLegalRepresentative.legalRepresentative.name;
    cell.roleValueLabel.text = currentLegalRepresentative.role;
    cell.shareOwnershipValueLabel.hidden = YES;
    cell.shareOwnershipLabel.hidden = YES;
    
    return cell;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForShareholder:(ShareOwnership *)shareOwnership {
    recordVC.NameValue = shareOwnership.shareholder.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderName", @"")
                            FieldValue:shareOwnership.shareholder.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderNationality", @"")
                            FieldValue:shareOwnership.shareholder.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderPassportNumber", @"")
                            FieldValue:shareOwnership.shareholder.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderPassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.shareholder.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ShareholderPersonalInformation", @"")
                              Fields:fieldsArray]];
    
    
    NSString *ownershipPercent = [NSString stringWithFormat:@"%@ %%",[HelperClass formatNumberToString:shareOwnership.ownershipOfShare FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderOwnership", @"")
                            FieldValue:ownershipPercent]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderNoOfShare", @"")
                            FieldValue:[HelperClass formatNumberToString:shareOwnership.noOfShares
                                                             FormatStyle:NSNumberFormatterDecimalStyle
                                                   MaximumFractionDigits:2]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.ownershipStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ShareholderEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:shareOwnership.ownershipEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ShareholderInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

- (void)configureRecordMainViewController:(RecordMainViewController*)recordVC ForManager:(ManagementMember *)managementMember {
    
    recordVC.NameValue = managementMember.manager.name;
    //recordVC.PhotoId = ;
    NSMutableArray *sectionsArray = [NSMutableArray new];
    
    NSMutableArray *fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerName", @"")
                            FieldValue:managementMember.manager.name]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerNationality", @"")
                            FieldValue:managementMember.manager.nationality]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerPassportNumber", @"")
                            FieldValue:managementMember.manager.currentPassport.passportNumber]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerPassportExpiry", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.manager.currentPassport.passportExpiryDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ManagerPersonalInformation", @"")
                              Fields:fieldsArray]];
    
    fieldsArray = [NSMutableArray new];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerRole", @"")
                            FieldValue:managementMember.role]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerStartDate", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.managerStartDate]]];
    [fieldsArray addObject:[[TableViewSectionField alloc]
                            initTableViewSectionField:NSLocalizedString(@"ManagerEndDate", @"")
                            FieldValue:[HelperClass formatDateToString:managementMember.managerEndDate]]];
    
    [sectionsArray addObject:[[TableViewSection alloc]
                              initTableViewSection:NSLocalizedString(@"ManagerInformation", @"")
                              Fields:fieldsArray]];
    
    recordVC.DetailsSectionsArray = sectionsArray;
    
    NSUInteger servicesMask = 0;
    
    recordVC.RelatedServicesMask = servicesMask;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell;
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            cell = [self cellShareholdersForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyInfoGeneralManagers:
            cell = [self cellManagersForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyInfoDirectors:
            cell = [self cellDirectorsForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyInfoLegalRepresentative:
            cell = [self cellLegalRepresentativeForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyInfoLeasingInfo:
            cell = [self cellContractsForRowAtIndexPath:indexPath tableView:tableView];
            break;
        default:
            break;
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    RecordMainViewController *recordMainVC = [storybord instantiateViewControllerWithIdentifier:@"RecordMainViewController"];
    
    switch (self.currentDWCCompanyInfo.Type) {
        case DWCCompanyInfoShareholders:
            [self configureRecordMainViewController:recordMainVC ForShareholder:[dataRows objectAtIndex:indexPath.row]];
            break;
        case DWCCompanyInfoGeneralManagers:
            [self configureRecordMainViewController:recordMainVC ForManager:[dataRows objectAtIndex:indexPath.row]];
            break;
        case DWCCompanyInfoDirectors:
            break;
        case DWCCompanyInfoLegalRepresentative:
            break;
        case DWCCompanyInfoLeasingInfo:
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:recordMainVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", resultsArray);
    
    dataRows = [NSMutableArray new];
    for (NSDictionary *recordDict in resultsArray) {
        [dataRows addObject:[[TenancyContract alloc] initTenanctContract:[recordDict objectForKey:@"Id"]
                                                                    Name:[recordDict objectForKey:@"Name"]
                                                            ContractType:[recordDict objectForKey:@"Contract_Type__c"]
                                                                  Status:[recordDict objectForKey:@"Status__c"]
                                                   ContractDurationMonth:[recordDict objectForKey:@"Contract_Duration_Year_Month__c"]
                                                           ActivatedDate:[recordDict objectForKey:@"Activated_Date__c"]
                                                           RentStartDate:[recordDict objectForKey:@"Rent_Start_date__c"]
                                                       ContractStartDate:[recordDict objectForKey:@"Contract_Start_Date__c"]
                                                      ContractExpiryDate:[recordDict objectForKey:@"Contract_Expiry_Date__c"]
                                                          TotalRentPrice:[recordDict objectForKey:@"Total_Rent_Price__c"]
                                                    ContractDurationYear:[recordDict objectForKey:@"Contract_Duration__c"]
                                                            IsBCContract:[[recordDict objectForKey:@"IS_BC_Contract__c"] boolValue]]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        
        [self.tableView reloadData];
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
    });
#warning Handle error
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
