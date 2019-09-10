//
//  CNContactGetter.m
//  ContactFriendMaking
//
//  Created by CPU11899 on 8/1/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNContactGetter.h"

@implementation CNContactGetter

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) authorizeContactWithCompletionHandler:(void (^)(authorizationStatus))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        authorizationStatus authorizeResult;
        switch (status) {
            case CNAuthorizationStatusDenied:
                authorizeResult = AuthorizationStatusDenied;
                break;
            case CNAuthorizationStatusRestricted:
                authorizeResult = AuthorizationStatusRestricted;
                break;
            case CNAuthorizationStatusAuthorized:
                authorizeResult = AuthorizationStatusAuthorized;
                break;
            case CNAuthorizationStatusNotDetermined:
                authorizeResult = AuthorizationStatusNotDetermined;
                break;
        }
        completion(authorizeResult);
    });
}

- (void) scanContactWithCompletionHandler:(void (^)(MutableContactList * _Nullable))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MutableContactList* array = [[MutableContactList alloc] init];
        CNContactStore *addressBook = [[CNContactStore alloc] init];
        NSArray *keys = @[CNContactNamePrefixKey, CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactNameSuffixKey, CNContactPhoneNumbersKey, CNContactDatesKey, CNContactPostalAddressesKey, CNContactNicknameKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey, CNContactPreviousFamilyNameKey];
        CNContactFetchRequest *fetch = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
        [fetch setSortOrder:CNContactSortOrderUserDefault];
        [addressBook enumerateContactsWithFetchRequest:fetch error: nil usingBlock:^(CNContact* _Nonnull contact, BOOL* _Nonnull stop) {
            contactInstance* contactItem = [[contactInstance alloc] initWithCNContact:contact];// get each contact
            [array addObject:contactItem];
        }];
        completion(array);
    });
}

- (void) requestPermissionWithCompletionHandler:(void (^)(BOOL))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CNContactStore* contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError* _Nullable error) {
            completion(granted);
        }];
    });
}
@end
