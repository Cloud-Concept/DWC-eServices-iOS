//
//  EmployeeMainViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/1/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "RecordRelatedViewController.h"

@class Visa;

@interface RecordMainViewController : BaseFrontRevealViewController <RecordRelatedViewControllerDelegate>

@property (strong, nonatomic) NSString *NameValue;
@property (strong, nonatomic) NSString *PhotoId;
@property (strong, nonatomic) NSArray *DetailsSectionsArray;
@property (strong, nonatomic) Visa *visaObject;
@property (nonatomic) NSUInteger RelatedServicesMask;

@property (weak, nonatomic) IBOutlet UIView *paginationView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;

@end
