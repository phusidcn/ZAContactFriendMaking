//
//  ENSMutableArray.h
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/24/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//
#import "ContactInstance.h"
#ifndef MutableContactList_h
#define MutableContactList_h
@interface MutableContactList : NSObject
@property NSMutableArray<contactInstance*>* _Nullable array;
- (instancetype _Nonnull ) init;
- (instancetype _Nonnull) initWithArray:(NSArray<contactInstance*> * _Nullable)array;
- (dispatch_queue_t _Nonnull ) safeQueue;
- (void) insertObject:(contactInstance* _Nonnull)anObject atIndex:(NSUInteger)index;
- (void) removeLastObject;
- (void) removeObjectAtIndex:(NSUInteger)index;
- (void) addObject:(contactInstance* _Nonnull )anObject;
- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(contactInstance* _Nonnull )anObject;
- (NSUInteger) count;
- (id _Nonnull ) objectAtIndex:(NSUInteger)index;
@end
#endif /* MutableContactList_h */
