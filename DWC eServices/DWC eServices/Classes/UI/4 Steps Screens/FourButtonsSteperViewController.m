//
//  FourButtonsSteperViewController.m
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "FourButtonsSteperViewController.h"
#import "FVCustomAlertView.h"
#import "CapitalChangeDetailsView.h"
#import "DWCCompanyDocument.h"
#import "CompanyDocumentTypeListViewController.h"
#import "SOQLQueries.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+Additions.h"
#import "DWCCompanyDocument.h"
#import "SOQLQueries.h"
#import "CompanyDocument.h"
#import "DWCSFRequestManager.h"
#import "CapitalChangeDocumentView.h"
#import "CapitalChangePayView.h"
#import "ThankYouPhaseView.h"
#import "DirectorRemovalView.h"
#import "DirectorPayAndSubmitView.h"
#import "RenewAndChangeLicense.h"
#import "RenewAndChangePaySubmitView.h"

@interface FourButtonsSteperViewController ()

@end

@implementation FourButtonsSteperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
        UIBarButtonItem* leftItem =[[UIBarButtonItem alloc] initWithTitle:nil style:self.navigationItem.backBarButtonItem.style target:self action:@selector(backButtonPressed:)];
        [leftItem setImage:[UIImage imageNamed:@"Navigation Bar Back Button Icon"]];
        [leftItem setTintColor:[UIColor whiteColor]];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    if (!self.currentScreen){
        self.currentScreen++;
        //        [self.holderView addSubview:[self getView:self.currentScreen]];
        UIView* initialView =[self getView:self.currentScreen];
        self.holderView.frame = initialView.frame;
        [self.flowScrollerView setContentSize:self.holderView.frame.size];
        [self.holderView addSubview:initialView];
    }
    [self initNavigationTitle:self.currentScreen];
    [self setTimeLineButton:self.currentScreen type:@"Current"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)NextScreen:(FourStepsCurrentScreenPhase)next{
    DLog(@"George");
    self.currentScreen = next;
    [self initNavigationTitle:self.currentScreen];
    [self setTimeLineButton:self.currentScreen type:@"Current"];
    [self setTimeLineButton:(self.currentScreen-1) type:@"Finished"];
    [self.flowScrollerView setScrollEnabled:YES];
    [self.flowScrollerView setContentOffset:CGPointMake(0,0) animated:NO];
    
    
    UIView* nextView =[self getView:self.currentScreen];
    [[self.holderView viewWithTag:self.currentScreen-1] setHidden:YES];
    
    self.holderView.frame = nextView.frame;
    [self.flowScrollerView setContentSize:self.holderView.frame.size];
    [self.holderView addSubview:nextView];
    
}
-(UIView*)getView:(FourStepsCurrentScreenPhase)screen{
    UIView* view;
    if(screen == ViewDetailsStep){
        if (self.relatedServiceType == RelatedServiceTypeCapitalChange) {
            view = [[CapitalChangeDetailsView alloc] initWithFrame:CGRectZero];
            [(CapitalChangeDetailsView*)view setTag:ViewDetailsStep];
            [(CapitalChangeDetailsView*)view setDelegate:self];
            [(CapitalChangeDetailsView*)view requestCapitalShareAmount];
        }
        else if (self.relatedServiceType == RelatedServiceTypeDirectorRemoval) {
            view = [[DirectorRemovalView alloc] initWithFrame:CGRectZero];
            [(DirectorRemovalView*)view setTag:ViewDetailsStep];
            [(DirectorRemovalView*)view setDelegate:self];
            [(DirectorRemovalView*)view setDirector];
        }
        else if (self.relatedServiceType == RelatedServiceTypeLicenseRenewActivityChange || self.relatedServiceType == RelatedServiceTypeLicenseChangeActivityChange)
        {
            view = [[RenewAndChangeLicense alloc] initWithFrame:CGRectZero];
            [(RenewAndChangeLicense*)view setTag:ViewDetailsStep];
            [(RenewAndChangeLicense*)view setDelegate:self];
            [(RenewAndChangeLicense*)view setDeleg];
        }
    }
    else if (screen == UploadDocumentsStep){
        view = [[CapitalChangeDocumentView alloc] initWithFrame:CGRectZero];
        [(CapitalChangeDocumentView*)view setTag:UploadDocumentsStep];
        [(CapitalChangeDocumentView*)view setDelegate:self];
        [(CapitalChangeDocumentView*)view loadEservice];
        //        [self.flowScrollerView setScrollEnabled:NO];
    }
    else if (screen == SubmitScreenStep){
        if (self.relatedServiceType == RelatedServiceTypeCapitalChange) {
            view = [[CapitalChangePayView alloc] initWithFrame:CGRectZero];
            [(CapitalChangePayView*)view setTag:SubmitScreenStep];
            [(CapitalChangePayView*)view setDelegate:self];
            [(CapitalChangePayView*)view setActionType:@"SubmitRequestCapitalChange"];
            [(CapitalChangePayView*)view setLabels];
            //            [self.flowScrollerView setScrollEnabled:NO];
        }
        else if (self.relatedServiceType == RelatedServiceTypeDirectorRemoval) {
            view = [[DirectorPayAndSubmitView alloc] initWithFrame:CGRectZero];
            [(DirectorPayAndSubmitView*)view setTag:SubmitScreenStep];
            [(DirectorPayAndSubmitView*)view setDelegate:self];
            [(DirectorPayAndSubmitView*)view setActionType:@"SubmitRequestDirectorRemoval"];
            [(DirectorPayAndSubmitView*)view setLabels];
            //            [self.flowScrollerView setScrollEnabled:NO];
        }
        else if (self.relatedServiceType == RelatedServiceTypeLicenseChangeActivityChange || self.relatedServiceType == RelatedServiceTypeLicenseRenewActivityChange) {
            view = [[RenewAndChangePaySubmitView alloc] initWithFrame:CGRectZero];
            [(RenewAndChangePaySubmitView*)view setTag:SubmitScreenStep];
            [(RenewAndChangePaySubmitView*)view setDelegate:self];
            [(RenewAndChangePaySubmitView*)view setDeleg];
            
        }
    }
    else if (screen == ThanksScreenStep){
        self.navigationItem.leftBarButtonItem = nil;
        view = [[ThankYouPhaseView alloc] initWithFrame:CGRectZero];
        [(ThankYouPhaseView*)view setDelegate:self];
        [(ThankYouPhaseView*)view setMessageText: self.caseID];
        [(ThankYouPhaseView*)view setTag:ThanksScreenStep];
        //        [self.flowScrollerView setScrollEnabled:NO];
    }
    return view;
}


