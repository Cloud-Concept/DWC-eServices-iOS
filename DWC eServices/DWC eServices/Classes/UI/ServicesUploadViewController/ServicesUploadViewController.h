//
//  ServicesUploadViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/16/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseServicesViewController.h"

@class EServiceDocument;

@interface ServicesUploadViewController : BaseServicesViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIView *servicesContentView;
    //WebForm *currentWebForm;
    BOOL _newMedia;
    EServiceDocument *currentUploadingDocument;
}

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

-(void)showImagePickerForDocument:(EServiceDocument *)document;

@end
