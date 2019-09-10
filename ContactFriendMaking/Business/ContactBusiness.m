//
//  ContactBusiness.m
//  ContactFriendMaking
//
//  Created by Huynh Lam Phu Si on 7/28/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactBusiness.h"
@implementation ContactBussiness

- (instancetype) init {
    self = [super init];
    self.allContacts = [[NSMutableArray alloc] init];
    self.searchIndexArray = [[NSMutableArray alloc] init];
    self.selectedIndexArray = [[NSMutableArray alloc] init];
    self.dictionary = [[NSMutableDictionary alloc] init];
    self.sumOfContactToSection = [[NSMutableArray alloc] init];
    self.titleForSection = [[NSMutableArray alloc] init];
    return self;
}

- (dispatch_queue_t) safeDispatchQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.safe.thread", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

- (contactWithStatus*) contactAtIndex:(NSUInteger)index {
    __block contactWithStatus* result;
    dispatch_sync([self safeDispatchQueue], ^{
        result = [[self allContacts] objectAtIndex:index];
    });
    return result;
}

- (void) groupContactToSectionWithCompletion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync([self safeDispatchQueue], ^{
            NSUInteger i = 0;
            [[self sumOfContactToSection] addObject:[NSNumber numberWithInteger:0]];
            while (i < self.allContacts.count) {
                NSMutableArray* contactGroup = [[NSMutableArray alloc] init];
                contactWithStatus* firstGroupContact = [[self allContacts] objectAtIndex:i];
                NSString* groupLabel = [[[firstGroupContact instance] familyName] substringToIndex:1];
                do {
                    contactWithStatus* contact = [[self allContacts] objectAtIndex:i];
                    if ([groupLabel isEqualToString:[[[contact instance] familyName] substringToIndex:1]]) {
                        [contactGroup addObject:contact];
                        i++;
                    } else {
                        break;
                    }
                } while (i < self.allContacts.count);
                [[self dictionary] setObject:contactGroup forKey:groupLabel];
                [[self sumOfContactToSection] addObject:[NSNumber numberWithInteger:i]];
                [[self titleForSection] addObject:groupLabel];
            }
            completion();
        });
    });
}

- (void) getAllContacInDevicetWithCompletionHandler:(void (^)(BOOL))completion {
    contactAdapter* adapter = [[contactAdapter alloc] init];
    [adapter authorizeContactWithCompletionHandler:^(authorizationStatus status) {
        switch (status) {
            case AuthorizationStatusDenied:
                completion(false);
                break;
            case AuthorizationStatusRestricted:
                completion(false);
                break;
            case AuthorizationStatusAuthorized:
            {
                [adapter scanContactWithCompletionHandler:^(MutableContactList* _Nonnull contacts) {
                    for (int i = 0; i < [contacts count]; i++) {
                        contactWithStatus* contactItem = [[contactWithStatus alloc] initContact:[[contacts array] objectAtIndex:i] WithIsSelected:false];
                        [[self allContacts] addObject:contactItem];
                    }
                    completion(true);
                }];
                break;
            }
            case AuthorizationStatusNotDetermined:
            {
                [adapter requestPermissionWithCompletionHandler:^(BOOL granted) {
                    if (granted) {
                        [adapter scanContactWithCompletionHandler:^(MutableContactList* _Nonnull contacts) {
                            for (int i = 0; i < self.allContacts.count; i++) {
                                contactWithStatus* contactItem = [[contactWithStatus alloc] initContact:[[contacts array] objectAtIndex:i] WithIsSelected:false];
                                [[self allContacts] addObject:contactItem];
                            }
                            completion(true);
                        }];
                    } else {
                        completion(false);
                    }
                }];
                break;
            }
        }
    }];
}

- (void) searchContactWithKey:(NSString *)key completion:(void(^)(NSError*))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_barrier_async([self safeDispatchQueue], ^{
            contactUtility* utility = [[contactUtility alloc] init];
            for (int i = 0; i < [[self allContacts] count]; i++) {
                NSString* fullName = [utility getContactFullNameOf:[[self allContacts] objectAtIndex:i]];
                if ([fullName containsString:key]) {
                    [[self searchIndexArray] addObject:[NSNumber numberWithInt:i]];
                }
            }
            completion(nil);
        });
    });
}

- (void) cancelSearch {
    [[self searchIndexArray] removeAllObjects];
}

- (NSIndexPath*) convertIndexToIndexPath:(NSUInteger)index {
    NSUInteger i = 0;
    while ([[[self sumOfContactToSection] objectAtIndex:i] integerValue] < index) {
        i++;
    }
    if (index < [[[self sumOfContactToSection] objectAtIndex:i] integerValue]) {
        i--;
    }
    NSUInteger rowInSection = index - [[[self sumOfContactToSection] objectAtIndex:i] integerValue];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowInSection inSection:i];
    return indexPath;
}

- (NSUInteger) convertIndexPathToIndex:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    NSUInteger sumOfContactBeforeSection = [[[self sumOfContactToSection] objectAtIndex:section] integerValue] + row;
    return sumOfContactBeforeSection;
}

