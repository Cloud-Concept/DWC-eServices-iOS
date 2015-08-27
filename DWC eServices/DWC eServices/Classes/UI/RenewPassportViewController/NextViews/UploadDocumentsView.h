//
//  UploadDocumentsView.h
//  iDWC
//
//  Created by George on 8/19/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"
#import "SFRestRequest.h"
#import "SFRestAPI.h"
#import "FVCustomAlertView.h"
#import "CompanyDocumentTypeListViewController.h"
#import "EServiceDocument.h"
#import "EServiceAdministration.h"
#import "PassportRequestDetailsView.h"

@interface UploadDocumentsView : UIView<SFRestDelegate>{
        EServiceAdministration *selectedEServiceAdministrator;
    // For UPloading
    
    NSInteger totalAttachmentsToUpload;
    NSInteger attachmentsReturned;
    NSMutableArray *failedImagedArray;
}

@property (nonatomic, assign) id <viewControllerDelegate> delegate;

@property(strong,nonatomic) IBOutlet UIView*myview;

@property(strong,nonatomic)UIButton* cancelButton;
@property(strong,nonatomic)UIButton* nextButton;


-(void)loadEservice;

-(IBAction)cancelBTN:(UIButton*)sender;
-(IBAction)nextBTNClicked:(UIButton*)sender;
@end
