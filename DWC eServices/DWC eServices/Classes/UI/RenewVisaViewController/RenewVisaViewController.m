//
//  RenewVisaViewController.m
//  iDWC
//
//  Created by Mina Zaklama on 6/23/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "RenewVisaViewController.h"
#import "SFRestAPI+Blocks.h"
#import "BaseServicesViewController.h"
#import "RecordType.h"
#import "EServiceAdministration.h"
#import "HelperClass.h"
#import "Visa.h"
#import "SOQLQueries.h"
#import "FormField.h"
#import "WebForm.h"
#import "UIView+DynamicForm.h"
#import "Country.h"
#import "Passport.h"
#import "NSString+HelperAdditions.h"
#import "Globals.h"
#import "Account.h"
#import "Occupation.h"
#import "Qualification.h"
#import "ObjectSettings.h"
#import "EServiceAdministration.h"
#import "SFDateUtil.h"

@interface RenewVisaViewController ()

@end

@implementation RenewVisaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadRecordTypes];
    [self loadTariffs];
    [self loadObjectSettings];
    [self callMobileRenewVisaWebServiceReturn];
}

- (void)viewWillAppear:(BOOL)animated {
    // Register for the events
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadingDialog {
    [self.baseServicesViewController showLoadingDialog];
}

- (void)hideLoadingDialog {
    if (!(loadingRecordTypes || loadingTariffs || loadingRenewedVisa || loadingRenewVisaWebservice || loadingObjectSettings || loadingServiceIdentifier))
        [self.baseServicesViewController hideLoadingDialog];
}

- (void)prepareForNextFlowPage {
    if (![self validateInput]) {
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"RequiredFieldsAlertMessage", @"")];
        return;
    }
    
    if (![self validateEmailValues]) {
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"InvalidEmailFormatsAlertMessage", @"")];
        return;
    }
    
    //Prepare FormFields
    NSMutableArray *formFieldsMutableArray = [NSMutableArray new];
    for (FormField *formField in currentWebForm.formFields) {
        formField.hidden = YES;
    }
    [formFieldsMutableArray addObjectsFromArray:currentWebForm.formFields];
    
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"VisaDetailsTitle" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"VisaDetailsTitle", @"") FieldValue:@"" IsParameter:YES]];
    
    NSString *monthlyBasicSalaryString = [HelperClass formatNumberToString:self.baseServicesViewController.renewedVisaObject.monthlyBasicSalaryInAED FormatStyle:NSNumberFormatterNoStyle MaximumFractionDigits:2];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Monthly_Basic_Salary_in_AED__c" Type:@"DOUBLE" MobileLabel:NSLocalizedString(@"VisaDetailsEmployeeMonthlySalary", @"") FieldValue:monthlyBasicSalaryString IsParameter:NO IsRequired:YES]];
    
    NSString *monthlyAllowanceString = [HelperClass formatNumberToString:self.baseServicesViewController.renewedVisaObject.monthlyAllowancesInAED FormatStyle:NSNumberFormatterNoStyle MaximumFractionDigits:2];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Monthly_Allowances_in_AED__c" Type:@"DOUBLE" MobileLabel:NSLocalizedString(@"VisaDetailsEmployeeMonthlyAllowance", @"") FieldValue:monthlyAllowanceString IsParameter:NO IsRequired:NO]];

    FormField *occupation = [[FormField alloc] initFormField:@"" Name:@"Job_Title_at_Immigration__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"VisaDetailsEmployeeOccupation", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.jobTitleAtImmigration.Id IsParameter:NO IsRequired:YES];
    occupation.textValue = @"Occupation__c";
    [formFieldsMutableArray addObject:occupation];
    [self.baseServicesViewController getReferencePicklistValues:occupation];
    
    FormField *qualification = [[FormField alloc] initFormField:@"" Name:@"Qualification__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"VisaDetailsEmployeeQualification", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.qualification.Id IsParameter:NO IsRequired:YES];
    qualification.textValue = @"Qualification__c";
    [formFieldsMutableArray addObject:qualification];
    [self.baseServicesViewController getReferencePicklistValues:qualification];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"AdditionsTitle" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"AdditionsTitle", @"") FieldValue:@"" IsParameter:YES]];
    for (ObjectSettings *objectSettingsObject in objectSettingsMutableArray) {
        if (!objectSettingsObject.isActive || !objectSettingsObject.availability)
            continue;
        
        NSString *tariffKey = @"";
        if ([objectSettingsObject.fieldAPIName isEqualToString:@"In_Country__c"])
            tariffKey = @"In Country";
        else if ([objectSettingsObject.fieldAPIName isEqualToString:@"Local_Amendment__c"])
            tariffKey = @"Local Amendment";
        else if ([objectSettingsObject.fieldAPIName isEqualToString:@"Urgent_Processing__c"])
            tariffKey = @"Urgent Processing";
        else if ([objectSettingsObject.fieldAPIName isEqualToString:@"Urgent_Stamping__c"])
            tariffKey = @"Urgent Stamping";
        
        
        NSString *defaultValue = [objectSettingsObject.defaultValue isEqualToString:@"true"] ? @"1" : @"0";
        
        EServiceAdministration *tariff = [tariffDictionary objectForKey:tariffKey];
        NSString *tariffFee = [HelperClass formatNumberToString:[NSNumber numberWithInteger:0] FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2];
        if (tariff)
            tariffFee = [HelperClass formatNumberToString:tariff.amount FormatStyle:NSNumberFormatterDecimalStyle MaximumFractionDigits:2];
        
        NSString *fieldLabel = [NSString stringWithFormat:@"%@ (AED %@)", NSLocalizedString(objectSettingsObject.fieldAPIName, @""), tariffFee];
        
        FormField *objectSettingFormField = [[FormField alloc] initFormField:@"" Name:objectSettingsObject.fieldAPIName Type:@"BOOLEAN" MobileLabel:fieldLabel FieldValue:defaultValue IsParameter:!objectSettingsObject.editable IsRequired:NO];
        
        [formFieldsMutableArray addObject:objectSettingFormField];
        
    }
    
    self.baseServicesViewController.currentWebForm = [WebForm new];
    self.baseServicesViewController.currentWebForm.formFields = [NSArray arrayWithArray:formFieldsMutableArray];
    self.baseServicesViewController.currentWebForm.objectName = @"Visa__c";
    self.baseServicesViewController.createServiceRecord = NO;
    self.baseServicesViewController.currentServiceAdministration = selectedEServiceAdministrator;
    self.baseServicesViewController.serviceFieldCaseObjectName = @"Visa_Ref__c";
    
    [self.baseServicesViewController nextButtonClicked:ServiceFlowInitialPage];
}

