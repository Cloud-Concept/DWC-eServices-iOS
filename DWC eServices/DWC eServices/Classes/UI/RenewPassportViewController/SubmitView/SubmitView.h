//
//  SubmitView.h
//  iDWC
//
//  Created by George on 8/20/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassportRequestDetailsView.h"

@interface SubmitView : UIView<SFRestDelegate>

@property (nonatomic, assign) id <viewControllerDelegate> delegate;


@property(weak,nonatomic)IBOutlet UIView* holderView;
@property(weak,nonatomic)IBOutlet UILabel*passportHolder;
@property(weak,nonatomic)IBOutlet UILabel*oldPassportNO;
@property(weak,nonatomic)IBOutlet UILabel*requestedPassportNo;
@property(weak,nonatomic)IBOutlet UILabel*issueDate;
@property(weak,nonatomic)IBOutlet UILabel*ExpiryDate;
@property(weak,nonatomic)IBOutlet UILabel*placeOfIssue;
@property(weak,nonatomic)IBOutlet UILabel*CountryOfIssue;

-(void)initFields;
-(IBAction)cancelBTN:(UIButton*)sender;
-(IBAction)nextBTNClicked:(UIButton*)sender;
@end
