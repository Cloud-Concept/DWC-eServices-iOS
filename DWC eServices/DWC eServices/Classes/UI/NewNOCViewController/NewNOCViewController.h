//
//  NewNOCViewController.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/9/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFrontRevealViewController.h"

@interface NewNOCViewController : BaseFrontRevealViewController
{
        NSMutableArray *nocTypesArray;
}

- (IBAction)chooseNOCTypeButtonClicked:(id)sender;
@end
