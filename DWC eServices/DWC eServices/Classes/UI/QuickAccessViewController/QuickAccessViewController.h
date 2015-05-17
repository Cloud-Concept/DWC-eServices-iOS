//
//  QuickAccessViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/17/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"
#import "EmployeeListViewController.h"

@interface QuickAccessViewController : BaseFrontRevealViewController <EmployeeListSelectEmployeeDelegate>

@property (weak, nonatomic) IBOutlet UIButton *companyNOCButton;
@property (weak, nonatomic) IBOutlet UIButton *employeeNOCButton;
@property (weak, nonatomic) IBOutlet UIButton *cardNewButton;

- (IBAction)companyNOCButtonClicked:(id)sender;
- (IBAction)employeeNOCButtonClicked:(id)sender;
- (IBAction)cardNewButtonClicked:(id)sender;

@end
