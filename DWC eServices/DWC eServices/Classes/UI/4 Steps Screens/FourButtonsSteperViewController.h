//
//  FourButtonsSteperViewController.h
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelatedService.h"
#import "EServiceAdministration.h"
#import "EServiceDocument.h"
#import "UploadDocumentsView.h"
#import "Directorship.h"
#import "License.h"

typedef NS_ENUM(NSUInteger, FourStepsCurrentScreenPhase) {
    ViewDetailsStep = 1,
    UploadDocumentsStep = 2,
    SubmitScreenStep = 3,
    ThanksScreenStep = 4,
};

@interface FourButtonsSteperViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,CompanyDocumentTypeListSelectDocumentDelegate>{
     BOOL _newMedia;
}

// this caseid is used to get documents
@property(strong,nonatomic)NSString* caseID;
@property(strong,nonatomic)NSString* caseNumber;

@property (nonatomic) RelatedServiceType relatedServiceType;
@property (nonatomic) FourStepsCurrentScreenPhase currentScreen;

@property(strong,nonatomic)License* licenseObject;


@property (strong, nonatomic) Directorship *directorObject;
// to be used with the documents
@property (weak, nonatomic) EServiceDocument *currentUploadingDocument;
@property (weak, nonatomic) EServiceAdministration* selectedEServiceAdministrator;
@property (strong,nonatomic) NSString* refrenceNumber;


@property (weak,nonatomic) IBOutlet UIView* holderView;
@property(weak,nonatomic) IBOutlet UIScrollView* flowScrollerView;
@property(weak,nonatomic) IBOutlet UIView* timelineView;

@property (weak, nonatomic) IBOutlet UIButton *timelineBulletButton;
-(void)cancelServiceButtonClicked;
-(void)NextScreen:(FourStepsCurrentScreenPhase)next;

- (void)showLoadingDialog;
- (void)hideLoadingDialog;
@end
