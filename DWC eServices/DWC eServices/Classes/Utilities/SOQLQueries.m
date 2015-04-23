//
//  SOQLQueries.m
//  DWC eServices
//
//  Created by Mina Zaklama on 1/29/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "SOQLQueries.h"
#import "Globals.h"
#import "Account.h"
#import "FormField.h"

@implementation SOQLQueries

static NSString *visaEmployeesQuery = @"SELECT Id, Employee_ID__c, Personal_Photo__c, Salutation_Arabic__c, Applicant_Middle_Name_Arabic__c, Applicant_Last_Name_Arabic__c, Applicant_First_Name_Arabic__c, Religion__c, Applicant_Email__c, Applicant_Mobile_Number__c, Applicant_Gender__c, Passport_Country__c, Passport_Number__c, Passport_Expiry__c, Date_of_Birth__c, Salutation__c, Visa_Type__c, Visa_Expiry_Date__c,  Applicant_Full_Name__c, Visa_Validity_Status__c, Accompanied_By__c, Visit_Visa_Duration__c, Country_of_Birth__r.Id, Country_of_Birth__r.Name, Current_Nationality__r.Id, Current_Nationality__r.Name, Job_Title_at_Immigration__r.Id, Job_Title_at_Immigration__r.Name, Sponsoring_Company__c, Sponsoring_Company__r.Name, Visa_Holder__c, Visa_Holder__r.Id, Visa_Holder__r.Name, Visa_Holder__r.BillingCity FROM Visa__c WHERE Sponsoring_Company__c = '%@' %@ ORDER BY Applicant_Full_Name__c LIMIT %%d OFFSET %%d";

static NSString *permanentEmployeeFilter = @" AND Visa_Validity_Status__c IN ('Issued', 'Expired', 'Cancelled', 'Under Process', 'Under Renewal') AND Visa_Type__c IN ('Employment', 'Transfer - External', 'Transfer - Internal')";

static NSString *visitVisaFilter = @" AND Visa_Type__c in ('Visit')";

static NSString *contractorsQuery = @"SELECT Id, Name, Personal_Photo__c, Card_Number__c, Status__c, Sponsor__c, Card_Type__c, Salutation__c, Card_Expiry_Date__c, Card_Issue_Date__c, Full_Name__c, Designation__c, Duration__c, Passport_Number__c, RecordType.Id, RecordType.Name, RecordType.DeveloperName, Nationality__r.Id, Nationality__r.Name FROM Card_Management__c WHERE Account__c = '%@' and Status__c NOT IN ('Renewed') AND Card_Type__c NOT IN ('Employee Card','Student Card') ORDER BY Full_Name__c LIMIT %%d OFFSET %%d";

static NSString *serviceTypesQuery = @"SELECT ID, Name, Display_Name__c, Service_Identifier__c, Amount__c, Total_Amount__c, Related_to_Object__c, New_Edit_VF_Generator__c, Renewal_VF_Generator__c, Replace_VF_Generator__c, Cancel_VF_Generator__c, Record_Type_Picklist__c, (SELECT ID, Name, Type__c, Language__c, Document_Type__c, Authority__c FROM eServices_Document_Checklists__r) FROM Receipt_Template__c WHERE Is_Active__c = true %@ ORDER BY Service_Identifier__c";

static NSString *employeeNOCTypesFilter = @"AND Related_to_Object__c = 'NOC' AND RecordType.DeveloperName = 'Service_Request' AND NOC_Type__c = 'Employee' AND isAvailableOnPortal__c = true AND New_Edit_VF_Generator__c != null";
static NSString *companyNOCTypesFilter = @"AND Related_to_Object__c = 'NOC' AND RecordType.DeveloperName = 'Service_Request' AND NOC_Type__c = 'Company' AND isAvailableOnPortal__c = true AND New_Edit_VF_Generator__c != null";
static NSString *cardTypesFilter = @"AND Duration__c = '%@' AND Record_Type_Picklist__c = '%@'";

static NSString *caseReviewQuery = @"SELECT CaseNumber, CreatedDate, Status, Type, isCourierRequired__c, Employee_Ref__r.Id, Employee_Ref__r.Name, (SELECT ID, Name, Status__c, Amount__c FROM Invoices__r), (SELECT ID, Name, Status__c, Amount__c FROM Invoices1__r)";

static NSString *cardCaseReviewQuery = @"SELECT CaseNumber, CreatedDate, Status, Type, Card_Management__r.Duration__c, Card_Management__r.Card_Type__c, (SELECT ID, Amount__c FROM Invoices__r)";

