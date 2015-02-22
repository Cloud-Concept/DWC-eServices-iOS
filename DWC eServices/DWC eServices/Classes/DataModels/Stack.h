//
//  Stack.h
//  DWC eServices
//
//  Created by Mina Zaklama on 2/20/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject
{
    NSMutableArray *stackMutableArray;
}

@property (nonatomic) NSUInteger count;

- (id)initWithArray:(NSArray*)array;

- (void)pushObject:(id)object;
- (void)pushObjects:(NSArray*)objects;
- (id)popObject;
- (id)peekObject;

- (NSUInteger)count;

- (BOOL)isEmpty;

@end
