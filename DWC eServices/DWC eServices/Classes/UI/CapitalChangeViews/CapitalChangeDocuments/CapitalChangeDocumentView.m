//
//  CapitalChangeDocumentView.m
//  iDWC
//
//  Created by George Hanna Adly on 8/31/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "CapitalChangeDocumentView.h"
#import "FourButtonsSteperViewController.h"
#import "EServiceDocument.h"
#import "SOQLQueries.h"
#import "SFRestAPI.h"
#import "SFRestAPI+Blocks.h"
#import "UIView+DynamicForm.h"
#import "Globals.h"
#import "Account.h"

@implementation CapitalChangeDocumentView

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"CapitalChangeDocumentView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    return self;
}



-(void)loadEservice{
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"");
            [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        DLog(@"");
        dispatch_async(dispatch_get_main_queue(), ^{
            [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
            for (NSDictionary *recordDict in [dict objectForKey:@"records"]) {
                serviceIdentifier =  [[recordDict objectForKey:@"Registration_Amendment__r"] objectForKey:@"Service_Identifier__c"];
                [self loadEServiceAdministration];
            }
        });
    };
    NSString* identefierQuery = [NSString stringWithFormat:@"select id , Registration_Amendment__c , Registration_Amendment__r.Service_Identifier__c from Case where id = '%@'",[(FourButtonsSteperViewController*)self.delegate caseID]];
    
    [(FourButtonsSteperViewController*)self.delegate showLoadingDialog];
    [[SFRestAPI sharedInstance] performSOQLQuery:identefierQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}
-(EServiceAdministration*)getEserviceAdmin{
    return selectedEServiceAdministrator;
}
- (void)loadEServiceAdministration {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"");
            [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        DLog(@"");
        dispatch_async(dispatch_get_main_queue(), ^{
            [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
            for (NSDictionary *recordDict in [dict objectForKey:@"records"]) {
                selectedEServiceAdministrator = [[EServiceAdministration alloc] initEServiceAdministration:recordDict];
                [self displayDocuments];
            }
        });
    };
    
    [(FourButtonsSteperViewController*)self.delegate showLoadingDialog];
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries visaRenewServiceAdminQuery:serviceIdentifier]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}
- (void)displayDocuments {
    
    [self.dynamicView drawAttachmentButtons:selectedEServiceAdministrator.serviceDocumentsArray  viewController:(FourButtonsSteperViewController*)self.delegate];
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
                                       [(FourButtonsSteperViewController*)self.delegate caseID] , @"Request__c",
                                       nil];
        
        if (doc.existingDocument && doc.existingDocumentAttachmentId) {
            [fields setObject:doc.existingDocumentAttachmentId forKey:@"Attachment_Id__c"];
        }
        void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
            [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
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
        
        [(FourButtonsSteperViewController*)self.delegate showLoadingDialog];
        
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
        [(FourButtonsSteperViewController*)self.delegate hideLoadingDialog];
        if (failedImagedArray.count > 0) {
            [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                             Message:NSLocalizedString(@"DocumentsUploadAlertMessage", @"")];
        }
        else{
            [self setHidden:YES];
            [(FourButtonsSteperViewController*)self.delegate NextScreen:SubmitScreenStep];
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
    
    
            [(FourButtonsSteperViewController*)self.delegate showLoadingDialog];
    
    [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Attachment"
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
    
}

-(IBAction)nextButton:(id)sender{
        [self createCompanyDocuments:selectedEServiceAdministrator.serviceDocumentsArray];
}
-(IBAction)cancelButton:(id)sender{
        [(FourButtonsSteperViewController*)self.delegate cancelServiceButtonClicked];
}

@end
