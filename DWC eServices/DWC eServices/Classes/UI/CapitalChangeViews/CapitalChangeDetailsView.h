//
//  CapitalChangeDetailsView.h
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI+Blocks.h"
#import "SFRestAPI.h"

@interface CapitalChangeDetailsView : UIView<SFRestDelegate,UITextFieldDelegate>

@property(nonatomic,assign) id delegate;

@property(weak,nonatomic)IBOutlet UITextField* oldShareCapital;
@property(weak,nonatomic)IBOutlet UITextField* requestedShareCapital;

-(void)requestCapitalShareAmount;
-(IBAction)nextButton:(id)sender;
-(IBAction)cancelButton:(id)sender;
@end