static NSString *myRequestsQuery = @"SELECT Id, CaseNumber, Status, Type, Web_Form__c, CreatedDate, RecordType.Id, RecordType.Name, RecordType.DeveloperName, RecordType.SobjectType, Employee_Ref__r.Id, Employee_Ref__r.Name FROM Case WHERE AccountId = '%@' ORDER BY CreatedDate DESC LIMIT %d OFFSET %d";

static NSString *companyShareholdersQuery = @"SELECT Id, No_of_Shares__c, Ownership_of_Share__c, Shareholder__r.Id, Shareholder__r.Name, Shareholder__r.Nationality__c, Shareholder__r.Current_Passport__r.Id, Shareholder__r.Current_Passport__r.Name, Shareholder__r.Current_Passport__r.Passport_Expiry_Date__c, Shareholder__r.Current_Passport__r.Passport_Issue_Date__c, Shareholder__r.Current_Passport__r.Passport_Type__c, Shareholder__r.Current_Passport__r.Passport_Place_of_Issue__c, Shareholder_Status__c, Ownership_End_Date__c, Ownership_Start_Date__c FROM Share_Ownership__c WHERE Company__c = '%@' ORDER BY Shareholder__r.Name LIMIT %%d OFFSET %%d";

static NSString *companyManagersQuery = @"SELECT Id, Manager__r.Id, Manager__r.Name, Manager_Status__c, Manager__r.Nationality__c, Manager__r.Current_Passport__r.Id, Manager__r.Current_Passport__r.Name, Manager__r.Current_Passport__r.Passport_Expiry_Date__c, Manager__r.Current_Passport__r.Passport_Issue_Date__c, Manager__r.Current_Passport__r.Passport_Type__c, Manager__r.Current_Passport__r.Passport_Place_of_Issue__c, Manager_Start_Date__c, Manager_End_Date__c, Role__c, Status__c FROM Management_Member__c WHERE Company__c = '%@' ORDER BY Manager__r.Name LIMIT %%d OFFSET %%d";

static NSString *companyDirectorsQuery = @"SELECT Id, Roles__c, Director_Status__c, Directorship_End_Date__c, Directorship_Start_Date__c, Director__r.Id, Director__r.Name, Director__r.Nationality__c, Director__r.Current_Passport__r.Id, Director__r.Current_Passport__r.Name, Director__r.Current_Passport__r.Passport_Expiry_Date__c, Director__r.Current_Passport__r.Passport_Issue_Date__c, Director__r.Current_Passport__r.Passport_Type__c, Director__r.Current_Passport__r.Passport_Place_of_Issue__c FROM Directorship__c WHERE Company__c = '%@' ORDER BY Director__r.Name LIMIT %%d OFFSET %%d";

static NSString *companyLegalRepresentativesQuery = @"SELECT Id, Legal_Representative__r.Id, Legal_Representative__r.Name, Legal_Representative__r.Nationality__c, Legal_Representative__r.Current_Passport__r.Id, Legal_Representative__r.Current_Passport__r.Name, Legal_Representative__r.Current_Passport__r.Passport_Expiry_Date__c, Legal_Representative__r.Current_Passport__r.Passport_Issue_Date__c, Legal_Representative__r.Current_Passport__r.Passport_Type__c, Legal_Representative__r.Current_Passport__r.Passport_Place_of_Issue__c, Status__c, Role__c, Legal_Representative_End_Date__c, Legal_Representative_Start_Date__c FROM Legal_Representative__c WHERE Company__c = '%@' ORDER BY Legal_Representative__r.Name LIMIT %%d OFFSET %%d";

static NSString *licenseActivityQuery = @"SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Original_Business_Activity__r.Id, Original_Business_Activity__r.Name, Original_Business_Activity__r.License_Type__c, Original_Business_Activity__r.Business_Activity_Name__c, Original_Business_Activity__r.Business_Activity_Name_Arabic__c, Original_Business_Activity__r.Business_Activity_Description__c, Original_Business_Activity__r.Status__c FROM License_Activity__c WHERE License__c = '%@'";

static NSString *notificationsQuery = @"SELECT ID, Name, isFeedbackAllowed__c, Case_Process_Name__c, Case_Status__c, isMessageRead__c, Is_Push_Notification_Allowed__c, Notification_Message__c, Prior_Value__c, Read_Date_and_Time__c, Compiled_Message__c, Mobile_Compiled_Message__c, CreatedDate, Case__r.Id, Case__r.CaseNumber, Case__r.Case_Rating_Score__c, Case__r.Web_Form__c, Case__r.Status, Case__r.CreatedDate FROM Notification_Management__c WHERE Case__r.AccountId = '%@' AND Is_Push_Notification_Allowed__c = TRUE ORDER BY CreatedDate DESC LIMIT %d OFFSET %d";

