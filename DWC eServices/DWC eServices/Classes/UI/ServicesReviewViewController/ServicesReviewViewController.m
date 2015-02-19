//
//  ServicesReviewViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ServicesReviewViewController.h"
#import "SFRestAPI+Blocks.h"
#import "HelperClass.h"
#import "EServiceAdministration.h"
#import "EServiceDocument.h"
#import "Globals.h"
#import "Account.h"
#import "FVCustomAlertView.h"

@interface ServicesReviewViewController ()

@end

@implementation ServicesReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createCaseRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCaseRecord {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        if (dict != nil)
            insertedCaseId = [dict objectForKey:@"id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createServiceRecord:insertedCaseId];
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
        
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil
                                           withTitle:NSLocalizedString(@"loading", @"")
                                            withBlur:YES];
    
    if(insertedCaseId != nil && ![insertedCaseId  isEqual: @""])
        [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Case"
                                                       objectId:insertedCaseId
                                                         fields:self.caseFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
    else
        [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Case"
                                                         fields:self.caseFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
}

- (void)createServiceRecord:(NSString*)caseId {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        if (dict != nil)
            insertedServiceId = [dict objectForKey:@"id"];
        
        [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        
        [self createCompanyDocuments:insertedServiceId
                                ParentField:self.serviceObject
                                   Document:self.currentServiceAdministration.serviceDocumentsArray
                                  CompanyID:[Globals currentAccount].Id];
        
        [self updateCaseObject:caseId ServiceId:insertedServiceId];

    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
        
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil
                                           withTitle:NSLocalizedString(@"loading", @"")
                                            withBlur:YES];
    
    if (insertedServiceId != nil && ![insertedServiceId isEqualToString:@""])
        [[SFRestAPI sharedInstance] performUpdateWithObjectType:self.serviceObject
                                                       objectId:insertedServiceId
                                                         fields:self.serviceFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
    else
        [[SFRestAPI sharedInstance] performCreateWithObjectType:self.serviceObject
                                                         fields:self.serviceFields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
}

- (void)updateCaseObject:(NSString*)caseId ServiceId:(NSString*)ServiceId {
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            ServiceId, self.serviceObject,
                            nil];
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning TODO
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Case"
                                                   objectId:caseId
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
}

- (void)createCompanyDocuments:(NSString*)parentID ParentField:(NSString*)parentField Document:(NSArray*)documentsArray CompanyID:(NSString*)companyId {
    for (EServiceDocument *doc in documentsArray) {
        NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                                doc.name, @"Name",
                                doc.Id, @"eServices_Document__c",
                                companyId, @"Company__c",
                                parentID, parentField,
                                nil];
        
        void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
            NSString *companyDocumentId = [dict objectForKey:@"id"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addAttachment:doc.name ToParent:companyDocumentId DocumentImage:doc.attachment];
            });
        };
        
        void (^errorBlock) (NSError*) = ^(NSError *e) {
        };
        
        [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Company_Documents__c"
                                                         fields:fields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
    }
}

- (void)addAttachment:(NSString*)documentName ToParent:(NSString*) parentID DocumentImage:(NSData*)attachment {
    //UIImage *resizedImage = [HelperClass imageWithImage:image ScaledToSize:CGSizeMake(480, 640)];
    
    NSString *string = [attachment base64EncodedStringWithOptions:0];
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            documentName, @"Name",
                            @"image", @"ContentType",
                            parentID, @"ParentId",
                            string, @"Body",
                            nil];
    SFRestRequest *attachmentRequest = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Attachment" fields:fields];
    
    [[SFRestAPI sharedInstance] send:attachmentRequest delegate:nil];
    
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
