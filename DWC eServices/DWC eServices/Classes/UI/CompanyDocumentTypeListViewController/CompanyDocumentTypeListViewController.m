//
//  CompanyDocumentTypeListViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CompanyDocumentTypeListViewController.h"
#import "SFRestAPI+Blocks.h"
#import "FVCustomAlertView.h"
#import "DWCCompanyDocument.h"
#import "CompanyDocument.h"
#import "EServicesDocumentChecklist.h"
#import "CustomerDocumentTableViewCell.h"
#import "DWCDocumentTableViewCell.h"
#import "HelperClass.h"
#import "VisualforceWebviewViewController.h"
#import "Globals.h"
#import "Account.h"
#import "BaseServicesViewController.h"
#import "EServiceAdministration.h"
#import "RecordType.h"

@interface CompanyDocumentTypeListViewController ()

@end

@implementation CompanyDocumentTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showSlidingMenu = NO;
    
    [self loadDocuments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDocuments {
    switch (self.currentDocumentType.Type) {
        case DWCCompanyDocumentTypeCustomerDocument:
            [self loadCustomerCompanyDocuments];
            break;
        case DWCCompanyDocumentTypeDWCDocument:
            [self loadDWCCompanyDocuments];
            break;
        default:
            break;
    }
}

- (void)loadDWCCompanyDocuments {
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
            [dataRows addObject:[[EServicesDocumentChecklist alloc] initEServicesDocumentChecklist:recordDict]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDocumentType.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadCustomerCompanyDocuments {
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
            [dataRows addObject:[[CompanyDocument alloc] initCompanyDocument:recordDict]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self.tableView reloadData];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:self.currentDocumentType.SOQLQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)confirmDeleteCustomerDocument:(CompanyDocument *)document {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DeleteAlertTitle", @"")
                                                                   message:NSLocalizedString(@"DeleteDocumentAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DocumentDeleteAction", @"")
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             [self deleteCustomerDocument:document];
                                                         }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteCustomerDocument:(CompanyDocument *)document {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self loadDocuments];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performDeleteWithObjectType:@"Company_Documents__c"
                                                   objectId:document.Id
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
}

- (void)openVisualforcePage:(NSString *)url {
    VisualforceWebviewViewController *vfWebviewVC = [VisualforceWebviewViewController new];
    
    vfWebviewVC.returnURL = url;
    
    [self.navigationController pushViewController:vfWebviewVC animated:YES];
}

- (void)requestForOriginalRecordType:(EServicesDocumentChecklist *)eServicesDocumentChecklist {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSArray *recordTypesArray = [dict objectForKey:@"records"];
        RecordType *caseRecordType;
        for (NSDictionary *obj in recordTypesArray) {
            
            caseRecordType = [[RecordType alloc] initRecordType:obj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [self requestForOriginalDocument:eServicesDocumentChecklist recordType:caseRecordType];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning handle error here
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'Registration_Request'";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)requestForOriginalDocument:(EServicesDocumentChecklist *)eServicesDocumentChecklist recordType:(RecordType *)recordType {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BaseServicesViewController *baseServicesVC = [storybord instantiateViewControllerWithIdentifier:@"BaseServicesViewController"];
    
    baseServicesVC.currentWebformId = eServicesDocumentChecklist.eServiceAdministration.editNewVFGenerator;
    baseServicesVC.currentServiceAdministration = eServicesDocumentChecklist.eServiceAdministration;
    baseServicesVC.relatedServiceType = RelatedServiceTypeRegistrationDocuments;
    baseServicesVC.createServiceRecord = NO;
    
    baseServicesVC.caseFields = [NSDictionary dictionaryWithObjectsAndKeys:
                                 eServicesDocumentChecklist.eServiceAdministration.Id, @"Service_Requested__c",
                                 eServicesDocumentChecklist.eServiceAdministration.editNewVFGenerator, @"Visual_Force_Generator__c",
                                 [Globals currentAccount].Id, @"AccountId",
                                 recordType.Id, @"RecordTypeId",
                                 @"Draft", @"Status",
                                 @"Registration Services", @"Type",
                                 @"Mobile", @"Origin",
                                 nil];
    
    baseServicesVC.parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [Globals currentAccount].Id, @"accountID",
                                 [Globals currentAccount].name, @"actName",
                                 nil];
    
    //[baseServicesVC nextButtonClicked:ServiceFlowInitialPage];
    
    [self.navigationController pushViewController:baseServicesVC animated:YES];
}

- (UITableViewCell *)cellDWCCompanyDocumentForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    DWCDocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWC Document Cell" forIndexPath:indexPath];
    
    EServicesDocumentChecklist *eServicesDocumentChecklist = [dataRows objectAtIndex:indexPath.row];
    
    cell.documentNameLabel.text = eServicesDocumentChecklist.name;
    
    return cell;
}

- (UITableViewCell *)cellCustomerCompanyDocumentForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CustomerDocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Customer Document Cell"
                                                                          forIndexPath:indexPath];
    
    CompanyDocument *companyDocument = [dataRows objectAtIndex:indexPath.row];
    
    cell.documentNameLabel.text = companyDocument.name;
    if (![companyDocument.version isKindOfClass:[NSNull class]])
        cell.documentVersionLabel.text = [NSString stringWithFormat:@"V%@", companyDocument.version];
    else
        cell.documentVersionLabel.text = @"V0";
    
    cell.documentDateLabel.text = [HelperClass formatDateToString:companyDocument.createdDate];
    
    return cell;
}

