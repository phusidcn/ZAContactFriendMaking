//
//  ABAddressBookGetter.m
//  ContactFriendMaking
//
//  Created by CPU11899 on 8/1/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABAddressBookGetter.h"

@implementation ABAddressBookGetter

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) authorizeContactWithCompletionHandler:(void(^ _Nonnull)(authorizationStatus)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        authorizationStatus authorizeResult;
        switch (ABAddressBookGetAuthorizationStatus()) {
            case kABAuthorizationStatusDenied:
                authorizeResult = AuthorizationStatusDenied;
                break;
            case kABAuthorizationStatusRestricted:
                authorizeResult = AuthorizationStatusRestricted;
                break;
            case kABAuthorizationStatusAuthorized:
                authorizeResult = AuthorizationStatusAuthorized;
                break;
            case kABAuthorizationStatusNotDetermined:
                authorizeResult = AuthorizationStatusNotDetermined;
                break;
        }
        completion(authorizeResult);
    });
}

- (void) scanContactWithCompletionHandler:(void (^)(MutableContactList * _Nullable))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MutableContactList* array = [[MutableContactList alloc] init];
        ABAddressBookRef addressBook = ABAddressBookCreate();
        CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        for (int i = 0; i < numberOfPeople; i++) {
            ABRecordRef person = CFArrayGetValueAtIndex(arrayRef, i);
            contactInstance* contactItem = [[contactInstance alloc] initWithABAddressBook:person];
            [array addObject:contactItem];
        }
        completion(array);
    });
}

- (void) requestPermissionWithCompletionHandler:(void (^)(BOOL))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(BOOL granted, CFErrorRef _Nullable error) {
            completion(granted);
        });
    });
}

@end