- (void)showVisaFields {
    NSMutableArray *formFieldsMutableArray = [NSMutableArray new];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"EmployeeDetailsTitle" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"EmployeeDetailsTitle", @"") FieldValue:@"" IsParameter:YES]];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Full_Name__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeName", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantFullName IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Full_Name_Arabic__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeArabicName", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantFullNameArabic IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Gender__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeGender", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantGender IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Date_of_Birth__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeDateOfBirth", @"") FieldValue:[HelperClass formatDateToString:self.baseServicesViewController.renewedVisaObject.dateOfBirth] IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Country_of_Birth__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeCountryOfBirth", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.countryOfBirth.name IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Place_of_Birth__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeePlaceOfBirth", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.placeOfBirth IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Email__c" Type:@"EMAIL" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeEmail", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantEmail IsParameter:NO IsRequired:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Applicant_Mobile_Number__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeMobile", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.applicantMobileNumber IsParameter:NO IsRequired:YES]];
    
    FormField *maritalStatus = [[FormField alloc] initFormField:@"" Name:@"Marital_Status__c" Type:@"PICKLIST" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeMaritalStatus", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.maritalStatus IsParameter:NO IsRequired:YES];
    NSArray *maritalStatusValues = @[@"Single", @"Married", @"Divorced", @"Widowed"];
    [maritalStatus setPicklistNamesDictionary:@{maritalStatus.name:maritalStatusValues} PicklistValuesDictionary:@{maritalStatus.name:maritalStatusValues}];
    [maritalStatus setPicklistLabel:self.baseServicesViewController.renewedVisaObject.maritalStatus];
    [formFieldsMutableArray addObject:maritalStatus];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Mother_Name__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeMotherName", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.motherName IsParameter:NO IsRequired:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Current_Nationality__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeCurrentNationality", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.currentNationality.name IsParameter:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Previous_Nationality__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeePreviousNationality", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.previousNationality.name IsParameter:YES]];
    
    FormField *religion = [[FormField alloc] initFormField:@"" Name:@"Religion__c" Type:@"PICKLIST" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeReligion", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.religion IsParameter:NO IsRequired:YES];
    NSArray *religionStatusValues = @[@"Bahaei", @"Budhist", @"Christian", @"Hindu", @"Kadiani", @"Muslim", @"Sikh"];
    [religion setPicklistNamesDictionary:@{religion.name:religionStatusValues} PicklistValuesDictionary:@{religion.name:religionStatusValues}];
    [religion setPicklistLabel:self.baseServicesViewController.renewedVisaObject.religion];
    [formFieldsMutableArray addObject:religion];
    
    FormField *languages = [[FormField alloc] initFormField:@"" Name:@"Languages__c" Type:@"MULTIPICKLIST" MobileLabel:NSLocalizedString(@"EmployeeDetailsEmployeeLanguagesSpoken", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.languages IsParameter:NO IsRequired:YES];
    NSArray *languagesValues = @[@"Arabic", @"English", @"French"];
    [languages setPicklistNamesDictionary:@{languages.name:languagesValues} PicklistValuesDictionary:@{languages.name:languagesValues}];
    [languages setPicklistLabel:self.baseServicesViewController.renewedVisaObject.languages];
    [formFieldsMutableArray addObject:languages];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"PassportDetailsTitle" Type:@"CUSTOMTEXT" MobileLabel:NSLocalizedString(@"PassportDetailsTitle", @"") FieldValue:@"" IsParameter:YES]];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Passport_Number__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"PassportDetailsEmployeePassportNumber", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.passportNumber IsParameter:NO IsRequired:YES]];
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Passport_Expiry_Date__c" Type:@"DATE" MobileLabel:NSLocalizedString(@"PassportDetailsEmployeePassportPassportExpiryDate", @"") FieldValue:[SFDateUtil toSOQLDateTimeString:self.baseServicesViewController.renewedVisaObject.passportExpiry isDateTime:NO] IsParameter:NO IsRequired:YES]];
    
    FormField *passportCountry = [[FormField alloc] initFormField:@"" Name:@"Passport_Issue_Country__c" Type:@"REFERENCE" MobileLabel:NSLocalizedString(@"PassportDetailsEmployeePassportIssueCountry", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.passportIssueCountry.Id IsParameter:NO IsRequired:YES];
    passportCountry.textValue = @"Country__c";
    [formFieldsMutableArray addObject:passportCountry];
    [self.baseServicesViewController getReferencePicklistValues:passportCountry];
    
    [formFieldsMutableArray addObject:[[FormField alloc] initFormField:@"" Name:@"Passport_Place_of_Issue__c" Type:@"STRING" MobileLabel:NSLocalizedString(@"PassportDetailsEmployeePassportPassportIssuePlace", @"") FieldValue:self.baseServicesViewController.renewedVisaObject.passportPlaceOfIssue IsParameter:NO IsRequired:YES]];
    
    currentWebForm = [WebForm new];
    currentWebForm.formFields = [NSArray arrayWithArray:formFieldsMutableArray];
    
    [self initServiceFieldsContentView];
    [self.baseServicesViewController initializeButtonsWithNextAction:@selector(prepareForNextFlowPage) target:self];
    [servicesContentView drawWebform:currentWebForm
                        cancelButton:self.baseServicesViewController.cancelButton
                          nextButton:self.baseServicesViewController.nextButton];
}

