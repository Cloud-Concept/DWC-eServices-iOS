//
//  ServicesUploadViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/16/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ServicesUploadViewController.h"
#import "UIView+DynamicForm.h"
#import "EServiceAdministration.h"
#import "EServiceDocument.h"
#import "HelperClass.h"
#import "BaseServicesViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+Additions.h"
#import "DWCCompanyDocument.h"
#import "SOQLQueries.h"
#import "CompanyDocument.h"
#import "DWCSFRequestManager.h"

@interface ServicesUploadViewController ()

@end

@implementation ServicesUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.baseServicesViewController initializeButtonsWithNextAction:@selector(nextButtonClicked:) target:self];
    
    self.baseServicesViewController.backAction = ^(void) {
        for (EServiceDocument* document in self.baseServicesViewController.currentServiceAdministration.serviceDocumentsArray) {
            [document deleteDocumentAndButton];
        }
    };
    
    [self displayDocuments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButtonClicked:(id)sender {
    if (![self validateDocuments]) {
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredDocumentsAlertMessage", @"")];
        return;
    }
    
    if (![self validateDocumentsSize]) {
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"DocumentsSizeAlertMessage", @"")];
        return;
    }
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowAttachmentsPage];
}

- (BOOL)validateDocuments {
    BOOL isValid = YES;
    
    for (EServiceDocument *document in self.baseServicesViewController.currentServiceAdministration.serviceDocumentsArray) {
        if (document.existingDocument && document.existingDocumentAttachmentId) {
            continue;
        }
        
        if (!document.attachment)
            isValid = NO;
    }
    
    return isValid;
}

- (BOOL)validateDocumentsSize {
    BOOL isValid = YES;
    
    for (EServiceDocument *document in self.baseServicesViewController.currentServiceAdministration.serviceDocumentsArray) {
        float documentSize = document.attachment.length / 1024.0 / 1024.0;
        
        if (documentSize > 1) {
            isValid = NO;
        }
    }
    
    return isValid;
}

- (void)displayDocuments {
    [self initServiceFieldsContentView];
    
    [servicesContentView drawAttachmentButtons:self.baseServicesViewController.currentServiceAdministration.serviceDocumentsArray
                                  cancelButton:self.baseServicesViewController.cancelButton
                                    nextButton:self.baseServicesViewController.nextButton
                                viewController:self];
}

- (void)initServiceFieldsContentView {
    self.servicesScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    servicesContentView = [UIView new];
    servicesContentView.backgroundColor = [UIColor clearColor];
    servicesContentView.frame = self.servicesScrollView.frame;
    
    servicesContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.servicesScrollView addSubview:servicesContentView];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(servicesContentView);
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[servicesContentView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    [self.servicesScrollView addConstraint:[NSLayoutConstraint
                                            constraintWithItem:servicesContentView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.servicesScrollView
                                            attribute:NSLayoutAttributeWidth
                                            multiplier:1
                                            constant:0.0]];
    
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[servicesContentView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    [self.servicesScrollView addConstraints:constraint_POS_H];
    [self.servicesScrollView addConstraints:constraint_POS_V];
}

- (void)showImagePickerForDocument:(EServiceDocument *)document {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        currentUploadingDocument = document;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        _newMedia = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)showCameraForDocument:(EServiceDocument *)document {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        currentUploadingDocument = document;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = YES;
        _newMedia = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }
}

- (void)showExistingDocumentSelectForDocument:(EServiceDocument *)document {
    DWCCompanyDocument *dwcCompanyDocument = [[DWCCompanyDocument alloc]
                                              initDWCCompanyDocument:NSLocalizedString(@"DWCCompanyDocumentTypeCustomerDocument", @"")
                                              NavBarTitle:NSLocalizedString(@"navBarDWCCompanyDocumentTypeCustomerDocumentTitle", @"")
                                              DWCCompanyDocumentType:DWCCompanyDocumentTypeCustomerDocument
                                              Query:[SOQLQueries customerDocumentsQuery]
                                              CacheKey:kCustomerDocumentCacheKey
                                              ObjectType:kCustomerDocumentCacheKey
                                              ObjectClass:[CompanyDocument class]];
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CompanyDocumentTypeListViewController *companyDocListVC = [storybord instantiateViewControllerWithIdentifier:@"Company Document List Page"];
    companyDocListVC.currentDocumentType = dwcCompanyDocument;
    companyDocListVC.selectDocumentDelegate = self;
    companyDocListVC.isSelectDocument = YES;
    currentUploadingDocument = document;
    
    //[self presentViewController:companyDocListVC animated:YES completion:nil];
    [self.baseServicesViewController.navigationController pushViewController:companyDocListVC animated:YES];
}

#pragma mark CompanyDocumentTypeListSelectDocumentDelegate
- (void)didSelectCompanyDocument:(CompanyDocument *)companyDocument {
    currentUploadingDocument.existingDocument = YES;
    currentUploadingDocument.existingDocumentAttachmentId = companyDocument.attachmentId;
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.baseServicesViewController.navigationController popViewControllerAnimated:YES];
    
    [currentUploadingDocument refreshButton];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        float documentSize = imageData.length / 1024.0 / 1024.0;
        
        if (documentSize > 1) {
            //UIImage *resizedImage = [UIImageView imageWithImage:image scaledToSize:CGSizeMake(480, 640)];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                             message:NSLocalizedString(@"DocumentResizeAlertMessage", @"")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *resizeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"resize", @"")
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     UIImage *resizedImage = [UIImageView imageWithImage:image scaledToSize:CGSizeMake(480, 640)];
                                                                     currentUploadingDocument.attachment = UIImagePNGRepresentation(resizedImage);
                                                                     currentUploadingDocument.existingDocument = NO;
                                                                     [currentUploadingDocument refreshButton];
                                                                 }];
            
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     
                                                                 }];
            
            [alertVC addAction:resizeAction];
            [alertVC addAction:noAction];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else {
            currentUploadingDocument.attachment = imageData;
            currentUploadingDocument.existingDocument = NO;
            [currentUploadingDocument refreshButton];
        }
        
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
