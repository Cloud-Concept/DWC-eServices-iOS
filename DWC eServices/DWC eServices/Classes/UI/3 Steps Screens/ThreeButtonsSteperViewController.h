//
//  ThreeButtonsSteperViewController.h
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelatedService.h"
#import "NameReservationData.h"

typedef NS_ENUM(NSUInteger, CurrentScreenPhase) {
    ViewDetails = 1,
    SubmitPhase = 2,
    ThanksPhase = 3,
};
@interface ThreeButtonsSteperViewController : UIViewController

@property (nonatomic) RelatedServiceType relatedServiceType;
@property (nonatomic) CurrentScreenPhase currentScreen;


@property (strong,nonatomic) NSString* refrenceNumber;


@property (weak,nonatomic) IBOutlet UIView* holderView;
@property(weak,nonatomic) IBOutlet UIScrollView* flowScrollerView;
@property(weak,nonatomic) IBOutlet UIView* timelineView;

@property (weak, nonatomic) IBOutlet UIButton *timelineBulletButton;
-(void)cancelServiceButtonClicked;
-(void)NextScreen:(CurrentScreenPhase)next;

- (void)showLoadingDialog;
- (void)hideLoadingDialog;
@end