- (void) selectOneContactAtIndex:(NSIndexPath*) indexPath completion:(void(^)(NSError*))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_barrier_async([self safeDispatchQueue], ^{
            if (indexPath.row < self.titleForSection.count ) {
                NSUInteger indexOfContact = [self convertIndexPathToIndex:indexPath];
                NSString* key = [NSString stringWithString:[[self titleForSection] objectAtIndex:indexPath.section]];
                [[[[self dictionary] objectForKey:key] objectAtIndex:indexPath.row] setIsSelected:true];
                [[[self allContacts] objectAtIndex:indexOfContact] setIsSelected:true];
                BOOL inserted = false;
                for (int i = 0; i < self.selectedIndexArray.count; i++) {
                    NSUInteger indexValue = [[[self selectedIndexArray] objectAtIndex:i] integerValue];
                    if (indexValue > indexOfContact) {
                        [[self selectedIndexArray] insertObject:[NSNumber numberWithInteger:indexOfContact] atIndex:i];
                        inserted = true;
                        break;
                    }
                }
                if (!inserted) {
                    [[self selectedIndexArray] addObject:[NSNumber numberWithInteger:indexOfContact]];
                }
                completion(nil);
            } else {
                NSError* error = [NSError errorWithDomain:@"com.contact.friend.making" code:1 userInfo:@{@"Error":@"Selected index out of range"}];
                completion(error);
            }
        });
    });
}

- (void) deselectContactAtIndex:(NSIndexPath*) indexPath completion:(void(^)(NSError* ))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_barrier_async([self safeDispatchQueue], ^{
            if (indexPath.section < self.titleForSection.count) {
                NSString* key = [NSString stringWithString:[[self titleForSection] objectAtIndex:indexPath.section]];
                NSUInteger indexOfContact = [self convertIndexPathToIndex:indexPath];
                [[[[self dictionary] objectForKey:key] objectAtIndex:indexPath.row] setIsSelected:false];
                [[[self allContacts] objectAtIndex:indexOfContact] setIsSelected:false];
                for (int i = 0; i < self.selectedIndexArray.count; i++) {
                    NSUInteger indexValue = [[[self selectedIndexArray] objectAtIndex:i] integerValue];
                    if (indexValue == indexOfContact) {
                        [[self selectedIndexArray] removeObjectAtIndex:i];
                    }
                }
                completion(nil);
            } else {
                NSError* error = [NSError errorWithDomain:@"com.contact.friend.making" code:1 userInfo:@{@"Error":@"Deselected index out of range"}];
                completion(error);
            }
        });
    });
}

- (void) selectSearchedContactAt:(NSIndexPath*) index completion:(void(^)(NSError*))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_barrier_async([self safeDispatchQueue], ^{
            NSUInteger row = index.row;
            NSUInteger section = index.section;
            if (section < self.titleForSection.count) {
                NSUInteger indexValue = [[[self searchIndexArray] objectAtIndex:row] integerValue];
                NSIndexPath* indexPath = [self convertIndexToIndexPath:indexValue];
                [self selectOneContactAtIndex:indexPath completion:^(NSError* error) {
                    completion(error);
                }];
            } else {
                NSError* error = [NSError errorWithDomain:@"com.contact.friend.making" code:2 userInfo:@{@"Error":@"Selecte out of range searched index"}];
                completion(error);
            }
        });
    });
}

- (void) deselectSearchedContactAt:(NSIndexPath*)index completion:(void(^)(NSError*))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_barrier_async([self safeDispatchQueue], ^{
            NSUInteger row = index.row;
            NSUInteger section = index.section;
            if (section < self.titleForSection.count) {
                NSUInteger indexValue = [[[self searchIndexArray] objectAtIndex:row] integerValue];
                NSIndexPath* indexPath = [self convertIndexToIndexPath:indexValue];
                [self deselectContactAtIndex:indexPath completion:^(NSError* error) {
                    completion(error);
                }];
            } else {
                NSError* error = [NSError errorWithDomain:@"com.contact.friend.making" code:2 userInfo: @{@"Error":@"Deseletected out of range searched index"}];
                completion(error);
            }
        });
    });
}

- (void) getSelectedContactWithCompletionHandler:(void (^)(NSArray<contactWithStatus *> * _Nonnull))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_barrier_async([self safeDispatchQueue], ^{
            NSMutableArray<contactWithStatus*>* result = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.selectedIndexArray.count; i++) {
                NSUInteger index = [[[self selectedIndexArray] objectAtIndex:i] integerValue];
                [result addObject:[[self allContacts] objectAtIndex:index]];
            }
            completion(result);
        });
    });
}

- (void) getSearchedContactWithCompletionHandler:(void (^)(NSArray<contactWithStatus *> *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<contactWithStatus*>* result = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.searchIndexArray.count; i++) {
            NSUInteger index = [[[self searchIndexArray] objectAtIndex:i] integerValue];
            [result addObject:[[self allContacts] objectAtIndex:index]];
        }
        completion(result);
    });
}

- (void) chooseContactIsSelectedAt:(NSUInteger)index completion:(void (^)(NSUInteger))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_barrier_async([self safeDispatchQueue], ^{
            completion([[[self selectedIndexArray] objectAtIndex:index] integerValue]);
        });
    });
}

- (NSUInteger) numberOfAllContact {
    return  self.allContacts.count;
}

- (NSUInteger) numberOfContactWithSelectedStatus:(BOOL)select {
    if (select) {
        return self.selectedIndexArray.count;
    } else {
        return self.allContacts.count - self.selectedIndexArray.count;
    }
}

- (NSUInteger) numberOfContactWithSearchingStatus:(BOOL)search {
    if (search) {
        return self.searchIndexArray.count;
    } else {
        return self.allContacts.count - self.searchIndexArray.count;
    }
}

@end
