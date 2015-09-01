//
//  DirectorRemovalView.h
//  iDWC
//
//  Created by George Hanna Adly on 8/31/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI+Blocks.h"
#import "SFRestAPI.h"
#import "Directorship.h"

@interface DirectorRemovalView : UIView<SFRestDelegate>

@property(nonatomic,assign)id delegate;
@property(weak,nonatomic)IBOutlet UITextField* directorName;

-(void)setDirector;
-(IBAction)nextButton:(id)sender;
-(IBAction)cancelButton:(id)sender;
@end
