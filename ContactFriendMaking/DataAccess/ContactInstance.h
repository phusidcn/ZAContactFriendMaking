//
//  ContactInstance.h
//  ContactFriendMaking
//
//  Created by Huynh Lam Phu Si on 7/27/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#ifndef ContactInstance_h
#define ContactInstance_h
@interface contactInstance : NSObject
@property (nonatomic) NSString* givenName;
@property (nonatomic) NSString* familyName;
@property (nonatomic) NSString* namePrefix;
@property (nonatomic) NSString* nameSuffix;
@property (nonatomic) NSString* phoneNumber;
- (instancetype) init;
- (instancetype) initWithCNContact:(CNContact*) contact;
- (instancetype) initWithABAddressBook:(ABRecordRef*) person;
@end
#endif /* ContactInstance_h */
