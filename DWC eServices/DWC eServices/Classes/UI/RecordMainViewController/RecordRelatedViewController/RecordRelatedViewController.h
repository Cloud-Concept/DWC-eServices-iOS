//
//  RecordRelatedViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/4/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordRelatedViewController : UIViewController
{
    NSArray *relatedServicesArray;
    
    UIView *servicesContentView;
}

@property (nonatomic) NSUInteger RelatedServicesMask;

@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;

@end
