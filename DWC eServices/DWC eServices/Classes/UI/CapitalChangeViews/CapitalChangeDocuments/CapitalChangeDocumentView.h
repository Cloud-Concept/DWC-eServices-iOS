//
//  CapitalChangeDocumentView.h
//  iDWC
//
//  Created by George Hanna Adly on 8/31/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EServiceAdministration.h"

@interface CapitalChangeDocumentView : UIView{
    EServiceAdministration *selectedEServiceAdministrator;
    // For UPloading
    NSString * serviceIdentifier;
    NSInteger totalAttachmentsToUpload;
    NSInteger attachmentsReturned;
    NSMutableArray *failedImagedArray;
}
@property (nonatomic,assign) id delegate;

@property(weak,nonatomic) IBOutlet UIView* dynamicView;
-(IBAction)nextButton:(id)sender;
-(IBAction)cancelButton:(id)sender;
-(EServiceAdministration*)getEserviceAdmin;
-(void)loadEservice;
@end
