//
//  ThreeButtonsSteperViewController.m
//  iDWC
//
//  Created by George Hanna Adly on 8/30/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "ThreeButtonsSteperViewController.h"
#import "NameReservationData.h"
#import "FVCustomAlertView.h"
#import "NameReservationPayAndSubmitView.h"
#import "ThankYouPhaseView.h"

@interface ThreeButtonsSteperViewController ()

@end

@implementation ThreeButtonsSteperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    if(self.currentScreen != ThanksPhase){
        UIBarButtonItem* leftItem =[[UIBarButtonItem alloc] initWithTitle:nil style:self.navigationItem.backBarButtonItem.style target:self action:@selector(backButtonPressed:)];
        [leftItem setImage:[UIImage imageNamed:@"Navigation Bar Back Button Icon"]];
        [leftItem setTintColor:[UIColor whiteColor]];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    self.currentScreen = ViewDetails;
    [self initNavigationTitle:self.currentScreen];
    [self setTimeLineButton:self.currentScreen type:@"Current"];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    // here to add the condition for any related service flow
    self.holderView.frame = [self getView:self.currentScreen].frame;
    [self.flowScrollerView setContentSize:self.holderView.frame.size];
    [self.holderView addSubview:[self getView:self.currentScreen]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)NextScreen:(CurrentScreenPhase)next{
    DLog(@"George");
    self.currentScreen = next;
    [self initNavigationTitle:self.currentScreen];
    [self setTimeLineButton:self.currentScreen type:@"Current"];
    [self setTimeLineButton:(self.currentScreen-1) type:@"Finished"];
    //    [self.flowScrollerView setScrollEnabled:YES];
    [self.flowScrollerView setContentOffset:CGPointMake(0,0) animated:NO];
    
    
    UIView* nextView =[self getView:self.currentScreen];
    [[self.holderView viewWithTag:self.currentScreen-1] setHidden:YES];
    // this to change Height with the CustomView
    self.holderView.frame = nextView.frame;
    [self.flowScrollerView setContentSize:self.holderView.frame.size];
    [self.holderView addSubview:nextView];
    
    
}
-(UIView*)getView:(CurrentScreenPhase)screen{
    UIView* view;
    if(screen == ViewDetails){
        view = [[NameReservationData alloc] initWithFrame:CGRectZero];
        NSLog(@"height %f holder view height %f",view.frame.size.height,self.holderView.frame.size.height);
        [(NameReservationData*)view setTag:ViewDetails];
        [(NameReservationData*)view setDelegate:self];
    }
    else if (screen == SubmitPhase){
        view = [[NameReservationPayAndSubmitView alloc] initWithFrame:CGRectZero];
        [(NameReservationPayAndSubmitView*)view setTag:SubmitPhase];
        [(NameReservationPayAndSubmitView*)view setDelegate:self];
        [(NameReservationPayAndSubmitView*)view setLabels];
        //        [self.flowScrollerView setScrollEnabled:NO];
    }
    else if (screen == ThanksPhase){
        self.navigationItem.leftBarButtonItem = nil;
        view = [[ThankYouPhaseView alloc] initWithFrame:CGRectZero];
        [(ThankYouPhaseView*)view setDelegate:self];
        [(ThankYouPhaseView*)view setMessageText: self.refrenceNumber];
        [(ThankYouPhaseView*)view setTag:ThanksPhase];
    }
    return view;
}
- (void)initNavigationTitle:(CurrentScreenPhase) currentScreen {
    NSString *navBarTitle =@"";
    
    switch (currentScreen) {
        case ViewDetails:
            navBarTitle = (self.relatedServiceType == RelatedServiceTypeNameReservation)?
            NSLocalizedString(@"navBarNameReservations", @""):@"";
            break;
        case SubmitPhase:
            navBarTitle = NSLocalizedString(@"PayAndSubmitButton", @"");
            break;
        case ThanksPhase:
            navBarTitle = NSLocalizedString(@"ThanksAlertTitle", @"");
            break;
            
        default:
            break;
    }
    [self setTitle:navBarTitle];
}
- (void)backButtonPressed:(id)sender {
    DLog(@"in this class %@",@"george");
    if(self.currentScreen == ViewDetails || self.currentScreen == ThanksPhase)
        [self cancelServiceButtonClicked];
    else
    {
        [self setTimeLineButton:self.currentScreen type:@"Next"];
        [[self.holderView viewWithTag:self.currentScreen] removeFromSuperview];
        self.currentScreen-=1;
        [self setTimeLineButton:self.currentScreen type:@"Current"];
        [[self.holderView viewWithTag:self.currentScreen] setHidden:NO];
    }
}
-(void)setTimeLineButton:(CurrentScreenPhase)scr type:(NSString*)status{
    
    // status is equal "Finished" or "Next" or "Current"
    UIButton *currentButton = (UIButton*)[self.timelineView viewWithTag:scr];
    [currentButton setTitle:@"" forState:UIControlStateNormal];
    if(![status isEqualToString:@"Finished"])
        [currentButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentScreen] forState:UIControlStateNormal];
    NSString *imgName=[NSString stringWithFormat:@"Services Timeline Bullet %@",status];
    [currentButton setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
- (void)cancelServiceButtonClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ConfirmAlertTitle", @"")
                                                                   message:NSLocalizedString(@"CancelServiceAlertMessage", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          NSLog(@"Yes action");
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"")
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action){
                                                         NSLog(@"No action");
                                                     }];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showLoadingDialog {
    if(![FVCustomAlertView isShowingAlert])
        [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
}

- (void)hideLoadingDialog {
    [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
