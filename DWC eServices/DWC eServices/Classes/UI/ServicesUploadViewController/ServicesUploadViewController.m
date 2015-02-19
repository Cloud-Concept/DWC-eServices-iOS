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
#import <MobileCoreServices/MobileCoreServices.h>

@interface ServicesUploadViewController ()

@end

@implementation ServicesUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeButtonsWithNextAction:@selector(nextButtonClicked:)];
    
    [self displayDocuments];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        for (EServiceDocument* document in self.currentServiceAdministration.serviceDocumentsArray) {
            [document deleteDocumentAndButton];
        }
    }
    [super viewWillDisappear:animated];
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
    
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    BaseServicesViewController *nextVC = [storybord instantiateViewControllerWithIdentifier:@"ServicesReviewViewController"];
    nextVC.cancelViewController = self.cancelViewController;
    nextVC.currentServiceAdministration = self.currentServiceAdministration;
    nextVC.serviceFields = self.serviceFields;
    nextVC.caseFields = self.caseFields;
    nextVC.serviceObject = self.serviceObject;
    
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (BOOL)validateDocuments {
    BOOL isValid = YES;
    
    for (EServiceDocument *document in self.currentServiceAdministration.serviceDocumentsArray) {
        if (!document.attachment)
            isValid = NO;
    }
    
    return isValid;
}

- (void)displayDocuments {
    [self initServiceFieldsContentView];
    [servicesContentView drawAttachmentButtons:self.currentServiceAdministration.serviceDocumentsArray
                                  cancelButton:cancelButton
                                    nextButton:nextButton
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

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        currentUploadingDocument.attachment = UIImagePNGRepresentation(image);
        [currentUploadingDocument refreshButton];
        
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

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
#warning Handle Error here
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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