static NSString *notificationsCountQuery = @"SELECT COUNT(ID) FROM Notification_Management__c WHERE Case__r.AccountId = '%@' AND Is_Push_Notification_Allowed__c = TRUE AND isMessageRead__c = FALSE";

static NSString *contractsQuery = @"SELECT Id, Name, Contract_Number__c, Contract_Type__c, Activated_Date__c, Total_Rent_Price__c, Contract_Duration__c, IS_BC_Contract__c, Rent_Start_date__c, Contract_Duration_Year_Month__c, Contract_Start_Date__c, Contract_Expiry_Date__c, Status__c FROM Contract_DWC__c WHERE Status__c = 'Active' AND Tenant__c = '%@' ORDER BY Name LIMIT %%d OFFSET %%d";

static NSString *dwcDocumentsQuery = @"SELECT Id, Name, Template_Name_Link__c, Available_for_Preview__c, Original_can_be_Requested__c, eService_Administration__r.New_Edit_VF_Generator__c, eService_Administration__r.Redirect_Page__c, eService_Administration__r.Id, eService_Administration__r.Related_to_Object__c, eService_Administration__r.Display_Name__c, eService_Administration__r.Record_Type_Picklist__c FROM eServices_Document_Checklist__c WHERE eService_Administration__r.Related_to_Object__c = 'Registration' AND eService_Administration__r.RecordType.DeveloperName = 'Service_Request' AND eService_Administration__r.Is_Active__c = true AND eService_Administration__r.Sub_Category__c = 'Registration Services' ORDER BY Name LIMIT %d OFFSET %d";

static NSString *customerDocumentsQuery = @"SELECT Id, Name, Customer_Document__c, Attachment_Id__c, Version__c, CreatedDate, Document_Type__c, Party__r.Id, Party__r.Name, RecordType.Id, RecordType.Name, RecordType.DeveloperName, RecordType.SObjectType, Original_Verified__c, Original_Collected__c, Required_Original__c, Verified_Scan_Copy__c, Uploaded__c, Required_Scan_copy__c FROM Company_Documents__C WHERE Company__c = '%@' ORDER BY CreatedDate LIMIT %%d OFFSET %%d";

static NSString *renewContractServiceAdminQuery = @"SELECT Id, Name, Service_Identifier__c, Amount__c, Total_Amount__c, Display_Name__c, Require_Knowledge_Fee__c, Knowledge_Fee__r.Id, Knowledge_Fee__r.Name, Knowledge_Fee__r.Amount__c FROM Receipt_Template__c WHERE Service_Identifier__c = '%@'";

static NSString *renewLicenseServiceAdminQuery = @"SELECT ID, Name, Display_Name__c, Service_Identifier__c, Amount__c, Total_Amount__c, (SELECT ID, Name, Type__c, Language__c, Document_Type__c, Authority__c FROM eServices_Document_Checklists__r WHERE Document_Required_for_Branch_or_LLC__c != '%@' AND Document_Type__c = 'Upload') FROM Receipt_Template__c WHERE Is_Active__c = true AND Service_Identifier__c = 'Annual License Renewal'";

static NSString *freeZonePaymentsQuery = @"SELECT Id, Name, CreatedDate, Transaction_Date__c, Paypal_Amount__c, Status__c, Payment_Type__c, Debit_Amount__c, Credit_Amount__c, Closing_Balance__C, Narrative__c, Effect_on_Account__c FROM Free_Zone_Payment__c WHERE Free_Zone_Customer__c = '%@' ORDER BY CreatedDate DESC LIMIT %d OFFSET %d";

+ (NSString *)visitVisaEmployeesQuery {
    return [NSString stringWithFormat:visaEmployeesQuery, [Globals currentAccount].Id, visitVisaFilter];
}

+ (NSString *)permanentEmployeesQuery {
    return [NSString stringWithFormat:visaEmployeesQuery, [Globals currentAccount].Id, permanentEmployeeFilter];
}

+ (NSString *)contractorsQuery {
    return [NSString stringWithFormat:contractorsQuery, [Globals currentAccount].Id];
}

+ (NSString *)employeeNOCTypesQuery {
    return [NSString stringWithFormat:serviceTypesQuery, employeeNOCTypesFilter];
}

+ (NSString *)companyNOCTypesQuery {
    return [NSString stringWithFormat:serviceTypesQuery, companyNOCTypesFilter];
}