- (void)initServiceFieldsContentView {
    self.servicesScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    servicesContentView = [UIView new];
    servicesContentView.backgroundColor = [UIColor clearColor];
    servicesContentView.frame = self.servicesScrollView.frame;
    
    servicesContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.servicesScrollView addSubview:servicesContentView];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(servicesContentView);
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[servicesContentView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    [self.servicesScrollView addConstraint:[NSLayoutConstraint
                                            constraintWithItem:servicesContentView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.servicesScrollView
                                            attribute:NSLayoutAttributeWidth
                                            multiplier:1
                                            constant:0.0]];
    
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[servicesContentView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    [self.servicesScrollView addConstraints:constraint_POS_H];
    [self.servicesScrollView addConstraints:constraint_POS_V];
}

- (BOOL)validateInput {
    BOOL returnValue = YES;
    for (FormField *formField in currentWebForm.formFields) {
        if(formField.required && [[formField getFormFieldValue] isEqualToString:@""])
            returnValue = NO;
    }
    
    return returnValue;
}

- (BOOL)validateEmailValues {
    BOOL returnValue = YES;
    
    for (FormField *formField in currentWebForm.formFields) {
        if ([formField.type isEqualToString:@"EMAIL"] && ![[formField getFormFieldValue] isValidEmail])
            returnValue = NO;
    }
    
    return returnValue;
}

- (void)loadObjectSettings {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSArray *objectSettingsArray = [dict objectForKey:@"records"];
        objectSettingsMutableArray = [NSMutableArray new];
        
        for (NSDictionary *obj in objectSettingsArray) {
            ObjectSettings *objectSettings = [[ObjectSettings alloc] initObjectSettings:obj];
            [objectSettingsMutableArray addObject:objectSettings];
        }
        
        loadingObjectSettings = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        loadingObjectSettings = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    NSString *relatedTo = @"eService Portal - employment - Renewal";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries objectSettingsQuery:@"Visa__c" relatedTo:relatedTo]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    loadingObjectSettings = YES;
    [self showLoadingDialog];
}

