//
//  ServicesUploadViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/16/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EServiceDocument;
@class BaseServicesViewController;

@interface ServicesUploadViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIView *servicesContentView;
    BOOL _newMedia;
    EServiceDocument *currentUploadingDocument;
}

@property (weak, nonatomic) BaseServicesViewController *baseServicesViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

-(void)showImagePickerForDocument:(EServiceDocument *)document;
-(void)showCameraForDocument:(EServiceDocument *)document;

@end