+ (NSString *)cardTypeQueryForDuration:(NSString *)duration CardType:(NSString *)cardType {
    NSString *filter = [NSString stringWithFormat:cardTypesFilter, duration, cardType];
    return [NSString stringWithFormat:serviceTypesQuery, filter];
}

+ (NSString *)caseReviewQuery:(NSString *)caseId Fields:(NSArray *)formFieldsArray RelatedObject:(NSString *)RelatedObject {
    return [self caseReviewQuery:caseId Fields:formFieldsArray RelatedObject:RelatedObject AddRelatedFields:YES];
}

+ (NSString *)caseReviewQuery:(NSString *)caseId Fields:(NSArray *)formFieldsArray RelatedObject:(NSString *)RelatedObject AddRelatedFields:(BOOL)AddRelatedFields {
    
    NSMutableString *queryString = [NSMutableString stringWithString:caseReviewQuery];
    
    
    NSString *relationName = [RelatedObject stringByReplacingOccurrencesOfString:@"__c" withString:@"__r"];
    
    if (AddRelatedFields) {
        for (FormField *field in formFieldsArray) {
            
            if ([field.type isEqualToString:@"CUSTOMTEXT"])
                continue;
            
            NSString *fieldToAddToQuery;
            
            NSString *fieldName = field.name;
            if ([field.type isEqualToString:@"REFERENCE"])
                fieldName = [field.name stringByReplacingOccurrencesOfString:@"__c" withString:@"__r.Name"];
            
            if ([RelatedObject isEqualToString:@"Case"])
                fieldToAddToQuery = [NSString stringWithFormat:@", %@", fieldName];
            else
                fieldToAddToQuery = [NSString stringWithFormat:@", %@.%@", relationName, fieldName];
            
            if (![queryString containsString:fieldToAddToQuery]) {
                [queryString appendString:fieldToAddToQuery];
            }
            
        }
    }
    
    [queryString appendFormat:@" FROM Case WHERE Id = '%@'", caseId];
    
    return queryString;
}

+ (NSString *)myRequestsQueryWithLimit:(NSInteger)limit offset:(NSInteger)offset {
    return [NSString stringWithFormat:myRequestsQuery, [Globals currentAccount].Id, limit, offset];
}

+ (NSString *)companyShareholdersQuery {
    return [NSString stringWithFormat:companyShareholdersQuery, [Globals currentAccount].Id];
}

+ (NSString *)companyManagersQuery {
    return [NSString stringWithFormat:companyManagersQuery, [Globals currentAccount].Id];
}

+ (NSString *)companyDirectorsQuery {
    return [NSString stringWithFormat:companyDirectorsQuery, [Globals currentAccount].Id];
}

+ (NSString *)companyLegalRepresentativesQuery {
    return [NSString stringWithFormat:companyLegalRepresentativesQuery, [Globals currentAccount].Id];
}

+ (NSString *)licenseActivityQueryForLicenseId:(NSString *)LicenseId {
    return [NSString stringWithFormat:licenseActivityQuery, LicenseId];
}

+ (NSString *)notificationsQueryWithLimit:(NSInteger)limit offset:(NSInteger)offset {
    return [NSString stringWithFormat:notificationsQuery, [Globals currentAccount].Id, limit, offset];
}

+ (NSString *)notificationsCountQuery {
    return [NSString stringWithFormat:notificationsCountQuery, [Globals currentAccount].Id];
}

+ (NSString *)contractsQuery {
    return [NSString stringWithFormat:contractsQuery, [Globals currentAccount].Id];
}

+ (NSString *)dwcDocumentsQuery {
    return dwcDocumentsQuery;
}

+ (NSString *)customerDocumentsQuery {
    return [NSString stringWithFormat:customerDocumentsQuery, [Globals currentAccount].Id];
}

+ (NSString *)renewContractServiceAdminQuery:(NSString *)serviceIdentifier {
    return [NSString stringWithFormat:renewContractServiceAdminQuery, serviceIdentifier];
}

+ (NSString *)renewLicenseServiceAdminQuery {
    NSString *queryDocumentFilter = @"";
    if ([[Globals currentAccount].legalForm isEqualToString:@"DWC-LLC"])
        queryDocumentFilter = @"Branch";
    else if ([[Globals currentAccount].legalForm isEqualToString:@"DWC-Branch"])
        queryDocumentFilter = @"LLC";
    
    return [NSString stringWithFormat:renewLicenseServiceAdminQuery, queryDocumentFilter];
}

+ (NSString *)freeZonePaymentsQueryWithLimit:(NSInteger)limit offset:(NSInteger)offset {
    return [NSString stringWithFormat:freeZonePaymentsQuery, [Globals currentAccount].Id, limit, offset];
}
@end
