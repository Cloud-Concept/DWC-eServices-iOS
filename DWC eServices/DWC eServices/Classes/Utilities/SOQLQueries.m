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

@implementation SOQLQueries

static NSString *permanentEmployeesQuery = @"SELECT Id, Personal_Photo__c, Salutation_Arabic__c, Applicant_Middle_Name_Arabic__c, Applicant_Last_Name_Arabic__c, Applicant_First_Name_Arabic__c, Religion__c, Applicant_Email__c, Applicant_Mobile_Number__c, Applicant_Gender__c, Date_of_Birth__c, Salutation__c, Visa_Type__c, Visa_Expiry_Date__c,  Applicant_Full_Name__c, Visa_Validity_Status__c, Country_of_Birth__r.Id, Country_of_Birth__r.Name, Current_Nationality__r.Id, Current_Nationality__r.Name, Job_Title_at_Immigration__r.Id, Job_Title_at_Immigration__r.Name, Sponsoring_Company__c, Sponsoring_Company__r.Name, Visa_Holder__c, Visa_Holder__r.Name, Visa_Holder__r.BillingCity, Visa_Holder__r.BillingCountryCode FROM Visa__c WHERE Sponsoring_Company__c = '%@' AND Visa_Validity_Status__c in ('Issued' , 'Expired' , 'Cancelled' , 'Under Process' , 'Under Renewal') AND Visa_Type__c IN ('Employment' , 'Transfer - External' , 'Transfer - Internal') ORDER BY Applicant_Full_Name__c";

+ (NSString*)permanentEmployeesQuery {
    return [NSString stringWithFormat:permanentEmployeesQuery, [Globals currentAccount].Id];
}

@end
