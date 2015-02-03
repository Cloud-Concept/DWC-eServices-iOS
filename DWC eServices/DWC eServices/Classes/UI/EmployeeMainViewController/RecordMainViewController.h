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

@interface EmployeeMainViewController : BaseFrontRevealViewController

@property (strong, nonatomic) Visa *currentVisa;

@property (weak, nonatomic) IBOutlet UIView *paginationView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;

@end
