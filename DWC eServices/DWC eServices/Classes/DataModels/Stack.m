//
//  Stack.m
//  DWC eServices
//
//  Created by Mina Zaklama on 2/20/15.
//  Copyright (c) 2015 Cloud Concept. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (id)init {
    if ((self = [self initWithArray:nil])) {
    }
    return self;
}

- (id)initWithArray:(NSArray*)array {
    if ((self = [super init])) {
        stackMutableArray = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

- (NSUInteger)count {
    return stackMutableArray.count;
}

- (void)pushObject:(id)object {
    if (object) {
        [stackMutableArray addObject:object];
    }
}

- (void)pushObjects:(NSArray*)objects {
    for (id object in objects) {
        [self pushObject:object];
    }
}

- (id)popObject {
    if (stackMutableArray.count > 0) {
        id object = [stackMutableArray objectAtIndex:(stackMutableArray.count - 1)];
        [stackMutableArray removeLastObject];
        return object;
    }
    return nil;
}

- (id)peekObject {
    if (stackMutableArray.count > 0) {
        id object = [stackMutableArray objectAtIndex:(stackMutableArray.count - 1)];
        return object;
    }
    return nil;
}

- (BOOL)isEmpty{
    return stackMutableArray.count == 0;
}

@end