- (void)customerDocumentaccessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    CompanyDocument *companyDocument = [dataRows objectAtIndex:indexPath.row];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DocumentAction", @"")
                                                                         message:@""
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DocumentEditAction", @"")
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                       }];
    
    UIAlertAction *previewAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DocumentPreviewAction", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              NSString *url = [NSString stringWithFormat:@"servlet/servlet.FileDownload?file=%@", companyDocument.attachmentId];
                                                              
                                                              [self openVisualforcePage:url];
                                                          }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DocumentDeleteAction", @"")
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             [self confirmDeleteCustomerDocument:companyDocument];
                                                         }];
    
    [actionSheet addAction:editAction];
    
    if (![companyDocument.attachmentId isEqualToString:@""])
        [actionSheet addAction:previewAction];
    
    if (companyDocument.customerDocument)
        [actionSheet addAction:deleteAction];
    
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)dwcDocumentaccessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    EServicesDocumentChecklist *eServicesDocumentChecklist = [dataRows objectAtIndex:indexPath.row];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DocumentAction", @"")
                                                                         message:@""
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    if (eServicesDocumentChecklist.availableForPreview) {
        UIAlertAction *previewAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DocumentPreviewAction", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  
                                                                  NSString *url = [NSString stringWithFormat:@"/apex/%@%@", eServicesDocumentChecklist.templateNameLink, [Globals currentAccount].Id];
                                                                  
                                                                  [self openVisualforcePage:url];
                                                              }];
        
        [actionSheet addAction:previewAction];
    }
    
    if (eServicesDocumentChecklist.originalCanBeRequested) {
        UIAlertAction *originalAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DocumentRequestOriginalAction", @"")
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [self requestForOriginalRecordType:eServicesDocumentChecklist];
                                                               }];
        
        [actionSheet addAction:originalAction];
    }
    
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
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
    UITableViewCell *cell;
    
    switch (self.currentDocumentType.Type) {
        case DWCCompanyDocumentTypeCustomerDocument:
            cell = [self cellCustomerCompanyDocumentForRowAtIndexPath:indexPath tableView:tableView];
            break;
        case DWCCompanyDocumentTypeDWCDocument:
            cell = [self cellDWCCompanyDocumentForRowAtIndexPath:indexPath tableView:tableView];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    switch (self.currentDocumentType.Type) {
        case DWCCompanyDocumentTypeCustomerDocument:
            [self customerDocumentaccessoryButtonTappedForRowWithIndexPath:indexPath];
            break;
        case DWCCompanyDocumentTypeDWCDocument:
            [self dwcDocumentaccessoryButtonTappedForRowWithIndexPath:indexPath];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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