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

static NSString *visaEmployeesQuery = @"SELECT Id, Employee_ID__c, Personal_Photo__c, Salutation_Arabic__c, Applicant_Middle_Name_Arabic__c, Applicant_Last_Name_Arabic__c, Applicant_First_Name_Arabic__c, Religion__c, Applicant_Email__c, Applicant_Mobile_Number__c, Applicant_Gender__c, Passport_Country__c, Passport_Number__c, Passport_Expiry__c, Date_of_Birth__c, Salutation__c, Visa_Type__c, Visa_Expiry_Date__c,  Applicant_Full_Name__c, Visa_Validity_Status__c, Accompanied_By__c, Visit_Visa_Duration__c, Country_of_Birth__r.Id, Country_of_Birth__r.Name, Current_Nationality__r.Id, Current_Nationality__r.Name, Job_Title_at_Immigration__r.Id, Job_Title_at_Immigration__r.Name, Sponsoring_Company__c, Sponsoring_Company__r.Name, Visa_Holder__c, Visa_Holder__r.Name, Visa_Holder__r.BillingCity, Visa_Holder__r.BillingCountryCode FROM Visa__c WHERE Sponsoring_Company__c = '%@' %@ ORDER BY Applicant_Full_Name__c";

static NSString *permanentEmployeeFilter = @" AND Visa_Validity_Status__c IN ('Issued', 'Expired', 'Cancelled', 'Under Process', 'Under Renewal') AND Visa_Type__c IN ('Employment', 'Transfer - External', 'Transfer - Internal')";

static NSString *visitVisaFilter = @" AND Visa_Type__c in ('Visit')";

static NSString *contractorsQuery = @"SELECT Id, Name, Personal_Photo__c, Card_Number__c, Status__c, Sponsor__c, Card_Type__c, Salutation__c, Card_Expiry_Date__c, Card_Issue_Date__c, Full_Name__c, Designation__c, Duration__c, Passport_Number__c, RecordType.Id, RecordType.Name, RecordType.DeveloperName, Nationality__r.Id, Nationality__r.Name FROM Card_Management__c WHERE Account__c = '%@' and Status__c NOT IN ('Renewed') ORDER BY Full_Name__c";

static NSString *serviceTypesQuery = @"SELECT ID, Name, Service_Identifier__c, Amount__c, Related_to_Object__c, New_Edit_VF_Generator__c, Renewal_VF_Generator__c, Replace_VF_Generator__c, Cancel_VF_Generator__c, Record_Type_Picklist__c, (SELECT ID, Name, Type__c, Language__c, Document_Type__c, Authority__c FROM eServices_Document_Checklists__r) FROM Receipt_Template__c WHERE Is_Active__c = true %@ ORDER BY Service_Identifier__c";

static NSString *employeeNOCTypesFilter = @"AND Related_to_Object__c = 'NOC' AND RecordType.DeveloperName = 'Auto_Generated_Invoice' AND NOC_Type__c = 'Employee'";
static NSString *companyNOCTypesFilter = @"AND Related_to_Object__c = 'NOC' AND RecordType.DeveloperName = 'Auto_Generated_Invoice' AND NOC_Type__c = 'Company'";
static NSString *cardTypesFilter = @"AND Duration__c = '%@' AND Record_Type_Picklist__c = '%@'";

static NSString *caseReviewQuery = @"SELECT CaseNumber, CreatedDate, Status, Type, NOC__r.isCourierRequired__c, (SELECT ID, Amount__c FROM Invoices__r)";

static NSString *cardCaseReviewQuery = @"SELECT CaseNumber, CreatedDate, Status, Type, Card_Management__r.Duration__c, Card_Management__r.Card_Type__c, (SELECT ID, Amount__c FROM Invoices__r)";

static NSString *myRequestsQuery = @"SELECT Id, CaseNumber, Status, Web_Form__c, CreatedDate, RecordType.Id, RecordType.Name, RecordType.DeveloperName, RecordType.SobjectType FROM Case WHERE AccountId = '%@' AND Web_Form__c != ''";

static NSString *companyShareholdersQuery = @"SELECT Id, No_of_Shares__c, Ownership_of_Share__c, Shareholder__r.Id, Shareholder__r.Name, Shareholder_Status__c, Ownership_End_Date__c, Ownership_Start_Date__c FROM Share_Ownership__c WHERE Company__c = '%@'";

static NSString *companyManagersQuery = @"SELECT Id, Manager__r.Id, Manager__r.Name, Manager_Status__c, Manager_Start_Date__c, Manager_End_Date__c, Role__c, Status__c FROM Management_Member__c WHERE Company__c = '%@'";

static NSString *companyDirectorsQuery = @"SELECT Id, Roles__c, Director_Status__c, Directorship_End_Date__c, Directorship_Start_Date__c, Director__r.Id, Director__r.Name FROM Directorship__c WHERE Company__c = '%@'";

static NSString *companyLegalRepresentativesQuery = @"SELECT Id, Legal_Representative__r.Id, Legal_Representative__r.Name, Status__c, Legal_Representative_End_Date__c, Legal_Representative_Start_Date__c FROM Legal_Representative__c WHERE Company__c = '%@'";

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
    
    NSMutableString *queryString = [NSMutableString stringWithString:caseReviewQuery];
    
    
    NSString *relationName = [RelatedObject stringByReplacingOccurrencesOfString:@"__c" withString:@"__r"];
    
    for (FormField *field in formFieldsArray) {
        
        if ([field.type isEqualToString:@"CUSTOMTEXT"])
            continue;
        
        NSString *fieldName = [NSString stringWithFormat:@", %@.%@", relationName, field.name];
        
        if (![queryString containsString:fieldName]) {
            [queryString appendString:fieldName];
        }
        
    }
    
    [queryString appendFormat:@" FROM Case WHERE Id = '%@'", caseId];
    
    return queryString;
}

+ (NSString *)myRequestsQuery {
    return [NSString stringWithFormat:myRequestsQuery, [Globals currentAccount].Id];
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

@end