- (void)initNavigationTitle:(FourStepsCurrentScreenPhase) currentScreen {
    NSString *navBarTitle = @"";
    
    switch (currentScreen) {
        case ViewDetailsStep:
            switch (self.relatedServiceType) {
                case RelatedServiceTypeDirectorRemoval:
                    navBarTitle = NSLocalizedString(@"navBarDirectoryRemoval", @"");
                    break;
                    
                case RelatedServiceTypeCapitalChange:
                    navBarTitle = NSLocalizedString(@"navBarchangeCapital", @"");
                    break;
                default:
                    break;
            }
            
            break;
        case UploadDocumentsStep:
            navBarTitle = NSLocalizedString(@"uploadDocumentTitle", @"");
            break;
        case SubmitScreenStep:
            navBarTitle = NSLocalizedString(@"PayAndSubmitButton", @"");
            break;
        case ThanksScreenStep:
            navBarTitle = NSLocalizedString(@"ThanksAlertTitle", @"");
            break;
            
        default:
            break;
    }
    [self setTitle:navBarTitle];
}
- (void)backButtonPressed:(id)sender {
    DLog(@"in this class %@",@"george");
    if(self.currentScreen == ViewDetailsStep || self.currentScreen == ThanksScreenStep)
        [self cancelServiceButtonClicked];
    else
    {
        [self setTimeLineButton:self.currentScreen type:@"Next"];
        [[self.holderView viewWithTag:self.currentScreen] removeFromSuperview];
        self.currentScreen-=1;
        [self setTimeLineButton:self.currentScreen type:@"Current"];
        [[self.holderView viewWithTag:self.currentScreen] setHidden:NO];
    }
}
-(void)setTimeLineButton:(FourStepsCurrentScreenPhase)scr type:(NSString*)status{
    
    // status is equal "Finished" or "Next" or "Current"
    UIButton *currentButton = (UIButton*)[self.timelineView viewWithTag:scr];
    [currentButton setTitle:@"" forState:UIControlStateNormal];
    if(![status isEqualToString:@"Finished"])
        [currentButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentScreen] forState:UIControlStateNormal];
    NSString *imgName=[NSString stringWithFormat:@"Services Timeline Bullet %@",status];
    [currentButton setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
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

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
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