- (void)loadRecordTypes {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSMutableDictionary *mutableRecordTypesDictionary = [NSMutableDictionary new];
        
        NSArray *recordTypesArray = [dict objectForKey:@"records"];
        for (NSDictionary *obj in recordTypesArray) {
            RecordType *recordType = [[RecordType alloc] initRecordType:obj];
            [mutableRecordTypesDictionary setObject:recordType forKey:recordType.developerName];
        }
        
        recordTypesDictionary = [NSDictionary dictionaryWithDictionary:mutableRecordTypesDictionary];
        
        loadingRecordTypes = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        loadingRecordTypes = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    NSString *selectQuery = @"SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType IN ('Free_Zone_Payment__c', 'Case', 'Account', 'Visa__c') AND DeveloperName IN ('Visa_Service_Charges', 'Visa_Request', 'PersonAccount', 'Employment_Visa_Under_Renewal', 'Employment_Visa_Under_Process', 'Dependent_Visa_Under_Renewal', 'Dependent_Visa_Under_Process', 'Transfer_Visa_Under_Process', 'Visit_Visa_Under_Process')";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    loadingRecordTypes = YES;
    [self showLoadingDialog];
}

- (void)loadTariffs {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        NSMutableDictionary *mutableTariffsDictionary = [NSMutableDictionary new];
        
        NSArray *recordTypesArray = [dict objectForKey:@"records"];
        for (NSDictionary *obj in recordTypesArray) {
            EServiceAdministration *eServiceAdministration = [[EServiceAdministration alloc] initEServiceAdministration:obj];
            [mutableTariffsDictionary setObject:eServiceAdministration forKey:eServiceAdministration.serviceIdentifier];
        }
        
        tariffDictionary = [NSDictionary dictionaryWithDictionary:mutableTariffsDictionary];
        
        loadingTariffs = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        loadingTariffs = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    NSString *selectQuery = @"SELECT Id, Amount__c, Service_Identifier__c, Display_Name__c FROM Receipt_Template__c WHERE Service_Identifier__c IN ('Visit visa, multiple entry (6 Months)', 'Visit visa (3 Months)', 'Visit visa (1 Month)', 'EA-TRANSFER OF VISA' , 'EA-TRANSFER WITHIN DWC' , 'EA-DEPENDENT VISA' , 'In Country' , 'Local Amendment' , 'Urgent Processing', 'Urgent Stamping', 'Entry Permit Delivery', 'Stamped Passport Delivery', 'Employment Visa (Comprised of Entry Permit, Residence Permit and Employment Card)', 'FZ - Knowledge Trariff', 'Visit visa deposit (refundable deposit paid to immigration authorities for certain nationalities)', 'Employment Visa Renewal', 'Housemaid Residence visa renewal', 'Dependent Residence Visa Renewal')";
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    loadingTariffs = YES;
    [self showLoadingDialog];
}

