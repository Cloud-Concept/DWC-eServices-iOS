//
//  CompanyDocumentTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyDocument;

@interface CustomerDocumentTableViewCell : UITableViewCell
{
    NSIndexPath *currentIndexPath;
}

@property (strong, nonatomic) UIViewController *parentViewController;

@property (weak, nonatomic) IBOutlet UILabel *documentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *documentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *documentVersionLabel;

- (void)refreshCellForCompanyDocument:(CompanyDocument *)currentCompanyDocument indexPath:(NSIndexPath *)indexPath;

@end
