//
//  UploadDocumentsView.m
//  iDWC
//
//  Created by George on 8/19/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "UploadDocumentsView.h"
#import "UIView+DynamicForm.h"
#import "EServiceAdministration.h"
#import "HelperClass.h"
#import "BaseServicesViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+Additions.h"
#import "DWCCompanyDocument.h"
#import "SOQLQueries.h"
#import "CompanyDocument.h"
#import "DWCSFRequestManager.h"
#import "RenewPassportSteperViewController.h"
#import "ServiceDocumentHelperClass.h"
#import "Globals.h"
#import "Account.h"

@implementation UploadDocumentsView

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"UploadDocumentsView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    return self;
}
-(void)loadEservice{
    [self loadEServiceAdministration];
}
- (void)loadEServiceAdministration {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"");
            [self hideLoadingDialog];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        DLog(@"");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            for (NSDictionary *recordDict in [dict objectForKey:@"records"]) {
                selectedEServiceAdministrator = [[EServiceAdministration alloc] initEServiceAdministration:recordDict];
                [self displayDocuments];
            }
        });
    };
    
    [self showLoadingDialog];
    NSString *serviceIdentifier = @"Passport Renewal";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries visaRenewServiceAdminQuery:serviceIdentifier]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}
- (void)displayDocuments {

    [self.myview drawAttachmentButtons:selectedEServiceAdministrator.serviceDocumentsArray  viewController:(RenewPassportSteperViewController*)self.delegate];
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)createCompanyDocuments:(NSArray *)documentsArray {
    totalAttachmentsToUpload = documentsArray.count;
    attachmentsReturned = 0;
    failedImagedArray = [NSMutableArray new];
    
    for (EServiceDocument *doc in documentsArray) {
        NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       doc.name, @"Name",
                                       doc.Id, @"eServices_Document__c",
                                       [Globals currentAccount].Id, @"Company__c",
                                       [(RenewPassportSteperViewController*)self.delegate getCaseID] , @"Request__c",
                                       nil];
        
        if (doc.existingDocument && doc.existingDocumentAttachmentId) {
            [fields setObject:doc.existingDocumentAttachmentId forKey:@"Attachment_Id__c"];
        }
        void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
            [self hideLoadingDialog];
            NSString *companyDocumentId = [dict objectForKey:@"id"];
            doc.companyDocumentId = companyDocumentId;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (doc.existingDocument) {
                    [self uploadDidReturn:doc attachmentId:doc.existingDocumentAttachmentId];
                }
                else
                    [self addAttachment:doc];
            });
        };
        
        void (^errorBlock) (NSError*) = ^(NSError *e) {
            [failedImagedArray addObject:doc];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadDidReturn:doc attachmentId:nil];
            });
        };
        
        [self showLoadingDialog];
        
        if (doc.companyDocumentId != nil && ![doc.companyDocumentId isEqualToString:@""] && !doc.attachmentUploaded && !doc.existingDocument) {
            [self addAttachment:doc];
        }
        else if (doc.companyDocumentId != nil && ![doc.companyDocumentId isEqualToString:@""] && doc.existingDocument) {
            fields = [NSMutableDictionary dictionaryWithObjectsAndKeys:doc.existingDocumentAttachmentId, @"Attachment_Id__c", nil];
            
            [[SFRestAPI sharedInstance] performUpdateWithObjectType:@"Company_Documents__c"
                                                           objectId:doc.companyDocumentId
                                                             fields:fields
                                                          failBlock:errorBlock
                                                      completeBlock:successBlock];
        }
        else if (!doc.attachmentUploaded) {
            [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Company_Documents__c"
                                                             fields:fields
                                                          failBlock:errorBlock
                                                      completeBlock:successBlock];
        }
    }
}



- (void)uploadDidReturn:(EServiceDocument *)document attachmentId:(NSString *)attachmentId {
    attachmentsReturned++;
    
    if (attachmentsReturned == totalAttachmentsToUpload) {
        [self hideLoadingDialog];
        if (failedImagedArray.count > 0) {
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"DocumentsUploadAlertMessage", @"")];
        }
        else{
            [self setHidden:YES];
            [(RenewPassportSteperViewController*)self.delegate NextScreen:SubmitScreen];
        }
    }
    
}

- (void)addAttachment:(EServiceDocument*)document {
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        
        [failedImagedArray addObject:document];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadDidReturn:document attachmentId:nil];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        document.attachmentUploaded = YES;
        NSString *attachmentDocumentId = [dict objectForKey:@"id"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadDidReturn:document attachmentId:attachmentDocumentId];
        });
    };
    
    NSString *string = [document.attachment base64EncodedStringWithOptions:0];
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            document.name, @"Name",
                            @"image", @"ContentType",
                            document.companyDocumentId, @"ParentId",
                            string, @"Body",
                            nil];
    
    [self showLoadingDialog];
    
    [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Attachment"
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
    
}
- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

-(IBAction)cancelBTN:(UIButton*)sender{
        [(RenewPassportSteperViewController*)self.delegate cancelServiceButtonClicked];
}
-(IBAction)nextBTNClicked:(UIButton*)sender{
    
    [self createCompanyDocuments:selectedEServiceAdministrator.serviceDocumentsArray];
//    [self setHidden:YES];
//    [(RenewPassportSteperViewController*)self.delegate NextScreen:SubmitScreen];
}
@end
