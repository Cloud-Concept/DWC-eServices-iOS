//
//  RenewPassportSteperViewController.m
//  iDWC
//
//  Created by George on 8/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RenewPassportSteperViewController.h"
#import "UploadDocumentsView.h"
#import "Passport.h"
#import "Account.h"
#import "Country.h"
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
#import "SubmitView.h"
#import "ThanksView.h"

@interface RenewPassportSteperViewController ()

@end

@implementation RenewPassportSteperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentScreen = PassportDetails;
    
    [self.passportDetailsView setDelegate:self];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem* leftItem =[[UIBarButtonItem alloc] initWithTitle:nil style:self.navigationItem.backBarButtonItem.style target:self action:@selector(backButtonPressed:)];
    [leftItem setImage:[UIImage imageNamed:@"Navigation Bar Back Button Icon"]];
    [leftItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [self initNavigationTitle:self.currentScreen];
    [self setTimeLineButton:self.currentScreen type:@"Current"];
    [self.passportDetailsView setTag:PassportDetails];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.passportDetailsView.oldPassportNo setText:self.renewedPassportObject.passportNumber];
    [self.passportDetailsView.passportHolder setText:self.renewedPassportObject.visaHolder.name];
    [self.passportDetailsView.CountryOfIssue setText:self.renewedPassportObject.passportIssueCountry.name];
}
- (void)initNavigationTitle:(RenewPassportCurrentScreen) currentScreen {
    NSString *navBarTitle = NSLocalizedString(@"navBarNewPASSPORTTitle", @"");
    
    switch (currentScreen) {
        case PassportDetails:
            navBarTitle = NSLocalizedString(@"navBarNewPASSPORTTitle", @"");
            break;
        case UploadDocuments:
            navBarTitle = NSLocalizedString(@"uploadDocumentTitle", @"");
            break;
        case SubmitScreen:
            navBarTitle = NSLocalizedString(@"PayAndSubmitButton", @"");
            break;
        case ThanksScreen:
            navBarTitle = NSLocalizedString(@"ThanksAlertTitle", @"");
            break;
            
        default:
            break;
    }
    [self setTitle:navBarTitle];
}
-(void)setTimeLineButton:(RenewPassportCurrentScreen) scr type:(NSString*)status{
    
    // status is equal "Finished" or "Next" or "Current"
    UIButton *currentButton = (UIButton*)[self.timelineView viewWithTag:scr];
    [currentButton setTitle:@"" forState:UIControlStateNormal];
    if(![status isEqualToString:@"Finished"])
        [currentButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentScreen] forState:UIControlStateNormal];
    NSString *imgName=[NSString stringWithFormat:@"Services Timeline Bullet %@",status];
    [currentButton setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
- (void)backButtonPressed:(id)sender {
    DLog(@"in this class %@",@"george");
    if(self.currentScreen == PassportDetails)
        [self cancelServiceButtonClicked];
    else
    {
        [self setTimeLineButton:self.currentScreen type:@"Next"];
        [[self.view viewWithTag:self.currentScreen] removeFromSuperview];
        self.currentScreen-=1;
        [self setTimeLineButton:self.currentScreen type:@"Current"];
        [[self.view viewWithTag:self.currentScreen] setHidden:NO];
    }
}
-(void)NextScreen:(RenewPassportCurrentScreen)next{
    DLog(@"George");
    self.currentScreen = next;
    [self initNavigationTitle:self.currentScreen];
    [self setTimeLineButton:self.currentScreen type:@"Current"];
    [self setTimeLineButton:(self.currentScreen-1) type:@"Finished"];
    [self.serviceFlowView setContentOffset:CGPointZero animated:YES];
    
//    UIScrollView * scroller = [[UIScrollView alloc] init];
//    scroller.backgroundColor = [UIColor clearColor]; // just so I can see it
//    scroller.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView* nextView =[self getView:self.currentScreen];
    [self.contentView addSubview:nextView];

    [self.serviceFlowView setContentSize:self.contentView.bounds.size];
    [self.serviceFlowView layoutIfNeeded];
   
}
-(UIView*)getView:(RenewPassportCurrentScreen)screen{
    UIView* view;
    if(screen == UploadDocuments){
        view = [[UploadDocumentsView alloc] initWithFrame:CGRectZero];
        [(UploadDocumentsView*)view setDelegate:self];
        [(UploadDocumentsView*)view loadEservice];
        [(UploadDocumentsView*)view setTag:UploadDocuments];
         [self.passportDetailsView setHidden:true];
    }
    else if (screen == SubmitScreen){
        view = [[SubmitView alloc] initWithFrame:CGRectZero];
        [(SubmitView*)view setDelegate:self];
        [(SubmitView*)view initFields];
        [(SubmitView*)view setTag:SubmitScreen];
    }
    else if (screen == ThanksScreen){
        view = [[ThanksView alloc] initWithFrame:CGRectZero];
        [(ThanksView*)view setDelegate:self];
        [(ThanksView*)view setMessageText];
        [(ThanksView*)view setTag:ThanksScreen];
    }
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)objectsFromSubview:(id)sender{
    
}

- (void)cancelServiceButtonClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ConfirmAlertTitle", @"")
                                                                   message:NSLocalizedString(@"CancelServiceAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          NSLog(@"Yes action");
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"")
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action){
                                                         NSLog(@"No action");
                                                     }];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(NSString*)getCaseID{
    return caseID;
}
-(void)setCaseIDValue:(NSString*)value{
    caseID=value;
}

#pragma mark override Method must be done
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
    self.currentUploadingDocument = document;
    
    //[self presentViewController:companyDocListVC animated:YES completion:nil];
    [self.navigationController pushViewController:companyDocListVC animated:YES];
}
- (void)showImagePickerForDocument:(EServiceDocument *)document {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        self.currentUploadingDocument = document;
        
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
        self.currentUploadingDocument = document;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = YES;
        _newMedia = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}



#pragma mark CompanyDocumentTypeListSelectDocumentDelegate
- (void)didSelectCompanyDocument:(CompanyDocument *)companyDocument {
    self.currentUploadingDocument.existingDocument = YES;
    self.currentUploadingDocument.existingDocumentAttachmentId = companyDocument.attachmentId;
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.currentUploadingDocument refreshButton];
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
                                                                     self.currentUploadingDocument.attachment = UIImagePNGRepresentation(resizedImage);
                                                                     self.currentUploadingDocument.existingDocument = NO;
                                                                     [self.currentUploadingDocument refreshButton];
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
            self.currentUploadingDocument.attachment = imageData;
            self.currentUploadingDocument.existingDocument = NO;
            [self.currentUploadingDocument refreshButton];
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

@end
