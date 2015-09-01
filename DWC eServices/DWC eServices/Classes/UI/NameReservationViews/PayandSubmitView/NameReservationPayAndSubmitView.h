//
//  NameReservationPayAndSubmitView.h
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI+Blocks.h"
#import "SFRestAPI.h"

@interface NameReservationPayAndSubmitView : UIView<SFRestDelegate>

@property(nonatomic, assign) id delegate;

@property (weak,nonatomic) IBOutlet UILabel*choice1;
@property (weak,nonatomic) IBOutlet UILabel*choice2;
@property (weak,nonatomic) IBOutlet UILabel*choice3;

-(void)setLabels;
-(IBAction)cancel:(id)sender;
-(IBAction)Submit:(id)sender;
@end
