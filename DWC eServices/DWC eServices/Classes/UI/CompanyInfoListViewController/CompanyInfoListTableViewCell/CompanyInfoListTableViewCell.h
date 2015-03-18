//
//  CompanyInfoListTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyInfoListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareOwnershipLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareOwnershipValueLabel;

@end
