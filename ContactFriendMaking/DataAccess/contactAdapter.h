//
//  contactModel.h
//  ContactFriendMaking
//
//  Created by CPU11899 on 7/22/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>
#import "PermissionStatus.h"
#import "ContactInstance.h"
#import "MutableContactList.h"
#import "contactAccessProtocol.h"
#import "../ABAddressBookComponent/ABAddressBookGetter.h"
#import "../CNContactComponent/CNContactGetter.h"
#ifndef contactModel_h
#define contactModel_h
@interface contactAdapter : NSObject <contactAccessProtocol>
+ (id _Nullable ) getContactAdapter;
- (id _Nullable ) init;
- (void) authorizeContactWithCompletionHandler:(void(^_Nonnull)(authorizationStatus)) completion;
- (void) scanContactWithCompletionHandler:(void(^ _Nonnull)(MutableContactList*_Nullable)) completion;
- (void) requestPermissionWithCompletionHandler:(void(^_Nonnull)(BOOL))completion;
@end
#endif /* contactModel_h */
