//
//  ContractorTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 1/28/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *contractorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardExpiryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardExpiryValueLabel;

@end
