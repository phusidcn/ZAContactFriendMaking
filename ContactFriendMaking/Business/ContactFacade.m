//
//  ContactFacade.m
//  ContactFriendMaking
//
//  Created by Huynh Lam Phu Si on 7/28/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactFacade.h"
@implementation contactFacade
- (instancetype) init {
    self = [super init];
    self.bussiness = [[ContactBussiness alloc] init];
    return self;
}

- (void) allContactWithCompletion:(void (^)(NSArray<contactStatus *> * _Nullable, BOOL canGet))completion {
    [[self bussiness] getAllContactWithCompletionHandler:^(BOOL getted) {
        if (getted) {
            completion([[self bussiness] array], getted);
        } else {
            completion(nil, getted);
        }
    }];
}

- (NSUInteger) numberOfContactsWithSearchingStatus:(statusApplied)searching AndIsSelectedStatus:(statusApplied)selected {
    NSUInteger result;
    if (searching == notDetermine && selected == notDetermine) {
        result = [[self bussiness] numberOfContact];
    };
    if (selected == notDetermine) {
        if (searching == yes) {
            result = [[self bussiness] numberOfContactWithSearchingStatus:true];
        } else {
            result = [[self bussiness] numberOfContactWithSearchingStatus:false];
        }
    }
    if (searching == notDetermine) {
        if (selected == yes) {
            result = [[self bussiness] numberOfContactWithSelectedStatus:true];
        } else {
            result =  [[self bussiness] numberOfContactWithSelectedStatus:false];
        }
    }
    result = [[self bussiness] numberOfContactWithSearchingStatus:searching AndSelectedStatus:selected];
    return result;
}

- (void) searchContactWithKey:(NSString *)key completion:(void (^ _Nonnull)(NSArray<contactStatus *> * _Nullable))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self bussiness] searchContactWithKey:key completion:^(NSArray<contactStatus*>* _Nonnull contacts) {
            completion(contacts);
        }];
    });
}

- (void) selectOneContactAtIndex:(NSUInteger)index completion:(void (^ _Nonnull)(NSArray<contactStatus *> * _Nonnull))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self bussiness] selectOneContactAtIndex:index completion:^(NSArray<contactStatus*>* _Nonnull contacts) {
            completion(contacts);
        }];
    });
}

- (void) deselectctOneContactAtIndex:(NSUInteger)index completion:(void (^ _Nonnull)(NSArray<contactStatus *> * _Nonnull))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self bussiness] deselectctOneContactAtIndex:index completion:^(NSArray<contactStatus*>* _Nonnull contacts){
            completion(contacts);
        }];
    });
}
@end