- (void)loadEServiceAdministration {
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingServiceIdentifier = NO;
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        
        for (NSDictionary *recordDict in [dict objectForKey:@"records"]) {
            selectedEServiceAdministrator = [[EServiceAdministration alloc] initEServiceAdministration:recordDict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingServiceIdentifier = NO;
            [self hideLoadingDialog];
        });
    };
    
    loadingServiceIdentifier = YES;
    [self showLoadingDialog];
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries visaRenewServiceAdminQuery:self.baseServicesViewController.renewedVisaObject.serviceIdentifier]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
}

- (void)loadRenewedVisa:(NSString *)newVisaId {
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        NSArray *renewedVisaArray = [dict objectForKey:@"records"];
        
        for (NSDictionary *visaDict in renewedVisaArray) {
            self.baseServicesViewController.renewedVisaObject = [[Visa alloc] initVisa:visaDict];
        }
        
        loadingRenewedVisa = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [self showVisaFields];
            [self loadEServiceAdministration];
        });
    };
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        loadingRenewedVisa = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingDialog];
            [self.baseServicesViewController displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                                                 Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
        });
    };
    
    [[SFRestAPI sharedInstance] performSOQLQuery:[SOQLQueries renewedVisaQuery:newVisaId]
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
    loadingRenewedVisa = YES;
    [self showLoadingDialog];
}

- (void)callMobileRenewVisaWebServiceReturn {
    SFRestRequest *renewVisaRequest = [[SFRestRequest alloc] init];
    renewVisaRequest.endpoint = @"/services/apexrest/MobileRenewVisaWebService";
    renewVisaRequest.method = SFRestMethodPOST;
    renewVisaRequest.path = @"/services/apexrest/MobileRenewVisaWebService";
    renewVisaRequest.queryParams = [NSDictionary dictionaryWithObject:self.baseServicesViewController.currentVisaObject.Id forKey:@"oldVisaId"];
    
    loadingRenewVisaWebservice = YES;
    
    [self showLoadingDialog];
    [[SFRestAPI sharedInstance] send:renewVisaRequest delegate:self];
}

- (void)handleMobileRenewVisaWebServiceReturn:(id)jsonResponse {
    NSString *returnValue = [[NSString alloc] initWithData:jsonResponse encoding:NSUTF8StringEncoding];
    NSLog(@"request:didLoadResponse: %@", returnValue);
    
    loadingRenewVisaWebservice = NO;
    [self hideLoadingDialog];
    
    returnValue = [returnValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    [self loadRenewedVisa:returnValue];
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    NSLog(@"request:didLoadResponse: %@", dict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([request.path containsString:@"MobileRenewVisaWebService"])
            [self handleMobileRenewVisaWebServiceReturn:jsonResponse];
        });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([request.path containsString:@"MobileRenewVisaWebService"])
            loadingRenewVisaWebservice = NO;
        
        [self hideLoadingDialog];
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([request.path containsString:@"MobileRenewVisaWebService"])
            loadingRenewVisaWebservice = NO;
        
        [self hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([request.path containsString:@"MobileRenewVisaWebService"])
            loadingRenewVisaWebservice = NO;
        
        [self hideLoadingDialog];
        
        [HelperClass displayAlertDialogWithTitle:NSLocalizedString(@"ErrorAlertTitle", @"")
                                         Message:NSLocalizedString(@"ErrorAlertMessage", @"")];
    });
}

#pragma KeyBoard Notifications
-(void) keyboardDidShow: (NSNotification *)notif {
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
    CGRect newBiddingViewFrame = self.view.bounds;
    newBiddingViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    scrollViewOffset = self.servicesScrollView.contentOffset;
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.servicesScrollView.frame = newBiddingViewFrame;
    
    //CGRect textFieldRect = [self.answerTextView frame];
    //textFieldRect.origin.y += 10;
    //[self.servicesScrollView scrollRectToVisible:textFieldRect animated:YES];
    
    [UIView commitAnimations];
}

-(void) keyboardDidHide: (NSNotification *)notif {
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
    
    self.servicesScrollView.frame = self.view.bounds;
    
    // Reset the scrollview to previous location
    self.servicesScrollView.contentOffset = scrollViewOffset;
    
    [UIView commitAnimations];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

@end
