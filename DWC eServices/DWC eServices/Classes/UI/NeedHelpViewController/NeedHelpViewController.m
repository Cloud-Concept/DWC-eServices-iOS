//
//  NeedHelpViewController.m
//  DWC eServices
//
//  Created by Mina Zaklama on 5/5/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "NeedHelpViewController.h"
#import "PickerTableViewController.h"
#import "SFRestAPI+Blocks.h"
#import "RecordType.h"
#import "FVCustomAlertView.h"
#import "HelperClass.h"
#import "NSString+SFAdditions.h"
#import "Globals.h"
#import "Account.h"
#import "ServicesThankYouViewController.h"
#import "UIViewController+ChildViewController.h"
#import "Request.h"

@interface NeedHelpViewController ()

@end

@implementation NeedHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:NSLocalizedString(@"navBarNeedHelpTitle", @"")];
    
    caseTypesArray = @[@"Inquiry", @"Suggestion", @"Complaint"];
    
    selectedCaseTypeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self refreshCaseTypeButton];
    
    [self loadCaseRecordType];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Register for the events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.containerView addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshCaseTypeButton {
    [self.caseTypeButton setTitle:[caseTypesArray objectAtIndex:selectedCaseTypeIndexPath.row] forState:UIControlStateNormal];
}

- (void)loadCaseRecordType {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
#warning Handle Error
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        for (NSDictionary *obj in [dict objectForKey:@"records"]) {
            caseRecordType = [[RecordType alloc] initRecordType:obj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Customer_Inquiry'";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (BOOL)validateInput {
    BOOL returnValue = YES;
    
    if ([self.subjectTextField.text isEmptyOrWhitespaceAndNewlines])
        return NO;
    
    if ([self.descriptionTextArea.text isEmptyOrWhitespaceAndNewlines])
        return NO;
    
    if (!selectedCaseTypeIndexPath)
        return NO;
    
    return returnValue;
}

- (void)insertCase {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSString *caseId = [dict objectForKey:@"id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            
            [self getCaseDetails:caseId];
            
        });
    };
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            caseRecordType.Id, @"Type",
                            [Globals contactId], @"ContactId",
                            [Globals currentAccount].Id, @"AccountId",
                            self.subjectTextField.text, @"Subject",
                            self.descriptionTextArea.text, @"Description",
                            caseRecordType.Id, @"RecordTypeId",
                            nil];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Case"
                                                     fields:fields
                                                  failBlock:errorBlock
                                              completeBlock:successBlock];
}

- (void)getCaseDetails:(NSString *)caseId {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        Request *currentCase;
        for (NSDictionary *obj in [dict objectForKey:@"records"]) {
            currentCase = [[Request alloc] initRequest:obj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FVCustomAlertView hideAlertFromMainWindowWithFading:YES];
            
            ServicesThankYouViewController *servicesThankYouVC = [ServicesThankYouViewController new];
            servicesThankYouVC.isNeedHelp = YES;
            servicesThankYouVC.needHelpCaseNumber = currentCase.caseNumber;
            
            [self addChildViewController:servicesThankYouVC toView:self.containerView];
        });
    };
    
    NSString *soqlQuery = [NSString stringWithFormat:@"SELECT Id, CaseNumber FROM Case WHERE ID = '%@'", caseId];
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:nil withTitle:NSLocalizedString(@"loading", @"") withBlur:YES];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:soqlQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (IBAction)submitButtonClicked:(id)sender {
    if (![self validateInput]) {
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredFieldsAlertMessage", @"")];
        return;
    }
    
    [self insertCase];
}

- (IBAction)caseTypeButtonClicked:(id)sender {
    
    UIButton *senderButton = sender;
    
    PickerTableViewController *pickerTableVC = [PickerTableViewController new];
    pickerTableVC.valuesArray = caseTypesArray;
    pickerTableVC.selectedIndexPath = selectedCaseTypeIndexPath;
    pickerTableVC.valuePicked = ^(NSString *value, NSIndexPath *indexPath, PickerTableViewController *picklist) {
        selectedCaseTypeIndexPath = indexPath;
        [self refreshCaseTypeButton];
        [picklist dismissPopover:YES];
    };
    
    [pickerTableVC showPopoverFromView:senderButton];
}

#pragma KeyBoard Notifications
-(void) keyboardWillShow: (NSNotification *)notif {
    NSDictionary *userInfo = [notif userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's
    // coordinate system. The bottom of the text view's frame should align with the top
    // of the keyboard's final position.
    //
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newBiddingViewFrame = self.containerView.bounds;
    newBiddingViewFrame.size.height = keyboardTop - self.containerView.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    scrollViewOffset = self.scrollView.contentOffset;
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.scrollView.frame = newBiddingViewFrame;

    //CGRect textFieldRect = [self.answerTextView frame];
    //textFieldRect.origin.y += 10;
    //[self.servicesScrollView scrollRectToVisible:textFieldRect animated:YES];
    
    [UIView commitAnimations];
}

-(void) keyboardWillHide: (NSNotification *)notif {
    NSDictionary *userInfo = [notif userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.scrollView.frame = self.containerView.bounds;
    
    // Reset the scrollview to previous location
    self.scrollView.contentOffset = scrollViewOffset;
    
    [UIView commitAnimations];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

@end
