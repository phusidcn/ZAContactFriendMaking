//
//  contactInstance.m
//  ContactFriendMaking
//
//  Created by Huynh Lam Phu Si on 7/27/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactInstance.h"
@implementation contactInstance
- (instancetype) init {
    self = [super init];
    return self;
}
- (instancetype) initWithCNContact:(CNContact *)contact {
    self = [super init];
    if (self) {
        [self setGivenName:[contact givenName]];
        [self setFamilyName:[contact familyName]];
        [self setNamePrefix:[contact namePrefix]];
        [self setNameSuffix:[contact nameSuffix]];
        NSString* phoneNumber = contact.phoneNumbers.firstObject.value.stringValue;
        [self setPhoneNumber:phoneNumber];
    }
    return self;
}

- (instancetype) initWithABAddressBook:(ABRecordRef *)person {
    self = [super init];
    if (self) {
        self.givenName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        self.familyName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        self.namePrefix = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonPrefixProperty));
        self.nameSuffix = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonSuffixProperty));
        self.phoneNumber = (__bridge NSString*)(ABRecordCopyValue(person, _phoneNumber));
    }
    return self;
}
@end
