//
//  RenewPassportSteperViewController.h
//  iDWC
//
//  Created by George on 8/18/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Visa.h"
#import "RelatedService.h"
#import "BaseFrontRevealViewController.h"
#import "PassportRequestDetailsView.h"
#import "UploadDocumentsView.h"

typedef NS_ENUM(NSUInteger, RenewPassportCurrentScreen) {
    PassportDetails = 1,
    UploadDocuments = 2,
    SubmitScreen = 3,
    ThanksScreen = 4,
};
@interface RenewPassportSteperViewController : UIViewController<viewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, CompanyDocumentTypeListSelectDocumentDelegate>{
    
    BOOL _newMedia;
    NSString* caseID;
}

@property (strong, nonatomic) Visa *renewedPassportObject;
@property (nonatomic) RelatedServiceType relatedServiceType;
@property (nonatomic) RenewPassportCurrentScreen currentScreen;


@property (weak, nonatomic) IBOutlet PassportRequestDetailsView *passportDetailsView;
@property (weak,nonatomic)  IBOutlet UIView* contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *serviceFlowView;
@property (weak, nonatomic) IBOutlet UIView *timelineView;

@property (weak, nonatomic) EServiceDocument *currentUploadingDocument;
@property (weak, nonatomic) EServiceAdministration* selectedEServiceAdministrator;

// all the buttons are attached with the same "IBoutlet" with "Tag"
@property (weak, nonatomic) IBOutlet UIButton *timelineBulletButton;

-(void)NextScreen:(RenewPassportCurrentScreen)next;
- (void)cancelServiceButtonClicked;
-(void)setCaseIDValue:(NSString*)value;
-(NSString*)getCaseID;
@end
