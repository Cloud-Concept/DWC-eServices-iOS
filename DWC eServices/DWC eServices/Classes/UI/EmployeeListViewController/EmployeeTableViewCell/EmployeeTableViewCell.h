//
//  ContractorTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowOneValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowTwoValueLabel;

@end
