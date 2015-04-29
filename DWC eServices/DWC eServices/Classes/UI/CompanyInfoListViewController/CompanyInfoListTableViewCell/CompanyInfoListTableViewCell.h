//
//  CompanyInfoListTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/8/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyInfoListBaseTableViewCell.h"

@class Directorship;
@class ManagementMember;
@class LegalRepresentative;

@interface CompanyInfoListTableViewCell : CompanyInfoListBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationalityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *passportNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateValueLabel;

- (void)refreshCellForDirector:(Directorship *)director indexPath:(NSIndexPath *)indexPath;
- (void)refreshCellForManager:(ManagementMember *)manager indexPath:(NSIndexPath *)indexPath;
- (void)refreshCellForLegalRepresentative:(LegalRepresentative *)legalRepresentative indexPath:(NSIndexPath *)indexPath;

@end
