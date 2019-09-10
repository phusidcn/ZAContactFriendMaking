//
//  ENSMutableArray.m
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/24/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MutableContactList.h"
#import <Contacts/Contacts.h>
@implementation MutableContactList
//initialize the MutableContactList
- (instancetype) init {
    self = [super init];
    if (self) {
        self.array = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}
// initialize the MutableContactList with array
- (instancetype) initWithArray:(NSArray<contactInstance*> *)array {
    self = [super init];
    if (self) {
        self.array = [[NSMutableArray alloc] initWithArray:array];
        return self;
    }
    return nil;
}

//create safe queue to make list safe-thread
- (dispatch_queue_t) safeQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.safe.thread", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

//count the number of contact in list
- (NSUInteger)count {
    __block NSUInteger result;
    dispatch_sync([self safeQueue], ^{
        result = [[self array] count];
    });
    return result;
}

//get an object in list
- (id)objectAtIndex:(NSUInteger)index {
    __block id result;
    dispatch_sync([self safeQueue], ^{
        NSUInteger count = [[self array] count];
        result = index < count ? [[self array] objectAtIndex:index] : nil;
    });
    return result;
}

//insert an object to list
- (void)insertObject:(contactInstance*)anObject atIndex:(NSUInteger)index {
    __block NSUInteger insertIndex = index;
    dispatch_barrier_async([self safeQueue], ^{
        if (!anObject) {
            return;
        }
        NSUInteger amountOfItems = [[self array] count];
        insertIndex = insertIndex > amountOfItems ? amountOfItems : insertIndex;
        [[self array] insertObject:anObject atIndex:index];
    });
}

// remove object away from list
- (void)removeObjectAtIndex:(NSUInteger)index {
    dispatch_barrier_async([self safeQueue], ^{
        NSUInteger count = [[self array] count];
        if (index < count) {
            [[self array] removeObjectAtIndex:index];
        }
    });
}

//add object to last of list
- (void)addObject:(contactInstance*)anObject {
    dispatch_barrier_async([self safeQueue], ^{
        if (!anObject) {
            return;
        }
        [[self array] addObject:anObject];
    });
}

//remove last object
- (void)removeLastObject {
    dispatch_barrier_async([self safeQueue], ^{
        NSUInteger amountOfItems = [[self array] count];
        if (amountOfItems > 0) {
            [[self array] removeLastObject];
        }
    });
}

// replace an object at index, if index is greater than number of objects, insert to last of list
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(contactInstance*)anObject {
    dispatch_barrier_async([self safeQueue], ^{
        if (!anObject) {
            return;
        }
        NSUInteger count = [[self array] count];
        if (index >= count) {
            return;
        }
        [[self array] replaceObjectAtIndex:index withObject:anObject];
    });
}

// remove all object from list
- (void)removeAllObjects {
    dispatch_barrier_async([self safeQueue], ^{
        [[self array] removeAllObjects];
    });
}

@end
