//
//  NameReservationData.h
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI+Blocks.h"
#import "SFRestAPI.h"

@interface NameReservationData : UIView<SFRestDelegate>

@property(nonatomic, assign) id delegate;

@property(weak,nonatomic) IBOutlet UITextField* choice1;
@property(weak,nonatomic) IBOutlet UITextField* choice2;
@property(weak,nonatomic) IBOutlet UITextField* choice3;


-(IBAction)next:(id)sender;
-(IBAction)cancel:(id)sender;
@end
