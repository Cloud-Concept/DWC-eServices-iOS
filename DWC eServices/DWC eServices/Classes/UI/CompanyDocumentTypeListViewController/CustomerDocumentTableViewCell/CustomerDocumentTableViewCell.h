//
//  CompanyDocumentTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerDocumentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *documentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *documentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *documentVersionLabel;
@end
