//
//  DirectorPayAndSubmitView.h
//  iDWC
//
//  Created by George Hanna Adly on 8/31/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"


@interface DirectorPayAndSubmitView : UIView<SFRestDelegate>

@property(nonatomic,assign)id delegate;
@property(strong,nonatomic)NSString* actionType;

@property(weak,nonatomic) IBOutlet UILabel* directorLabel;
@property(weak,nonatomic) IBOutlet UILabel* amountLabel;

-(void)setLabels;
-(IBAction)cancel:(id)sender;
-(IBAction)Submit:(id)sender;

@end
