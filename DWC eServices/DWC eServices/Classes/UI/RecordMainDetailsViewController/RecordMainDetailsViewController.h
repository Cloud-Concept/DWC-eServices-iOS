//
//  EmployeeMainViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/1/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@class Visa;
@class TenancyContract;
@class License;
@class CardManagement;
@class RelatedServicesBarScrollView;

@interface RecordMainDetailsViewController : BaseFrontRevealViewController

@property (strong, nonatomic) NSString *NameValue;
@property (strong, nonatomic) NSString *PhotoId;
@property (strong, nonatomic) NSString *DefaultPhotoName;
@property (strong, nonatomic) NSString *NavBarTitle;
@property (strong, nonatomic) NSArray *DetailsSectionsArray;
@property (strong, nonatomic) Visa *visaObject;
@property (strong, nonatomic) TenancyContract *contractObject;
@property (strong, nonatomic) License *licenseObject;
@property (strong, nonatomic) CardManagement *cardManagementObject;

@property (nonatomic) BOOL isBottomBarHidden;
@property (nonatomic) BOOL hideImageNameSection;
@property (nonatomic) NSUInteger RelatedServicesMask;

//@property (weak, nonatomic) IBOutlet UIView *paginationView;

@property (weak, nonatomic) IBOutlet RelatedServicesBarScrollView *relatedServicesScrollView;
@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;

@end
