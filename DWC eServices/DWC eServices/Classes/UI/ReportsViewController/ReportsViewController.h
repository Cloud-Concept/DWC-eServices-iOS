//
//  ReportsViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 5/5/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@interface ReportsViewController : BaseFrontRevealViewController

@property (weak, nonatomic) IBOutlet UIButton *myRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *statementOfAccountButton;

- (IBAction)myRequestButtonClicked:(id)sender;
- (IBAction)statementOfAccountButtonClicked:(id)sender;

@end
