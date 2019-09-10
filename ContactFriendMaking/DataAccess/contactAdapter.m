//
//  contactModel.m
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

//THIS IS THE CONTACT GETTER SINGLETON TO GET ALL CONTACTS IN USER DEVICE
#import "contactAdapter.h"
#pragma mark - implementation the main method of contact list singleton
@implementation contactAdapter
// initialize the instance of singleton
- (id) init {
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

+ (id) getContactAdapter {
    static contactAdapter *list = nil;
    static dispatch_once_t onceToken; // init instance with once time in it life time
    dispatch_once(&onceToken, ^{
        list = [[self alloc] init];
    });
    return list;
}

- (void) authorizeContactWithCompletionHandler:(void (^)(authorizationStatus))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_9_0) {
            CNContactGetter* contactGetter = [[CNContactGetter alloc] init];
            [contactGetter authorizeContactWithCompletionHandler:^(authorizationStatus status) {
                completion(status);
            }];
        } else {
            ABAddressBookGetter* contactGetter = [[ABAddressBookGetter alloc] init];
            [contactGetter authorizeContactWithCompletionHandler:^(authorizationStatus status) {
                completion(status);
            }];
        }
    });
}

// scan all contact in device
- (void) scanContactWithCompletionHandler:(void (^)(MutableContactList *))completion{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_9_0) {
            CNContactGetter* contactGetter = [[CNContactGetter alloc] init];
            [contactGetter scanContactWithCompletionHandler:^(MutableContactList* contacts) {
                completion(contacts);
            }];
        } else {
            ABAddressBookGetter* contactGetter = [[ABAddressBookGetter alloc] init];
            [contactGetter scanContactWithCompletionHandler:^(MutableContactList* contacts) {
                completion(contacts);
            }];
        }
    });
}

- (void) requestPermissionWithCompletionHandler:(void (^)(BOOL))completion {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_9_0) {
            CNContactGetter* contactGetter = [[CNContactGetter alloc] init];
            [contactGetter requestPermissionWithCompletionHandler:^(BOOL granted) {
                completion(granted);
            }];
        } else {
            ABAddressBookGetter* contactGetter = [[ABAddressBookGetter alloc] init];
            [contactGetter requestPermissionWithCompletionHandler:^(BOOL granted) {
                completion(granted);
            }];
        }
    });
}

@end
