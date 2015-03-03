//
//  MyRequestTableViewCell.h
//  DWC eServices
//
//  Created by Mina Zaklama on 3/3/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *requestNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestDateLabel;
@end
