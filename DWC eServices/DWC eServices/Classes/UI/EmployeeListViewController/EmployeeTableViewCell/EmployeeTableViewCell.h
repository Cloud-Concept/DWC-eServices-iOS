//
//  EmployeeTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *visaStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *visaStatusValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *visaExpiryLabel;
@property (weak, nonatomic) IBOutlet UILabel *visaExpiryValueLabel;

@end
